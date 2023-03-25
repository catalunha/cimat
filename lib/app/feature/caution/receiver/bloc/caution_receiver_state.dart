import 'package:flutter/foundation.dart';

import '../../../../core/models/caution_model.dart';

enum CautionReceiverStateStatus { initial, loading, success, error }

class CautionReceiverState {
  final CautionReceiverStateStatus status;
  final String? error;
  final List<CautionModel> cautionModelList;
  final List<CautionModel> cautionModelListFiltered;
  final bool filteredIsTemporary;
  CautionReceiverState({
    required this.status,
    this.error,
    required this.cautionModelList,
    required this.cautionModelListFiltered,
    required this.filteredIsTemporary,
  });
  CautionReceiverState.initial()
      : status = CautionReceiverStateStatus.initial,
        error = '',
        cautionModelList = [],
        cautionModelListFiltered = [],
        filteredIsTemporary = true;
  CautionReceiverState copyWith({
    CautionReceiverStateStatus? status,
    String? error,
    List<CautionModel>? cautionModelList,
    List<CautionModel>? cautionModelListFiltered,
    bool? filteredIsTemporary,
  }) {
    return CautionReceiverState(
      status: status ?? this.status,
      error: error ?? this.error,
      cautionModelList: cautionModelList ?? this.cautionModelList,
      cautionModelListFiltered:
          cautionModelListFiltered ?? this.cautionModelListFiltered,
      filteredIsTemporary: filteredIsTemporary ?? this.filteredIsTemporary,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CautionReceiverState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.cautionModelList, cautionModelList) &&
        listEquals(other.cautionModelListFiltered, cautionModelListFiltered) &&
        other.filteredIsTemporary == filteredIsTemporary;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        cautionModelList.hashCode ^
        cautionModelListFiltered.hashCode ^
        filteredIsTemporary.hashCode;
  }
}
