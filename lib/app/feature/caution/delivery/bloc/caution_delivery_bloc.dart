import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cimat/app/core/models/user_profile_model.dart';
import 'package:cimat/app/core/repositories/caution_repository.dart';
import 'package:cimat/app/core/repositories/item_repository.dart';

import '../../../../core/models/caution_model.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/repositories/user_profile_repository.dart';
import 'caution_delivery_event.dart';
import 'caution_delivery_state.dart';

class CautionDeliveryBloc
    extends Bloc<CautionDeliveryEvent, CautionDeliveryState> {
  final ItemRepository _itemRepository;
  final UserProfileRepository _userProfileRepository;
  final CautionRepository _cautionRepository;
  CautionDeliveryBloc(
      {required ItemRepository itemRepository,
      required UserProfileRepository userProfileRepository,
      required CautionRepository cautionRepository})
      : _itemRepository = itemRepository,
        _userProfileRepository = userProfileRepository,
        _cautionRepository = cautionRepository,
        super(CautionDeliveryState.initial()) {
    on<CautionDeliveryEventItemSubmitted>(_onCautionDeliveryEventItemSubmitted);
    on<CautionDeliveryEventQuantityIncrement>(
        _onCautionDeliveryEventQuantityIncrement);
    on<CautionDeliveryEventQuantityDecrement>(
        _onCautionDeliveryEventQuantityDecrement);
    on<CautionDeliveryEventUserProfileSubmitted>(
        _onCautionDeliveryEventUserProfileSubmitted);
    on<CautionDeliveryEventSendOrder>(_onCautionDeliveryEventSendOrder);
  }

  FutureOr<void> _onCautionDeliveryEventItemSubmitted(
      CautionDeliveryEventItemSubmitted event,
      Emitter<CautionDeliveryState> emit) async {
    emit(state.copyWith(
      status: CautionDeliveryStateStatus.loading,
      itemList: [],
      quantity: 0,
    ));
    try {
      if (event.serie.isNotEmpty) {
        ItemModel? itemModel = await _itemRepository.readBySerie(event.serie);
        if (itemModel != null) {
          emit(state.copyWith(
              status: CautionDeliveryStateStatus.success,
              itemList: [itemModel],
              quantity: 1));
        } else {
          emit(state.copyWith(
            status: CautionDeliveryStateStatus.error,
            error: 'Não encontrei item ou esta indisponível',
            quantity: 0,
          ));
        }
      } else if (event.lote.isNotEmpty) {
        List<ItemModel> itemList = await _itemRepository.readByLote(event.lote);
        if (itemList.isNotEmpty) {
          emit(state.copyWith(
            status: CautionDeliveryStateStatus.success,
            itemList: itemList,
            quantity: 1,
          ));
        } else {
          emit(state.copyWith(
            status: CautionDeliveryStateStatus.error,
            error: 'Não encontrei itens ou estão indisponíveis',
            quantity: 0,
          ));
        }
      } else {
        throw Exception();
      }
    } catch (_) {
      emit(state.copyWith(
        status: CautionDeliveryStateStatus.error,
        error: 'Erro em buscar item',
        quantity: 0,
      ));
    }
  }

  FutureOr<void> _onCautionDeliveryEventQuantityDecrement(
      CautionDeliveryEventQuantityDecrement event,
      Emitter<CautionDeliveryState> emit) {
    if ((state.quantity - 1) > 0) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  FutureOr<void> _onCautionDeliveryEventQuantityIncrement(
      CautionDeliveryEventQuantityIncrement event,
      Emitter<CautionDeliveryState> emit) {
    if ((state.quantity + 1) <= state.itemList.length) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  FutureOr<void> _onCautionDeliveryEventUserProfileSubmitted(
      CautionDeliveryEventUserProfileSubmitted event,
      Emitter<CautionDeliveryState> emit) async {
    emit(state.copyWith(
      status: CautionDeliveryStateStatus.loading,
      userProfileReceiver: null,
    ));
    try {
      if (event.userProfileRegister.isNotEmpty) {
        UserProfileModel? userProfileModel = await _userProfileRepository
            .readByRegister(event.userProfileRegister);
        if (userProfileModel != null) {
          emit(state.copyWith(
            status: CautionDeliveryStateStatus.success,
            userProfileReceiver: userProfileModel,
          ));
        } else {
          print('nao achei....');
          emit(state.copyWith(
            status: CautionDeliveryStateStatus.error,
            userProfileReceiver: null,
            error: 'Não encontrei operador',
          ));
        }
      } else {
        throw Exception();
      }
    } catch (_) {
      emit(state.copyWith(
        status: CautionDeliveryStateStatus.error,
        userProfileReceiver: null,
        error: 'Erro em buscar operador',
      ));
    }
  }

  FutureOr<void> _onCautionDeliveryEventSendOrder(
      CautionDeliveryEventSendOrder event,
      Emitter<CautionDeliveryState> emit) async {
    emit(state.copyWith(
      status: CautionDeliveryStateStatus.loading,
    ));
    try {
      if (state.itemList.isNotEmpty &&
          state.quantity != 0 &&
          state.userProfileReceiver != null) {
        CautionModel cautionModel;
        DateTime now = DateTime.now();
        DateTime deliveryDt =
            DateTime(now.year, now.month, now.day, now.hour, now.minute);
        for (var i = 0; i < state.quantity; i++) {
          ItemModel itemModelSend = state.itemList[i];
          cautionModel = CautionModel(
            deliveryUserProfile: event.userProfileModelDelivery,
            deliveryDt: deliveryDt,
            item: itemModelSend,
            receiverUserProfile: state.userProfileReceiver,
          );
          await _cautionRepository.update(cautionModel);
          await _itemRepository
              .update(itemModelSend.copyWith(isBlockedOperator: true));
          emit(state.copyWith(
            status: CautionDeliveryStateStatus.finish,
          ));
        }
      } else {
        emit(state.copyWith(
          status: CautionDeliveryStateStatus.error,
          error: 'Faltam dados para montar cautela',
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        status: CautionDeliveryStateStatus.error,
        error: 'Erro em montar cautela de item',
      ));
    }
  }
}
