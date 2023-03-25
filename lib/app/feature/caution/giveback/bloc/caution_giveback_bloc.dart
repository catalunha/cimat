import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/caution_model.dart';
import '../../../../core/repositories/caution_repository.dart';
import '../../../../core/repositories/item_repository.dart';
import '../../../../data/b4a/entity/caution_entity.dart';
import 'caution_giveback_event.dart';
import 'caution_giveback_state.dart';

class CautionGivebackBloc
    extends Bloc<CautionGivebackEvent, CautionGivebackState> {
  final ItemRepository _itemRepository;

  final CautionRepository _cautionRepository;

  CautionGivebackBloc(
      {required ItemRepository itemRepository,
      required CautionRepository cautionRepository})
      : _itemRepository = itemRepository,
        _cautionRepository = cautionRepository,
        super(CautionGivebackState.initial()) {
    on<CautionGivebackEventGetCautions>(_onCautionGivebackEventGetCautions);
    on<CautionGivebackEventUpdateWasAcceptedWithRefused>(
        _onCautionGivebackEventUpdateWasAcceptedWithRefused);
    on<CautionGivebackEventUpdateWasAcceptedWithAccepted>(
        _onCautionGivebackEventUpdateWasAcceptedWithAccepted);
  }

  FutureOr<void> _onCautionGivebackEventGetCautions(
      CautionGivebackEventGetCautions event,
      Emitter<CautionGivebackState> emit) async {
    emit(state.copyWith(
      status: CautionGivebackStateStatus.loading,
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(CautionEntity.className));

      query.whereEqualTo('receiverIsStartGiveback', true);
      query.whereEqualTo('givebackItemWasAccepted', null);
      List<CautionModel> temp = await _cautionRepository.list(query, null);
      emit(state.copyWith(
        status: CautionGivebackStateStatus.success,
        cautionModelList: temp,
      ));
    } catch (_) {
      emit(
        state.copyWith(
            status: CautionGivebackStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onCautionGivebackEventUpdateWasAcceptedWithRefused(
      CautionGivebackEventUpdateWasAcceptedWithRefused event,
      Emitter<CautionGivebackState> emit) async {
    emit(state.copyWith(
      status: CautionGivebackStateStatus.loading,
    ));
    try {
      // _loading(true);
      DateTime now = DateTime.now();
      DateTime datetime =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      CautionModel cautionModelTemp;

      cautionModelTemp = event.cautionModel.copyWith(
        givebackUserProfile: event.userProfileGiveback,
        givebackItemWasAccepted: false,
        givebackAnalyzedItemDt: datetime,
        givebackDescription: event.description,
      );

      await _cautionRepository.update(cautionModelTemp);
      await _itemRepository.update(cautionModelTemp.item!
          .copyWith(isBlockedOperator: false, isBlockedDoc: true));

      List<CautionModel> newList = [...state.cautionModelList];
      newList.removeWhere((element) => element.id == event.cautionModel.id);
      emit(state.copyWith(
        status: CautionGivebackStateStatus.success,
        cautionModelList: newList,
      ));
    } catch (_) {
      emit(state.copyWith(
          status: CautionGivebackStateStatus.error,
          error: 'Erro ao analisar item e recusar'));
    }
  }

  FutureOr<void> _onCautionGivebackEventUpdateWasAcceptedWithAccepted(
      CautionGivebackEventUpdateWasAcceptedWithAccepted event,
      Emitter<CautionGivebackState> emit) async {
    emit(state.copyWith(
      status: CautionGivebackStateStatus.loading,
    ));
    try {
      // _loading(true);
      DateTime now = DateTime.now();
      DateTime datetime =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      CautionModel cautionModelTemp;

      cautionModelTemp = event.cautionModel.copyWith(
        givebackUserProfile: event.userProfileGiveback,
        givebackItemWasAccepted: true,
        givebackAnalyzedItemDt: datetime,
        givebackDescription: '',
      );

      await _cautionRepository.update(cautionModelTemp);
      await _itemRepository.update(cautionModelTemp.item!
          .copyWith(isBlockedOperator: false, isBlockedDoc: false));

      List<CautionModel> newList = [...state.cautionModelList];
      newList.removeWhere((element) => element.id == event.cautionModel.id);
      emit(state.copyWith(
        status: CautionGivebackStateStatus.success,
        cautionModelList: newList,
      ));
    } catch (_) {
      emit(state.copyWith(
          status: CautionGivebackStateStatus.error,
          error: 'Erro ao analisar item e recusar'));
    }
  }
}
