import '../../../../core/models/user_model.dart';

abstract class CautionSearchEvent {}

class CautionSearchEventIsOperator extends CautionSearchEvent {
  UserModel? userModel;
  CautionSearchEventIsOperator(
    this.userModel,
  );
}

class CautionSearchEventNextPage extends CautionSearchEvent {}

class CautionSearchEventPreviousPage extends CautionSearchEvent {}

class CautionSearchEventFormSubmitted extends CautionSearchEvent {
  final bool deliveryDtSelected;
  final DateTime deliveryDtValue;
  CautionSearchEventFormSubmitted({
    required this.deliveryDtSelected,
    required this.deliveryDtValue,
  });
}
