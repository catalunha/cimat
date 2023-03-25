import 'package:flutter/material.dart';

import '../../../../../core/models/caution_model.dart';
import 'caution_card.dart';

class CautionList extends StatelessWidget {
  final List<CautionModel> cautionList;
  const CautionList({
    super.key,
    required this.cautionList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cautionList.length,
      itemBuilder: (context, index) {
        final item = cautionList[index];
        return CautionCard(
          cautionModel: item,
        );
      },
    );
  }
}
