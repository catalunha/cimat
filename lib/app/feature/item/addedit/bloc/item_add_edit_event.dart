import '../../../../core/models/image_model.dart';

abstract class ItemAddEditEvent {}

class ItemAddEditEventFormSubmitted extends ItemAddEditEvent {
  final String? description;
  final String? serie;
  final String? lote;
  final String? brand;
  final String? model;
  final String? calibre;
  final String? doc;
  final String? obsCaution;
  final DateTime? validate;
  final bool? isMunition;
  final bool? isBlockedOperator;
  final bool? isBlockedDoc;
  final String? groups;
  final int quantity;
  final ImageModel? imageModel;
  ItemAddEditEventFormSubmitted({
    this.description,
    this.serie,
    this.lote,
    this.brand,
    this.model,
    this.calibre,
    this.doc,
    this.obsCaution,
    this.validate,
    this.isMunition,
    this.isBlockedOperator,
    this.isBlockedDoc,
    this.groups,
    this.quantity = 1,
    this.imageModel,
  });

  ItemAddEditEventFormSubmitted copyWith({
    String? description,
    String? serie,
    String? lote,
    String? brand,
    String? model,
    String? calibre,
    String? doc,
    String? obsCaution,
    DateTime? validate,
    bool? isMunition,
    bool? isBlockedOperator,
    bool? isBlockedDoc,
    String? groups,
    int? quantity,
    ImageModel? imageModel,
  }) {
    return ItemAddEditEventFormSubmitted(
      description: description ?? this.description,
      serie: serie ?? this.serie,
      lote: lote ?? this.lote,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      calibre: calibre ?? this.calibre,
      doc: doc ?? this.doc,
      obsCaution: obsCaution ?? this.obsCaution,
      validate: validate ?? this.validate,
      isMunition: isMunition ?? this.isMunition,
      isBlockedOperator: isBlockedOperator ?? this.isBlockedOperator,
      isBlockedDoc: isBlockedDoc ?? this.isBlockedDoc,
      groups: groups ?? this.groups,
      quantity: quantity ?? this.quantity,
      imageModel: imageModel ?? this.imageModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemAddEditEventFormSubmitted &&
        other.description == description &&
        other.serie == serie &&
        other.lote == lote &&
        other.brand == brand &&
        other.model == model &&
        other.calibre == calibre &&
        other.doc == doc &&
        other.obsCaution == obsCaution &&
        other.validate == validate &&
        other.isMunition == isMunition &&
        other.isBlockedOperator == isBlockedOperator &&
        other.isBlockedDoc == isBlockedDoc &&
        other.groups == groups &&
        other.quantity == quantity &&
        other.imageModel == imageModel;
  }

  @override
  int get hashCode {
    return description.hashCode ^
        serie.hashCode ^
        lote.hashCode ^
        brand.hashCode ^
        model.hashCode ^
        calibre.hashCode ^
        doc.hashCode ^
        obsCaution.hashCode ^
        validate.hashCode ^
        isMunition.hashCode ^
        isBlockedOperator.hashCode ^
        isBlockedDoc.hashCode ^
        groups.hashCode ^
        quantity.hashCode ^
        imageModel.hashCode;
  }
}
