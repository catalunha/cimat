import 'dart:developer';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/caution_model.dart';
import '../../../utils/pagination.dart';
import '../../b4a_exception.dart';
import '../../entity/caution_entity.dart';
import '../../utils/parse_error_translate.dart';

class CautionB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination? pagination) async {
    if (pagination != null) {
      query.setAmountToSkip((pagination.page - 1) * pagination.limit);
      query.setLimit(pagination.limit);
    }
    query.includeObject([
      'deliveryUserProfile',
      'receiverUserProfile',
      'givebackUserProfile',
      'item',
      'item.image'
    ]);
    return query;
  }

  Future<List<CautionModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination? pagination,
  ) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination);

    ParseResponse? response;
    try {
      response = await query2.query();
      List<CautionModel> listTemp = <CautionModel>[];
      if (response.success && response.results != null) {
        for (var element in response.results!) {
          listTemp.add(CautionEntity().fromParse(element));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'CautionB4a.list',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<CautionModel?> readById(String id) async {
    log('+++', name: 'CautionRepositoryB4a.readById');
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(CautionEntity.className));
    query.whereEqualTo('objectId', id);
    query.includeObject([
      'deliveryUserProfile',
      'receiverUserProfile',
      'givebackUserProfile',
      'item',
      'item.image'
    ]);
    query.first();
    ParseResponse? response;
    try {
      response = await query.query();

      if (response.success && response.results != null) {
        return CautionEntity().fromParse(response.results!.first);
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'CautionB4a.readById',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<String> update(CautionModel userProfileModel) async {
    final userProfileParse = await CautionEntity().toParse(userProfileModel);
    ParseResponse? response;
    try {
      response = await userProfileParse.save();

      if (response.success && response.results != null) {
        ParseObject userProfile = response.results!.first as ParseObject;
        return userProfile.objectId!;
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'CautionB4a.update',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }
}
