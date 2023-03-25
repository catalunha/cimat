import 'dart:convert';

import 'package:flutter/foundation.dart';

class ImageModel {
  final String? id;
  final List<String>? keywords;
  final String? photoUrl;
  ImageModel({
    this.id,
    this.keywords,
    this.photoUrl,
  });

  ImageModel copyWith({
    String? id,
    List<String>? keywords,
    String? photoUrl,
  }) {
    return ImageModel(
      id: id ?? this.id,
      keywords: keywords ?? this.keywords,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (keywords != null) {
      result.addAll({'keywords': keywords});
    }
    if (photoUrl != null) {
      result.addAll({'photoUrl': photoUrl});
    }

    return result;
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      keywords: List<String>.from(map['keywords']),
      photoUrl: map['photoUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageModel.fromJson(String source) =>
      ImageModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ImageModel(id: $id, keywords: $keywords, photoUrl: $photoUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageModel &&
        other.id == id &&
        listEquals(other.keywords, keywords) &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode => id.hashCode ^ keywords.hashCode ^ photoUrl.hashCode;
}
