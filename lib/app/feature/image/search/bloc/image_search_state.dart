import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/image_model.dart';
import '../../../../data/b4a/entity/image_entity.dart';

enum ImageSearchStateStatus { initial, loading, success, error }

class ImageSearchState {
  final ImageSearchStateStatus status;
  final String? error;
  final List<ImageModel> imageModelList;
  final int page;
  final int limit;
  final bool firstPage;
  final bool lastPage;
  QueryBuilder<ParseObject> query;
  ImageSearchState({
    required this.status,
    this.error,
    required this.imageModelList,
    required this.page,
    required this.limit,
    required this.firstPage,
    required this.lastPage,
    required this.query,
  });
  ImageSearchState.initial()
      : status = ImageSearchStateStatus.initial,
        error = '',
        imageModelList = [],
        page = 1,
        limit = 2,
        firstPage = true,
        lastPage = false,
        query = QueryBuilder<ParseObject>(ParseObject(ImageEntity.className));

  ImageSearchState copyWith({
    ImageSearchStateStatus? status,
    String? error,
    List<ImageModel>? imageModelList,
    int? page,
    int? limit,
    bool? firstPage,
    bool? lastPage,
    QueryBuilder<ParseObject>? query,
  }) {
    return ImageSearchState(
      status: status ?? this.status,
      error: error ?? this.error,
      imageModelList: imageModelList ?? this.imageModelList,
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

    return other is ImageSearchState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.imageModelList, imageModelList) &&
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
        imageModelList.hashCode ^
        page.hashCode ^
        limit.hashCode ^
        firstPage.hashCode ^
        lastPage.hashCode ^
        query.hashCode;
  }
}
