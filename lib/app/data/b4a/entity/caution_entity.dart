import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/caution_model.dart';
import 'item_entity.dart';
import 'user_profile_entity.dart';

class CautionEntity {
  static const String className = 'Caution';

  CautionModel fromParse(ParseObject parseObject) {
    CautionModel profileModel = CautionModel(
      id: parseObject.objectId!,
      deliveryUserProfile: parseObject.get('deliveryUserProfile') != null
          ? UserProfileEntity()
              .fromParse(parseObject.get('deliveryUserProfile'))
          : null,
      deliveryDt: parseObject.get<DateTime>('deliveryDt')?.toLocal(),
      item: parseObject.get('item') != null
          ? ItemEntity().fromParse(parseObject.get('item'))
          : null,
      receiverUserProfile: parseObject.get('receiverUserProfile') != null
          ? UserProfileEntity()
              .fromParse(parseObject.get('receiverUserProfile'))
          : null,
      receiverItemWasAccepted: parseObject.get('receiverItemWasAccepted'),
      receiverAnalyzedItemDt:
          parseObject.get<DateTime>('receiverAnalyzedItemDt')?.toLocal(),
      receiverIsPermanentItem: parseObject.get('receiverIsPermanentItem'),
      receiverIsStartGiveback: parseObject.get('receiverIsStartGiveback'),
      receiverGivebackItemDt:
          parseObject.get<DateTime>('receiverGivebackItemDt')?.toLocal(),
      receiverGivebackDescription:
          parseObject.get('receiverGivebackDescription'),
      givebackUserProfile: parseObject.get('givebackUserProfile') != null
          ? UserProfileEntity()
              .fromParse(parseObject.get('givebackUserProfile'))
          : null,
      givebackItemWasAccepted: parseObject.get('givebackItemWasAccepted'),
      givebackAnalyzedItemDt:
          parseObject.get<DateTime>('givebackAnalyzedItemDt')?.toLocal(),
      givebackDescription: parseObject.get('givebackDescription'),
    );
    return profileModel;
  }

  Future<ParseObject> toParse(CautionModel cautionModel) async {
    final cautionParseObject = ParseObject(CautionEntity.className);
    cautionParseObject.objectId = cautionModel.id;

    if (cautionModel.deliveryUserProfile != null) {
      cautionParseObject.set(
          'deliveryUserProfile',
          (ParseObject(UserProfileEntity.className)
                ..objectId = cautionModel.deliveryUserProfile!.id)
              .toPointer());
    }
    if (cautionModel.deliveryDt != null) {
      cautionParseObject.set<DateTime?>('deliveryDt', cautionModel.deliveryDt);
    }
    if (cautionModel.item != null) {
      cautionParseObject.set(
          'item',
          (ParseObject(ItemEntity.className)..objectId = cautionModel.item!.id)
              .toPointer());
    }
    if (cautionModel.receiverUserProfile != null) {
      cautionParseObject.set(
          'receiverUserProfile',
          (ParseObject(UserProfileEntity.className)
                ..objectId = cautionModel.receiverUserProfile!.id)
              .toPointer());
    }
    if (cautionModel.receiverItemWasAccepted != null) {
      cautionParseObject.set(
          'receiverItemWasAccepted', cautionModel.receiverItemWasAccepted);
    }
    if (cautionModel.receiverAnalyzedItemDt != null) {
      cautionParseObject.set<DateTime?>(
          'receiverAnalyzedItemDt', cautionModel.receiverAnalyzedItemDt);
    }
    if (cautionModel.receiverIsPermanentItem != null) {
      cautionParseObject.set(
          'receiverIsPermanentItem', cautionModel.receiverIsPermanentItem);
    }
    if (cautionModel.receiverIsStartGiveback != null) {
      cautionParseObject.set(
          'receiverIsStartGiveback', cautionModel.receiverIsStartGiveback);
    }
    if (cautionModel.receiverGivebackItemDt != null) {
      cautionParseObject.set<DateTime?>(
          'receiverGivebackItemDt', cautionModel.receiverGivebackItemDt);
    }
    if (cautionModel.receiverGivebackDescription != null) {
      cautionParseObject.set('receiverGivebackDescription',
          cautionModel.receiverGivebackDescription);
    }

    if (cautionModel.givebackUserProfile != null) {
      cautionParseObject.set(
          'givebackUserProfile',
          (ParseObject(UserProfileEntity.className)
                ..objectId = cautionModel.givebackUserProfile!.id)
              .toPointer());
    }
    if (cautionModel.givebackItemWasAccepted != null) {
      cautionParseObject.set(
          'givebackItemWasAccepted', cautionModel.givebackItemWasAccepted);
    }
    if (cautionModel.givebackAnalyzedItemDt != null) {
      cautionParseObject.set<DateTime?>(
          'givebackAnalyzedItemDt', cautionModel.givebackAnalyzedItemDt);
    }
    if (cautionModel.givebackDescription != null) {
      cautionParseObject.set(
          'givebackDescription', cautionModel.givebackDescription);
    }
    return cautionParseObject;
  }
}
