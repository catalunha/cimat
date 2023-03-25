import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/item_model.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_text_title_value.dart';

class ItemViewPage extends StatelessWidget {
  final ItemModel itemModel;
  ItemViewPage({super.key, required this.itemModel});
  final dateFormat = DateFormat('MM/y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dados deste item')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextTitleValue(
                  title: 'Id: ',
                  value: itemModel.id,
                ),
                const AppTextTitleValue(
                  title: 'Foto: ',
                  value: '',
                ),
                AppImageShow(
                  photoUrl: itemModel.image?.photoUrl,
                  width: 300,
                  height: 100,
                ),
                AppTextTitleValue(
                  title: 'Descrição: ',
                  value: itemModel.description,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Serie: ',
                  value: itemModel.serie,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Lote: ',
                  value: itemModel.lote,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Marca: ',
                  value: itemModel.brand,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Modelo: ',
                  value: itemModel.model,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Calibre: ',
                  value: itemModel.calibre,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Documentação: ',
                  value: itemModel.doc,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Observação para cautela: ',
                  value: itemModel.obsCaution,
                  inColumn: true,
                ),
                AppTextTitleValue(
                  title: 'Entregue em: ',
                  value: itemModel.validate == null
                      ? '...'
                      : dateFormat.format(itemModel.validate!),
                ),
                AppTextTitleValue(
                  title: 'É munição ? ',
                  value: itemModel.isMunition != null && itemModel.isMunition!
                      ? "Sim"
                      : "Não",
                ),
                AppTextTitleValue(
                  title: 'Esta bloqueado para operador ? ',
                  value: itemModel.isBlockedOperator != null &&
                          itemModel.isBlockedOperator!
                      ? "Sim"
                      : "Não",
                ),
                AppTextTitleValue(
                  title: 'Esta bloqueado pela documentação ? ',
                  value:
                      itemModel.isBlockedDoc != null && itemModel.isBlockedDoc!
                          ? "Sim"
                          : "Não",
                ),
                AppTextTitleValue(
                  title: 'Grupos: ',
                  value: itemModel.groups?.join('\n'),
                  inColumn: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
