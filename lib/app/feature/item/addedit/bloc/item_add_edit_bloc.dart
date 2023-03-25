import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cimat/app/core/repositories/item_repository.dart';

import '../../../../core/models/item_model.dart';
import 'item_add_edit_event.dart';
import 'item_add_edit_state.dart';

class ItemAddEditBloc extends Bloc<ItemAddEditEvent, ItemAddEditState> {
  final ItemRepository _itemRepository;
  ItemAddEditBloc(
      {required ItemModel? itemModel, required ItemRepository itemRepository})
      : _itemRepository = itemRepository,
        super(ItemAddEditState.initial(itemModel)) {
    on<ItemAddEditEventFormSubmitted>(_onItemAddEditEventFormSubmitted);
  }

  FutureOr<void> _onItemAddEditEventFormSubmitted(
      ItemAddEditEventFormSubmitted event,
      Emitter<ItemAddEditState> emit) async {
    emit(state.copyWith(status: ItemAddEditStateStatus.loading));
    try {
      ItemModel itemModel;
      if (state.itemModel == null) {
        itemModel = ItemModel(
          description: event.description,
          serie: event.serie,
          lote: event.lote,
          brand: event.brand,
          model: event.model,
          calibre: event.calibre,
          doc: event.doc,
          obsCaution: event.obsCaution,
          validate: event.validate,
          isMunition: event.isMunition,
          isBlockedOperator: event.isBlockedOperator,
          isBlockedDoc: event.isBlockedDoc,
          groups: event.groups?.split(' '),
          image: event.imageModel,
        );
      } else {
        itemModel = state.itemModel!.copyWith(
          description: event.description,
          serie: event.serie,
          lote: event.lote,
          brand: event.brand,
          model: event.model,
          calibre: event.calibre,
          doc: event.doc,
          obsCaution: event.obsCaution,
          validate: event.validate,
          isMunition: event.isMunition,
          isBlockedOperator: event.isBlockedOperator,
          isBlockedDoc: event.isBlockedDoc,
          groups: event.groups?.split(' '),
          image: event.imageModel,
        );
      }
      String itemModelId = state.itemModel?.id ?? '';
      for (var i = 0; i < event.quantity; i++) {
        await _itemRepository.update(itemModel);
      }

      itemModel = itemModel.copyWith(id: itemModelId);

      emit(state.copyWith(
          itemModel: itemModel, status: ItemAddEditStateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: ItemAddEditStateStatus.error, error: 'Erro ao salvar item'));
    }
  }
}
