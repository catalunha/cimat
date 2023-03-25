import 'package:cimat/app/core/models/user_profile_model.dart';

abstract class CautionDeliveryEvent {}

class CautionDeliveryEventItemSubmitted extends CautionDeliveryEvent {
  final String serie;
  final String lote;
  CautionDeliveryEventItemSubmitted({
    required this.serie,
    required this.lote,
  });
}

class CautionDeliveryEventQuantityIncrement extends CautionDeliveryEvent {}

class CautionDeliveryEventQuantityDecrement extends CautionDeliveryEvent {}

class CautionDeliveryEventUserProfileSubmitted extends CautionDeliveryEvent {
  final String userProfileRegister;
  CautionDeliveryEventUserProfileSubmitted({
    required this.userProfileRegister,
  });
}

class CautionDeliveryEventSendOrder extends CautionDeliveryEvent {
  UserProfileModel userProfileModelDelivery;
  CautionDeliveryEventSendOrder({
    required this.userProfileModelDelivery,
  });
}
