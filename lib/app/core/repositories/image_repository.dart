import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../data/b4a/table/image/image_b4a.dart';
import '../../data/utils/pagination.dart';
import '../models/image_model.dart';

class ImageRepository {
  final ImageB4a imageB4a = ImageB4a();

  Future<List<ImageModel>> list(
    QueryBuilder<ParseObject> query,
    Pagination pagination,
  ) =>
      imageB4a.list(query, pagination);
  Future<String> update(ImageModel imageModel) => imageB4a.update(imageModel);
  Future<ImageModel?> readById(String id) => imageB4a.readById(id);
}
