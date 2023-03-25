import '../../../../core/models/caution_model.dart';
import '../../../../core/models/user_profile_model.dart';

abstract class CautionGivebackEvent {}

class CautionGivebackEventGetCautions extends CautionGivebackEvent {}

class CautionGivebackEventUpdateWasAcceptedWithRefused
    extends CautionGivebackEvent {
  final UserProfileModel userProfileGiveback;
  final CautionModel cautionModel;
  final String description;

  CautionGivebackEventUpdateWasAcceptedWithRefused(
      {required this.userProfileGiveback,
      required this.cautionModel,
      required this.description});
}

class CautionGivebackEventUpdateWasAcceptedWithAccepted
    extends CautionGivebackEvent {
  final UserProfileModel userProfileGiveback;
  final CautionModel cautionModel;

  CautionGivebackEventUpdateWasAcceptedWithAccepted(
      {required this.cautionModel, required this.userProfileGiveback});
}
