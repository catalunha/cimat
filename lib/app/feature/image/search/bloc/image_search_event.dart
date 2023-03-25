import '../../../../core/models/image_model.dart';

abstract class ImageSearchEvent {}

class ImageSearchEventPreviousPage extends ImageSearchEvent {}

class ImageSearchEventNextPage extends ImageSearchEvent {}

class ImageSearchEventUpdateList extends ImageSearchEvent {
  final ImageModel imageModel;
  ImageSearchEventUpdateList(
    this.imageModel,
  );
}

class ImageSearchEventFormSubmitted extends ImageSearchEvent {
  final String keywords;
  ImageSearchEventFormSubmitted({
    required this.keywords,
  });

  ImageSearchEventFormSubmitted copyWith({
    String? keywords,
  }) {
    return ImageSearchEventFormSubmitted(
      keywords: keywords ?? this.keywords,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageSearchEventFormSubmitted && other.keywords == keywords;
  }

  @override
  int get hashCode => keywords.hashCode;
}
