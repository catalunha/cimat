part of 'image_add_edit_bloc.dart';

abstract class ImageAddEditEvent {}

class ImageAddEditEventSendXFile extends ImageAddEditEvent {
  final XFile? xfile;
  ImageAddEditEventSendXFile({
    required this.xfile,
  });
}

class ImageAddEditEventFormSubmitted extends ImageAddEditEvent {
  final String keywords;
  ImageAddEditEventFormSubmitted({
    required this.keywords,
  });

  ImageAddEditEventFormSubmitted copyWith({
    String? keywords,
  }) {
    return ImageAddEditEventFormSubmitted(
      keywords: keywords ?? this.keywords,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageAddEditEventFormSubmitted &&
        other.keywords == keywords;
  }

  @override
  int get hashCode => keywords.hashCode;
}
