import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/item/item_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/item_model.dart';

class ItemRepository {
  final ItemB4a itemB4a = ItemB4a();

  Future<List<ItemModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      itemB4a.list(query, pagination);
  Future<String> update(ItemModel itemModel) => itemB4a.update(itemModel);
  Future<ItemModel?> readById(String id) => itemB4a.readById(id);
  Future<ItemModel?> readBySerie(String value) => itemB4a.readBySerie(value);
  Future<List<ItemModel>> readByLote(String value) => itemB4a.readByLote(value);
}
