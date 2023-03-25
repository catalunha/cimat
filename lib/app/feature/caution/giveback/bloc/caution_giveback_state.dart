import 'package:flutter/foundation.dart';

import '../../../../core/models/caution_model.dart';

enum CautionGivebackStateStatus { initial, loading, success, error }

class CautionGivebackState {
  final CautionGivebackStateStatus status;
  final String? error;
  final List<CautionModel> cautionModelList;
  CautionGivebackState({
    required this.status,
    this.error,
    required this.cautionModelList,
  });

  CautionGivebackState.initial()
      : status = CautionGivebackStateStatus.initial,
        error = '',
        cautionModelList = [];

  CautionGivebackState copyWith({
    CautionGivebackStateStatus? status,
    String? error,
    List<CautionModel>? cautionModelList,
  }) {
    return CautionGivebackState(
      status: status ?? this.status,
      error: error ?? this.error,
      cautionModelList: cautionModelList ?? this.cautionModelList,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CautionGivebackState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.cautionModelList, cautionModelList);
  }

  @override
  int get hashCode =>
      status.hashCode ^ error.hashCode ^ cautionModelList.hashCode;
}
