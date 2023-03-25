import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/item_model.dart';
import 'image_entity.dart';

class ItemEntity {
  static const String className = 'Item';

  ItemModel fromParse(ParseObject parseObject) {
    ItemModel itemModel = ItemModel(
      id: parseObject.objectId!,
      description: parseObject.get('description'),
      serie: parseObject.get('serie'),
      lote: parseObject.get('lote'),
      brand: parseObject.get('brand'),
      model: parseObject.get('model'),
      calibre: parseObject.get('calibre'),
      doc: parseObject.get('doc'),
      obsCaution: parseObject.get('obsCaution'),
      validate: parseObject.get<DateTime>('validate')?.toLocal(),
      groups: parseObject.get<List<dynamic>>('groups') != null
          ? parseObject
              .get<List<dynamic>>('groups')!
              .map((e) => e.toString())
              .toList()
          : [],
      isMunition: parseObject.get('isMunition'),
      isBlockedOperator: parseObject.get('isBlockedOperator'),
      isBlockedDoc: parseObject.get('isBlockedDoc'),
      image: parseObject.get('image') != null
          ? ImageEntity().fromParse(parseObject.get('image'))
          : null,
    );
    return itemModel;
  }

  Future<ParseObject> toParse(ItemModel itemModel) async {
    final parseObject = ParseObject(ItemEntity.className);
    parseObject.objectId = itemModel.id;
    if (itemModel.description != null) {
      parseObject.set('description', itemModel.description);
    }
    if (itemModel.serie != null) {
      parseObject.set('serie', itemModel.serie);
    }

    if (itemModel.lote != null) {
      parseObject.set('lote', itemModel.lote);
    }
    if (itemModel.brand != null) {
      parseObject.set('brand', itemModel.brand);
    }
    if (itemModel.model != null) {
      parseObject.set('model', itemModel.model);
    }
    if (itemModel.calibre != null) {
      parseObject.set('calibre', itemModel.calibre);
    }
    if (itemModel.doc != null) {
      parseObject.set('doc', itemModel.doc);
    }
    if (itemModel.obsCaution != null) {
      parseObject.set('obsCaution', itemModel.obsCaution);
    }
    if (itemModel.validate != null) {
      parseObject.set<DateTime?>('validate', itemModel.validate);
    }
    if (itemModel.isMunition != null) {
      parseObject.set('isMunition', itemModel.isMunition);
    }
    if (itemModel.isBlockedOperator != null) {
      parseObject.set('isBlockedOperator', itemModel.isBlockedOperator);
    }
    if (itemModel.isBlockedDoc != null) {
      parseObject.set('isBlockedDoc', itemModel.isBlockedDoc);
    }
    if (itemModel.groups != null) {
      parseObject.set('groups', itemModel.groups);
    }
    if (itemModel.image != null) {
      parseObject.set(
          'image',
          (ParseObject(ImageEntity.className)..objectId = itemModel.image!.id)
              .toPointer());
    }

    return parseObject;
  }
}
