import 'dart:developer';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/item_model.dart';
import '../../../utils/pagination.dart';
import '../../b4a_exception.dart';
import '../../entity/item_entity.dart';
import '../../utils/parse_error_translate.dart';

class ItemB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);
    query.includeObject(['image']);
    return query;
  }

  Future<List<ItemModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination);

    ParseResponse? response;
    try {
      response = await query2.query();
      List<ItemModel> listTemp = <ItemModel>[];
      if (response.success && response.results != null) {
        for (var element in response.results!) {
          listTemp.add(ItemEntity().fromParse(element));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'ItemB4a.list',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<ItemModel?> readById(String id) async {
    log('+++', name: 'ItemRepositoryB4a.readById');
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(ItemEntity.className));
    query.whereEqualTo('objectId', id);
    query.includeObject(['image']);
    query.first();
    ParseResponse? response;
    try {
      response = await query.query();

      if (response.success && response.results != null) {
        return ItemEntity().fromParse(response.results!.first);
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'ItemB4a.readById',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<String> update(ItemModel itemModel) async {
    final userProfileParse = await ItemEntity().toParse(itemModel);
    ParseResponse? response;
    try {
      response = await userProfileParse.save();

      if (response.success && response.results != null) {
        ParseObject parseObject = response.results!.first as ParseObject;
        return parseObject.objectId!;
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'ItemB4a.update',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<ItemModel?> readBySerie(String value) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(ItemEntity.className));
    query.whereEqualTo('serie', value);
    query.whereEqualTo('isBlockedOperator', false);
    query.whereEqualTo('isBlockedDoc', false);
    query.includeObject(['image']);

    query.first();
    ParseResponse? response;
    try {
      response = await query.query();

      if (response.success && response.results != null) {
        return ItemEntity().fromParse(response.results!.first);
      } else {
        // throw Exception();
        return null;
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'ItemB4a.getBySerie',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<List<ItemModel>> readByLote(String value) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(ItemEntity.className));
    query.whereEqualTo('lote', value);
    query.whereEqualTo('isBlockedOperator', false);
    query.whereEqualTo('isBlockedDoc', false);
    query.includeObject(['image']);

    ParseResponse? response;
    try {
      response = await query.query();
      List<ItemModel> listTemp = <ItemModel>[];

      if (response.success && response.results != null) {
        for (var element in response.results!) {
          listTemp.add(ItemEntity().fromParse(element));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'ItemB4a.getByLote',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }
}
