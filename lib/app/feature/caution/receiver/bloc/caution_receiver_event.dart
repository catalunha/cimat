import 'package:cimat/app/core/models/caution_model.dart';

import '../../../../core/models/user_model.dart';

abstract class CautionReceiverEvent {}

class CautionReceiverEventGetCautions extends CautionReceiverEvent {
  final UserModel userModel;
  CautionReceiverEventGetCautions(this.userModel);
}

class CautionReceiverEventFilterChange extends CautionReceiverEvent {
  final bool filterIsTemporary;
  CautionReceiverEventFilterChange({
    required this.filterIsTemporary,
  });
}

class CautionReceiverEventUpdateWasAcceptedWithRefused
    extends CautionReceiverEvent {
  final CautionModel cautionModel;
  final String description;

  CautionReceiverEventUpdateWasAcceptedWithRefused(
      {required this.cautionModel, required this.description});
}

class CautionReceiverEventUpdateWasAcceptedWithAccepted
    extends CautionReceiverEvent {
  final CautionModel cautionModel;

  CautionReceiverEventUpdateWasAcceptedWithAccepted(this.cautionModel);
}

class CautionReceiverEventUpdateIsStartGiveback extends CautionReceiverEvent {
  final CautionModel cautionModel;
  final String description;

  CautionReceiverEventUpdateIsStartGiveback(
      {required this.cautionModel, required this.description});
}

class CautionReceiverEventUpdateIsPermanentItem extends CautionReceiverEvent {
  final CautionModel cautionModel;
  CautionReceiverEventUpdateIsPermanentItem(
    this.cautionModel,
  );
}
