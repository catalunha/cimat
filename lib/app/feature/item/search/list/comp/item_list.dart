import 'package:flutter/material.dart';

import '../../../../../core/models/item_model.dart';
import 'item_card.dart';

class ItemList extends StatelessWidget {
  final List<ItemModel> itemList;
  const ItemList({
    super.key,
    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final person = itemList[index];
        return ItemCard(
          itemModel: person,
        );
      },
    );
  }
}
