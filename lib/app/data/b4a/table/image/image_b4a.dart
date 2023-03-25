import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/image_model.dart';
import '../../../utils/pagination.dart';
import '../../b4a_exception.dart';
import '../../entity/image_entity.dart';
import '../../utils/parse_error_translate.dart';

class ImageB4a {
  Future<QueryBuilder<ParseObject>> getQueryAll(
      QueryBuilder<ParseObject> query, Pagination pagination) async {
    query.setAmountToSkip((pagination.page - 1) * pagination.limit);
    query.setLimit(pagination.limit);

    return query;
  }

  Future<List<ImageModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) async {
    QueryBuilder<ParseObject> query2;
    query2 = await getQueryAll(query, pagination);

    ParseResponse? response;
    try {
      response = await query2.query();
      List<ImageModel> listTemp = <ImageModel>[];
      if (response.success && response.results != null) {
        for (var element in response.results!) {
          listTemp.add(ImageEntity().fromParse(element));
        }
        return listTemp;
      } else {
        return [];
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'ImageB4a.list',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<ImageModel?> readById(String id) async {
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(ImageEntity.className));
    query.whereEqualTo('objectId', id);

    query.first();
    ParseResponse? response;
    try {
      response = await query.query();

      if (response.success && response.results != null) {
        return ImageEntity().fromParse(response.results!.first);
      } else {
        throw Exception();
      }
    } on Exception {
      var errorTranslated = ParseErrorTranslate.translate(response!.error!);
      throw B4aException(
        errorTranslated,
        where: 'ImageB4a.readById',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }

  Future<String> update(ImageModel imageModel) async {
    final userProfileParse = await ImageEntity().toParse(imageModel);
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
        where: 'ImageB4a.update',
        originalError: '${response.error!.code} -${response.error!.message}',
      );
    }
  }
}
