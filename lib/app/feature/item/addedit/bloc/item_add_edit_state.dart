import '../../../../core/models/image_model.dart';
import '../../../../core/models/item_model.dart';

enum ItemAddEditStateStatus { initial, loading, success, error }

class ItemAddEditState {
  final ItemAddEditStateStatus status;
  final String? error;
  final ItemModel? itemModel;
  final ImageModel? imageModel;
  ItemAddEditState({
    required this.status,
    this.error,
    this.itemModel,
    this.imageModel,
  });
  ItemAddEditState.initial(this.itemModel)
      : status = ItemAddEditStateStatus.initial,
        error = '',
        imageModel = null;
  ItemAddEditState copyWith({
    ItemAddEditStateStatus? status,
    String? error,
    ItemModel? itemModel,
    ImageModel? imageModel,
  }) {
    return ItemAddEditState(
      status: status ?? this.status,
      error: error ?? this.error,
      itemModel: itemModel ?? this.itemModel,
      imageModel: imageModel ?? this.imageModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemAddEditState &&
        other.status == status &&
        other.error == error &&
        other.itemModel == itemModel &&
        other.imageModel == imageModel;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        itemModel.hashCode ^
        imageModel.hashCode;
  }
}
