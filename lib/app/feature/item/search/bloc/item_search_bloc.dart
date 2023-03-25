import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cimat/app/core/repositories/item_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/item_model.dart';
import '../../../../data/b4a/entity/item_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'item_search_event.dart';
import 'item_search_state.dart';

class ItemSearchBloc extends Bloc<ItemSearchEvent, ItemSearchState> {
  final ItemRepository _itemRepository;
  ItemSearchBloc({required ItemRepository itemRepository})
      : _itemRepository = itemRepository,
        super(ItemSearchState.initial()) {
    on<ItemSearchEventFormSubmitted>(_onItemSearchEventFormSubmitted);
    on<ItemSearchEventPreviousPage>(_onItemSearchEventPreviousPage);
    on<UserProfileSearchEventNextPage>(_onUserProfileSearchEventNextPage);
    on<ItemSearchEventUpdateList>(_onItemSearchEventUpdateList);
  }

  FutureOr<void> _onItemSearchEventFormSubmitted(
      ItemSearchEventFormSubmitted event, Emitter<ItemSearchState> emit) async {
    emit(state.copyWith(
      status: ItemSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      itemModelList: [],
      query: QueryBuilder<ParseObject>(ParseObject(ItemEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ItemEntity.className));

      if (event.descriptionContainsBool) {
        query.whereContains('description', event.descriptionContainsString);
      }
      if (event.serieContainsBool) {
        query.whereContains('serie', event.serieContainsString);
      }
      if (event.loteContainsBool) {
        query.whereContains('lote', event.loteContainsString);
      }
      if (event.brandContainsBool) {
        query.whereContains('brand', event.brandContainsString);
      }
      if (event.modelContainsBool) {
        query.whereContains('model', event.modelContainsString);
      }
      if (event.calibreContainsBool) {
        query.whereContains('calibre', event.calibreContainsString);
      }
      if (event.docContainsBool) {
        query.whereContains('doc', event.docContainsString);
      }
      if (event.obsCautionContainsBool) {
        query.whereContains('obsCaution', event.obsCautionContainsString);
      }
      if (event.groupEqualsToBool) {
        query.whereContainedIn('groups', [event.groupEqualsToString]);
      }
      if (event.isMunitionEqualsToBool) {
        query.whereEqualTo('isMunition', event.isMunitionEqualsToValue);
      }
      if (event.isBlockedOperatorEqualsToBool) {
        query.whereEqualTo(
            'isBlockedOperator', event.isBlockedOperatorEqualsToValue);
      }
      if (event.isBlockedDocEqualsToBool) {
        query.whereEqualTo('isBlockedDoc', event.isBlockedDocEqualsToValue);
      }
      query.orderByDescending('updatedAt');
      List<ItemModel> itemModelListGet = await _itemRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );
      emit(state.copyWith(
        status: ItemSearchStateStatus.success,
        itemModelList: itemModelListGet,
        query: query,
      ));
    } catch (_) {
      emit(
        state.copyWith(
            status: ItemSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onItemSearchEventPreviousPage(
      ItemSearchEventPreviousPage event, Emitter<ItemSearchState> emit) async {
    emit(
      state.copyWith(
        status: ItemSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ItemModel> itemModelListGet = await _itemRepository.list(
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
        status: ItemSearchStateStatus.success,
        itemModelList: itemModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ItemSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onUserProfileSearchEventNextPage(
      UserProfileSearchEventNextPage event,
      Emitter<ItemSearchState> emit) async {
    emit(
      state.copyWith(status: ItemSearchStateStatus.loading),
    );
    List<ItemModel> itemModelListGet = await _itemRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (itemModelListGet.isEmpty) {
      emit(state.copyWith(
        status: ItemSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ItemSearchStateStatus.success,
        itemModelList: itemModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onItemSearchEventUpdateList(
      ItemSearchEventUpdateList event, Emitter<ItemSearchState> emit) {
    int index = state.itemModelList
        .indexWhere((model) => model.id == event.itemModel.id);
    if (index >= 0) {
      List<ItemModel> itemModelListTemp = [...state.itemModelList];
      itemModelListTemp.replaceRange(index, index + 1, [event.itemModel]);
      emit(state.copyWith(itemModelList: itemModelListTemp));
    }
  }
}
