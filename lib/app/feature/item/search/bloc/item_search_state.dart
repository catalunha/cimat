import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/item_model.dart';
import '../../../../data/b4a/entity/item_entity.dart';

enum ItemSearchStateStatus { initial, loading, success, error }

class ItemSearchState {
  final ItemSearchStateStatus status;
  final String? error;
  final List<ItemModel> itemModelList;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  ItemSearchState({
    required this.status,
    this.error,
    required this.itemModelList,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
  });
  ItemSearchState.initial()
      : status = ItemSearchStateStatus.initial,
        error = '',
        itemModelList = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(ItemEntity.className));

  ItemSearchState copyWith({
    ItemSearchStateStatus? status,
    String? error,
    List<ItemModel>? itemModelList,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
  }) {
    return ItemSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      itemModelList: itemModelList ?? this.itemModelList,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      query: query ?? this.query,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.itemModelList, itemModelList) &&
        other.page == page &&
        other.limit == limit &&
        other.firstPage == firstPage &&
        other.lastPage == lastPage &&
        other.query == query;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        itemModelList.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode;
  }
}
