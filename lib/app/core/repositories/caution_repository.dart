import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/caution/caution_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/caution_model.dart';

class CautionRepository {
  final CautionB4a cautionB4a = CautionB4a();

  Future<List<CautionModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination? pagination,
  ) =>
      cautionB4a.list(query, pagination);
  Future<String> update(CautionModel userProfileModel) =>
      cautionB4a.update(userProfileModel);
  Future<CautionModel?> readById(String id) => cautionB4a.readById(id);
}
