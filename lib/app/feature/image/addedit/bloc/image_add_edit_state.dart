part of 'image_add_edit_bloc.dart';

enum ImageAddEditStateStatus { initial, loading, success, error }

class ImageAddEditState {
  final ImageAddEditStateStatus status;
  final String? error;
  final ImageModel? imageModel;
  final XFile? xfile;
  ImageAddEditState({
    required this.status,
    this.error,
    this.imageModel,
    this.xfile,
  });

  ImageAddEditState.initial({required this.imageModel})
      : status = ImageAddEditStateStatus.initial,
        error = '',
        xfile = null;

  ImageAddEditState copyWith({
    ImageAddEditStateStatus? status,
    String? error,
    ImageModel? imageModel,
    XFile? xfile,
  }) {
    return ImageAddEditState(
      status: status ?? this.status,
      error: error ?? this.error,
      imageModel: imageModel ?? this.imageModel,
      xfile: xfile ?? this.xfile,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageAddEditState &&
        other.status == status &&
        other.error == error &&
        other.imageModel == imageModel &&
        other.xfile == xfile;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        error.hashCode ^
        imageModel.hashCode ^
        xfile.hashCode;
  }
}
