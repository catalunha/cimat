import 'package:flutter/foundation.dart';

import 'package:cimat/app/core/models/item_model.dart';
import 'package:cimat/app/core/models/user_profile_model.dart';

enum CautionDeliveryStateStatus { initial, loading, success, error, finish }

class CautionDeliveryState {
  final CautionDeliveryStateStatus status;
  final String? error;
  final List<ItemModel> itemList;
  final UserProfileModel? userProfileReceiver;
  final int quantity;

  int get quantityMax => itemList.length;

  CautionDeliveryState({
    required this.status,
    this.error,
    required this.itemList,
    this.userProfileReceiver,
    required this.quantity,
  });
  CautionDeliveryState.initial()
      : status = CautionDeliveryStateStatus.initial,
        error = '',
        itemList = [],
        userProfileReceiver = null,
        quantity = 0;

  CautionDeliveryState copyWith({
    CautionDeliveryStateStatus? status,
    String? error,
    List<ItemModel>? itemList,
    UserProfileModel? userProfileReceiver,
    int? quantity,
  }) {
    return CautionDeliveryState(
      status: status ?? this.status,
      error: error ?? this.error,
      itemList: itemList ?? this.itemList,
      userProfileReceiver: userProfileReceiver ?? this.userProfileReceiver,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CautionDeliveryState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.itemList, itemList) &&
        other.userProfileReceiver == userProfileReceiver &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        itemList.hashCode ^
        userProfileReceiver.hashCode ^
        quantity.hashCode;
  }
}
