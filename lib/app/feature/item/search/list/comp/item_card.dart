import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/item_model.dart';
import '../../../../utils/app_photo_show.dart';
import '../../../addedit/item_addedit_page.dart';
import '../../../view/item_view_page.dart';
import '../../bloc/item_search_bloc.dart';

class ItemCard extends StatelessWidget {
  final ItemModel itemModel;
  const ItemCard({Key? key, required this.itemModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AppImageShow(
            photoUrl: itemModel.image?.photoUrl,
            width: 300,
            height: 100,
          ),
          // AppTextTitleValue(
          //   title: 'Id: ',
          //   value: itemModel.id,
          // ),
          Text(
            '${itemModel.description}',
            style: const TextStyle(fontSize: 22),
          ),
          Text(
            '${itemModel.serie} - ${itemModel.lote}',
            style: const TextStyle(fontSize: 22),
          ),
          // AppTextTitleValue(
          //   title: 'Descrição: ',
          //   value: itemModel.description,
          // ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  // Get.toNamed(Routes.itemAddEdit, arguments: itemModel);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ItemSearchBloc>(context),
                        child: ItemAddEditPage(itemModel: itemModel),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Get.toNamed(
                  //   Routes.itemView,
                  //   arguments: itemModel,
                  // );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ItemViewPage(itemModel: itemModel),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.assignment_ind_outlined,
                ),
              ),
              // IconButton(
              //   onPressed: () => copy(itemModel.id!),
              //   icon: const Icon(
              //     Icons.copy,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
