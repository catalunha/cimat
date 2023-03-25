import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/caution_model.dart';
import '../../../../utils/app_photo_show.dart';
import '../../../../utils/app_text_title_value.dart';

class CautionCard extends StatelessWidget {
  final CautionModel cautionModel;
  const CautionCard({Key? key, required this.cautionModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y HH:mm');

    return Card(
      child: Column(
        children: [
          // AppTextTitleValue(
          //   title: 'Id: ',
          //   value: cautionModel.id,
          // ),
          Wrap(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  AppImageShow(
                    photoUrl: cautionModel.deliveryUserProfile?.photo,
                    height: 125,
                    // width: 150,
                  ),
                  const Text('Entregador'),
                  Text('${cautionModel.deliveryUserProfile?.nickname}')
                ],
              ),
              Column(
                children: [
                  AppImageShow(
                    photoUrl: cautionModel.receiverUserProfile?.photo,
                    height: 125,
                    // width: 150,
                  ),
                  const Text('Operador'),
                  Text('${cautionModel.receiverUserProfile?.nickname}')
                ],
              ),
              // if (cautionModel.givebackUserProfile != null)
              Column(
                children: [
                  AppImageShow(
                    photoUrl: cautionModel.givebackUserProfile?.photo,
                    height: 125,
                    // width: 150,
                  ),
                  const Text('Recebedor'),
                  Text('${cautionModel.givebackUserProfile?.nickname}')
                ],
              ),
            ],
          ),
          AppImageShow(
            photoUrl: cautionModel.item!.image?.photoUrl,
            height: 100,
            width: 300,
          ),
          AppTextTitleValue(
            title: 'Item: ',
            value: cautionModel.item!.description,
          ),
          AppTextTitleValue(
            title: 'Serie: ',
            value: cautionModel.item!.serie,
          ),
          AppTextTitleValue(
            title: 'Lote: ',
            value: cautionModel.item!.lote,
          ),
          AppTextTitleValue(
            title: 'Entregue por: ',
            value: cautionModel.deliveryUserProfile!.nickname!,
          ),
          AppTextTitleValue(
            title: 'Entregue em: ',
            value: dateFormat.format(cautionModel.deliveryDt!),
          ),
          AppTextTitleValue(
            title: 'Cautelado a: ',
            value: cautionModel.receiverUserProfile!.nickname!,
          ),
          AppTextTitleValue(
            title: 'Situação da análise ? ',
            value: cautionModel.receiverItemWasAccepted == null
                ? 'Analisando'
                : cautionModel.receiverItemWasAccepted == true
                    ? 'Aceito'
                    : 'Recusado',
          ),
          AppTextTitleValue(
            title: 'Analisado em: ',
            value: cautionModel.receiverAnalyzedItemDt == null
                ? '...'
                : dateFormat.format(cautionModel.receiverAnalyzedItemDt!),
          ),
          AppTextTitleValue(
            title: 'Em item permanente ? ',
            value:
                cautionModel.receiverIsPermanentItem == false ? 'Não' : 'Sim',
          ),
          AppTextTitleValue(
            title: 'Situação da devolução ? ',
            value: cautionModel.receiverIsStartGiveback == null
                ? 'Analisando'
                : cautionModel.receiverIsStartGiveback == false
                    ? 'Nao devolver. Em uso.'
                    : 'Devolução iniciada',
          ),
          AppTextTitleValue(
            title: 'Devolvido em: ',
            value: cautionModel.receiverGivebackItemDt == null
                ? '...'
                : dateFormat.format(cautionModel.receiverGivebackItemDt!),
          ),
          AppTextTitleValue(
            title: 'Descrição da devolução: ',
            value: cautionModel.receiverGivebackDescription,
            inColumn: true,
          ),
          AppTextTitleValue(
            title: 'Recebido por: ',
            value: cautionModel.givebackUserProfile?.nickname,
          ),
          AppTextTitleValue(
            title: 'Situação da recebimento ? ',
            value: cautionModel.receiverIsStartGiveback != true
                ? '...'
                : cautionModel.givebackItemWasAccepted == null
                    ? 'Analisando'
                    : cautionModel.givebackItemWasAccepted == false
                        ? 'Com observações.'
                        : 'Normal',
          ),
          AppTextTitleValue(
            title: 'Recebido em: ',
            value: cautionModel.givebackAnalyzedItemDt == null
                ? '...'
                : dateFormat.format(cautionModel.givebackAnalyzedItemDt!),
          ),
          AppTextTitleValue(
            title: 'Descrição do recebimento: ',
            value: cautionModel.givebackDescription,
          ),
        ],
      ),
    );
  }
}
