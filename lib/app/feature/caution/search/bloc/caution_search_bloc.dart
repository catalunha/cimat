import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/caution_model.dart';
import '../../../../core/repositories/caution_repository.dart';
import '../../../../data/b4a/entity/caution_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'caution_search_event.dart';
import 'caution_search_state.dart';

class CautionSearchBloc extends Bloc<CautionSearchEvent, CautionSearchState> {
  final CautionRepository _cautionRepository;
  CautionSearchBloc({required CautionRepository cautionRepository})
      : _cautionRepository = cautionRepository,
        super(CautionSearchState.initial()) {
    on<CautionSearchEventIsOperator>(_onCautionSearchEventIsOperator);
    on<CautionSearchEventFormSubmitted>(_onCautionSearchEventFormSubmitted);
    on<CautionSearchEventPreviousPage>(_onCautionSearchEventPreviousPage);
    on<CautionSearchEventNextPage>(_onCautionSearchEventNextPage);
  }
  FutureOr<void> _onCautionSearchEventIsOperator(
      CautionSearchEventIsOperator event, Emitter<CautionSearchState> emit) {
    emit(state.copyWith(userModel: event.userModel));
  }

  FutureOr<void> _onCautionSearchEventFormSubmitted(
      CautionSearchEventFormSubmitted event,
      Emitter<CautionSearchState> emit) async {
    emit(state.copyWith(
      status: CautionSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      cautionModelList: [],
      query: QueryBuilder<ParseObject>(ParseObject(CautionEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(CautionEntity.className));

      if (event.deliveryDtSelected) {
        query.whereGreaterThanOrEqualsTo(
            'deliveryDt',
            DateTime(event.deliveryDtValue.year, event.deliveryDtValue.month,
                event.deliveryDtValue.day));
        query.whereLessThanOrEqualTo(
            'deliveryDt',
            DateTime(event.deliveryDtValue.year, event.deliveryDtValue.month,
                event.deliveryDtValue.day, 23, 59));
      } else {
        query.whereGreaterThanOrEqualsTo(
            'deliveryDt',
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day));
        query.whereLessThanOrEqualTo(
            'deliveryDt',
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 23, 59));
      }
      if (state.userModel != null) {
        query.whereEqualTo(
            'receiverUserProfile',
            (ParseObject(UserProfileEntity.className)
                  ..objectId = state.userModel!.userProfile!.id)
                .toPointer());
      }
      query.orderByDescending('updatedAt');
      List<CautionModel> cautionModelListGet = await _cautionRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );
      emit(state.copyWith(
        status: CautionSearchStateStatus.success,
        cautionModelList: cautionModelListGet,
        query: query,
      ));
    } catch (_) {
      emit(
        state.copyWith(
            status: CautionSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onCautionSearchEventPreviousPage(
      CautionSearchEventPreviousPage event,
      Emitter<CautionSearchState> emit) async {
    emit(
      state.copyWith(
        status: CautionSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<CautionModel> cautionModelListGet = await _cautionRepository.list(
        state.query,
        Pagination(page: state.page, limit: state.limit),
      );
      if (state.page == 1) {
        emit(
          state.copyWith(
            page: 1,
            firstPage: true,
            lastPage: false,
          ),
        );
      }
      emit(state.copyWith(
        status: CautionSearchStateStatus.success,
        cautionModelList: cautionModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: CautionSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onCautionSearchEventNextPage(CautionSearchEventNextPage event,
      Emitter<CautionSearchState> emit) async {
    emit(
      state.copyWith(status: CautionSearchStateStatus.loading),
    );
    List<CautionModel> cautionModelListGet = await _cautionRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (cautionModelListGet.isEmpty) {
      emit(state.copyWith(
        status: CautionSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: CautionSearchStateStatus.success,
        cautionModelList: cautionModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }
}
