import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/caution_model.dart';
import '../../../../core/repositories/caution_repository.dart';
import '../../../../data/b4a/entity/caution_entity.dart';
import '../../../../data/b4a/entity/user_profile_entity.dart';
import 'caution_receiver_event.dart';
import 'caution_receiver_state.dart';

class CautionReceiverBloc
    extends Bloc<CautionReceiverEvent, CautionReceiverState> {
  final CautionRepository _cautionRepository;

  CautionReceiverBloc({required CautionRepository cautionRepository})
      : _cautionRepository = cautionRepository,
        super(CautionReceiverState.initial()) {
    on<CautionReceiverEventGetCautions>(_onCautionReceiverEventGetCautions);
    on<CautionReceiverEventFilterChange>(_onCautionReceiverEventFilterChange);
    on<CautionReceiverEventUpdateWasAcceptedWithRefused>(
        _onCautionReceiverEventUpdateWasAcceptedWithRefused);
    on<CautionReceiverEventUpdateWasAcceptedWithAccepted>(
        _onCautionReceiverEventUpdateWasAcceptedWithAccepted);
    on<CautionReceiverEventUpdateIsStartGiveback>(
        _onCautionReceiverEventUpdateIsStartGiveback);
    on<CautionReceiverEventUpdateIsPermanentItem>(
        _onCautionReceiverEventUpdateIsPermanentItem);
  }

  FutureOr<void> _onCautionReceiverEventGetCautions(
      CautionReceiverEventGetCautions event,
      Emitter<CautionReceiverState> emit) async {
    emit(state.copyWith(
      status: CautionReceiverStateStatus.loading,
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(CautionEntity.className));

      query.whereEqualTo(
          'receiverUserProfile',
          (ParseObject(UserProfileEntity.className)
                ..objectId = event.userModel.userProfile!.id)
              .toPointer());
      query.whereEqualTo('givebackWasAccepted', null);
      List<CautionModel> temp = await _cautionRepository.list(query, null);
      List<CautionModel> tempFiltered =
          temp.where((item) => item.receiverIsPermanentItem == false).toList();
      emit(state.copyWith(
        status: CautionReceiverStateStatus.success,
        cautionModelList: temp,
        cautionModelListFiltered: tempFiltered,
        filteredIsTemporary: true,
      ));
    } catch (_) {
      emit(
        state.copyWith(
            status: CautionReceiverStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onCautionReceiverEventFilterChange(
      CautionReceiverEventFilterChange event,
      Emitter<CautionReceiverState> emit) {
    List<CautionModel> cautionTemp = [...state.cautionModelList];
    if (event.filterIsTemporary) {
      List<CautionModel> tempFiltered = cautionTemp
          .where((item) => item.receiverIsPermanentItem == false)
          .toList();
      emit(state.copyWith(
        cautionModelListFiltered: tempFiltered,
        filteredIsTemporary: event.filterIsTemporary,
      ));
    } else {
      List<CautionModel> tempFiltered = cautionTemp
          .where((item) => item.receiverIsPermanentItem == true)
          .toList();
      emit(state.copyWith(
        cautionModelListFiltered: tempFiltered,
        filteredIsTemporary: event.filterIsTemporary,
      ));
    }
  }

  FutureOr<void> _onCautionReceiverEventUpdateWasAcceptedWithRefused(
      CautionReceiverEventUpdateWasAcceptedWithRefused event,
      Emitter<CautionReceiverState> emit) async {
    emit(state.copyWith(
      status: CautionReceiverStateStatus.loading,
    ));
    try {
      // _loading(true);
      DateTime now = DateTime.now();
      DateTime datetime =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      CautionModel cautionModelTemp;

      cautionModelTemp = event.cautionModel.copyWith(
        receiverItemWasAccepted: false,
        receiverAnalyzedItemDt: datetime,
        receiverIsStartGiveback: true,
        receiverGivebackItemDt: datetime,
        receiverGivebackDescription: event.description,
      );

      await _cautionRepository.update(cautionModelTemp);
      List<CautionModel> newList = [...state.cautionModelList];
      newList.removeWhere((element) => element.id == event.cautionModel.id);
      emit(state.copyWith(
        status: CautionReceiverStateStatus.success,
        cautionModelList: newList,
      ));
      add(CautionReceiverEventFilterChange(
          filterIsTemporary: state.filteredIsTemporary));
    } catch (_) {
      emit(state.copyWith(
          status: CautionReceiverStateStatus.error,
          error: 'Erro ao analisar item e recusar'));
    }
  }

  FutureOr<void> _onCautionReceiverEventUpdateWasAcceptedWithAccepted(
      CautionReceiverEventUpdateWasAcceptedWithAccepted event,
      Emitter<CautionReceiverState> emit) async {
    emit(state.copyWith(
      status: CautionReceiverStateStatus.loading,
    ));
    try {
      // _loading(true);
      DateTime now = DateTime.now();
      DateTime datetime =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      CautionModel cautionModelTemp;

      cautionModelTemp = event.cautionModel.copyWith(
        receiverItemWasAccepted: true,
        receiverAnalyzedItemDt: datetime,
        receiverIsStartGiveback: false,
      );

      await _cautionRepository.update(cautionModelTemp);
      List<CautionModel> newList = [...state.cautionModelList];

      int index = newList.indexWhere((item) => item.id == cautionModelTemp.id);
      newList.replaceRange(index, index + 1, [cautionModelTemp]);

      emit(state.copyWith(
        status: CautionReceiverStateStatus.success,
        cautionModelList: newList,
      ));
      add(CautionReceiverEventFilterChange(
          filterIsTemporary: state.filteredIsTemporary));
    } catch (_) {
      emit(state.copyWith(
          status: CautionReceiverStateStatus.error,
          error: 'Erro ao analisar item e aceitar'));
    }
  }

  FutureOr<void> _onCautionReceiverEventUpdateIsStartGiveback(
      CautionReceiverEventUpdateIsStartGiveback event,
      Emitter<CautionReceiverState> emit) async {
    emit(state.copyWith(
      status: CautionReceiverStateStatus.loading,
    ));
    try {
      // _loading(true);
      DateTime now = DateTime.now();
      DateTime datetime =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);
      CautionModel cautionModelTemp;

      cautionModelTemp = event.cautionModel.copyWith(
        receiverIsStartGiveback: true,
        receiverGivebackItemDt: datetime,
        receiverGivebackDescription: event.description,
      );

      await _cautionRepository.update(cautionModelTemp);
      List<CautionModel> newList = [...state.cautionModelList];
      newList.removeWhere((element) => element.id == event.cautionModel.id);
      emit(state.copyWith(
        status: CautionReceiverStateStatus.success,
        cautionModelList: newList,
      ));
      add(CautionReceiverEventFilterChange(
          filterIsTemporary: state.filteredIsTemporary));
    } catch (_) {
      emit(state.copyWith(
          status: CautionReceiverStateStatus.error,
          error: 'Erro ao analisar item e recusar'));
    }
  }

  FutureOr<void> _onCautionReceiverEventUpdateIsPermanentItem(
      CautionReceiverEventUpdateIsPermanentItem event,
      Emitter<CautionReceiverState> emit) async {
    List<CautionModel> newList = [...state.cautionModelList];
    CautionModel cautionChanged;
    cautionChanged = event.cautionModel.copyWith(
        receiverIsPermanentItem: !event.cautionModel.receiverIsPermanentItem!);
    int index = newList.indexWhere((item) => item.id == event.cautionModel.id);
    newList.replaceRange(index, index + 1, [cautionChanged]);
    await _cautionRepository.update(cautionChanged);

    emit(state.copyWith(
      status: CautionReceiverStateStatus.success,
      cautionModelList: newList,
    ));
    add(CautionReceiverEventFilterChange(
        filterIsTemporary: state.filteredIsTemporary));
  }
}
