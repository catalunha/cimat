import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/caution_model.dart';
import '../../../../core/models/user_model.dart';
import '../../../../data/b4a/entity/caution_entity.dart';

enum CautionSearchStateStatus { initial, loading, success, error }

class CautionSearchState {
  final CautionSearchStateStatus status;
  final String? error;
  final List<CautionModel> cautionModelList;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  final UserModel? userModel;
  CautionSearchState({
    required this.status,
    this.error,
    required this.cautionModelList,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
    this.userModel,
  });
  CautionSearchState.initial()
      : status = CautionSearchStateStatus.initial,
        error = '',
        cautionModelList = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(CautionEntity.className)),
        userModel = null;

  CautionSearchState copyWith({
    CautionSearchStateStatus? status,
    String? error,
    List<CautionModel>? cautionModelList,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
    UserModel? userModel,
  }) {
    return CautionSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      cautionModelList: cautionModelList ?? this.cautionModelList,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      firstPage: firstPage ?? this.firstPage,
      lastPage: lastPage ?? this.lastPage,
      query: query ?? this.query,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CautionSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.cautionModelList, cautionModelList) &&
        other.page == page &&
        other.limit == limit &&
        other.firstPage == firstPage &&
        other.lastPage == lastPage &&
        other.query == query &&
        other.userModel == userModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        cautionModelList.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode ^
        userModel.hashCode;
  }
}
