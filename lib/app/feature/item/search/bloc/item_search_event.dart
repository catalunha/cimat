import '../../../../core/models/item_model.dart';

abstract class ItemSearchEvent {}

class UserProfileSearchEventNextPage extends ItemSearchEvent {}

class ItemSearchEventPreviousPage extends ItemSearchEvent {}

class ItemSearchEventUpdateList extends ItemSearchEvent {
  final ItemModel itemModel;
  ItemSearchEventUpdateList(
    this.itemModel,
  );
}

class ItemSearchEventFormSubmitted extends ItemSearchEvent {
  final bool descriptionContainsBool;
  final String descriptionContainsString;
  final bool serieContainsBool;
  final String serieContainsString;
  final bool loteContainsBool;
  final String loteContainsString;
  final bool brandContainsBool;
  final String brandContainsString;
  final bool modelContainsBool;
  final String modelContainsString;
  final bool calibreContainsBool;
  final String calibreContainsString;
  final bool docContainsBool;
  final String docContainsString;
  final bool obsCautionContainsBool;
  final String obsCautionContainsString;
  final bool groupEqualsToBool;
  final String groupEqualsToString;
  final bool isMunitionEqualsToBool;
  final bool isMunitionEqualsToValue;
  final bool isBlockedOperatorEqualsToBool;
  final bool isBlockedOperatorEqualsToValue;
  final bool isBlockedDocEqualsToBool;
  final bool isBlockedDocEqualsToValue;
  ItemSearchEventFormSubmitted({
    required this.descriptionContainsBool,
    required this.descriptionContainsString,
    required this.serieContainsBool,
    required this.serieContainsString,
    required this.loteContainsBool,
    required this.loteContainsString,
    required this.brandContainsBool,
    required this.brandContainsString,
    required this.modelContainsBool,
    required this.modelContainsString,
    required this.calibreContainsBool,
    required this.calibreContainsString,
    required this.docContainsBool,
    required this.docContainsString,
    required this.obsCautionContainsBool,
    required this.obsCautionContainsString,
    required this.groupEqualsToBool,
    required this.groupEqualsToString,
    required this.isMunitionEqualsToBool,
    required this.isMunitionEqualsToValue,
    required this.isBlockedOperatorEqualsToBool,
    required this.isBlockedOperatorEqualsToValue,
    required this.isBlockedDocEqualsToBool,
    required this.isBlockedDocEqualsToValue,
  });
}
