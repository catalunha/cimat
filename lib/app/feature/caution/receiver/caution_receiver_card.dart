import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/caution_model.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_text_title_value.dart';
import '../utils/dialog_description.dart';
import 'bloc/caution_receiver_bloc.dart';
import 'bloc/caution_receiver_event.dart';

class CautionReceiverCard extends StatefulWidget {
  final CautionModel cautionModel;
  const CautionReceiverCard({Key? key, required this.cautionModel})
      : super(key: key);

  @override
  State<CautionReceiverCard> createState() => _CautionReceiverCardState();
}

class _CautionReceiverCardState extends State<CautionReceiverCard> {
  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('dd/MM/y HH:mm');
    return Card(
      child: Column(
        children: [
          AppTextTitleValue(
            title: 'Id: ',
            value: widget.cautionModel.id,
          ),
          Wrap(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  AppImageShow(
                    photoUrl: widget.cautionModel.deliveryUserProfile!.photo,
                    height: 125,
                    // width: 150,
                  ),
                  Text('${widget.cautionModel.deliveryUserProfile?.nickname}'),
                ],
              ),
              Column(
                children: [
                  AppImageShow(
                    photoUrl: widget.cautionModel.item!.image?.photoUrl,
                    height: 125,
                    width: 300,
                  ),
                  Text(
                    '${widget.cautionModel.item!.description}',
                  ),
                  Text(
                    'Série: ${widget.cautionModel.item!.serie} Lote: ${widget.cautionModel.item!.lote}',
                  ),
                ],
              ),
            ],
          ),
          // Text(
          //   '${widget.cautionModel.item!.description}',
          //   style: const TextStyle(fontSize: 18),
          // ),
          // Text(
          //   '${widget.cautionModel.item!.serie == null || widget.cautionModel.item!.serie!.isEmpty ? '...' : widget.cautionModel.item!.serie} | ${widget.cautionModel.item!.lote == null || widget.cautionModel.item!.lote!.isEmpty ? '...' : widget.cautionModel.item!.lote}',
          //   style: const TextStyle(fontSize: 22),
          // ),
          // AppTextTitleValue(
          //   title: 'Item: ',
          //   value: widget.cautionModel.item!.description,
          // ),
          // AppTextTitleValue(
          //   title: 'Entregue por: ',
          //   value: widget.cautionModel.deliveryUserProfile!.nickname!,
          // ),
          // AppTextTitleValue(
          //   title: 'Entregue em: ',
          //   value: dateFormat.format(widget.cautionModel.deliveryDt!),
          // ),
          AppTextTitleValue(
            title: 'Observações para cautela: ',
            value: widget.cautionModel.item!.obsCaution,
            inColumn: true,
          ),
          // AppTextTitleValue(
          //   title: 'Cautelado a: ',
          //   value: widget.cautionModel.receiverUserProfile!.nickname!,
          // ),
          // AppTextTitleValue(
          //   title: 'Situação da análise ? ',
          //   value: widget.cautionModel.receiverItemWasAccepted == null
          //       ? 'Analisando'
          //       : widget.cautionModel.receiverItemWasAccepted == true
          //           ? 'Aceito'
          //           : 'Recusado',
          // ),
          // AppTextTitleValue(
          //   title: 'Analisado em: ',
          //   value: widget.cautionModel.receiverAnalyzedItemDt == null
          //       ? '...'
          //       : dateFormat
          //           .format(widget.cautionModel.receiverAnalyzedItemDt!),
          // ),
          // AppTextTitleValue(
          //   title: 'Em item permanente ? ',
          //   value: widget.cautionModel.receiverIsPermanentItem == false
          //       ? 'Não'
          //       : 'Sim',
          // ),
          // AppTextTitleValue(
          //   title: 'Situação da devolução ? ',
          //   value: widget.cautionModel.receiverIsStartGiveback == null
          //       ? 'Analisando'
          //       : widget.cautionModel.receiverIsStartGiveback == false
          //           ? 'Nao devolver. Em uso.'
          //           : 'Devolução iniciada',
          // ),
          // AppTextTitleValue(
          //   title: 'Devolvido em: ',
          //   value: widget.cautionModel.receiverGivebackItemDt == null
          //       ? '...'
          //       : dateFormat
          //           .format(widget.cautionModel.receiverGivebackItemDt!),
          // ),
          // AppTextTitleValue(
          //   title: 'Descrição da devolução: ',
          //   value: widget.cautionModel.receiverGivebackDescription,
          //   inColumn: true,
          // ),
          // AppTextTitleValue(
          //   title: 'Recebido por: ',
          //   value: widget.cautionModel.givebackUserProfile?.nickname,
          // ),
          // AppTextTitleValue(
          //   title: 'Situação da recebimento ? ',
          //   value: widget.cautionModel.receiverIsStartGiveback != true
          //       ? '...'
          //       : widget.cautionModel.givebackItemWasAccepted == null
          //           ? 'Analisando'
          //           : widget.cautionModel.givebackItemWasAccepted == false
          //               ? 'Com observações.'
          //               : 'Normal',
          // ),
          // AppTextTitleValue(
          //   title: 'Recebido em: ',
          //   value: widget.cautionModel.givebackAnalyzedItemDt == null
          //       ? '...'
          //       : dateFormat
          //           .format(widget.cautionModel.givebackAnalyzedItemDt!),
          // ),
          // AppTextTitleValue(
          //   title: 'Descrição do recebimento: ',
          //   value: widget.cautionModel.givebackDescription,
          // ),
          Wrap(
            children: [
              if (widget.cautionModel.receiverItemWasAccepted == null)
                IconButton(
                  onPressed: () async {
                    var contextLocal = context.read<CautionReceiverBloc>();
                    String? res = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        return const DialogDescription(
                          title: 'Descrição',
                          formFieldLabel: '',
                        );
                      },
                    );
                    if (res != null) {
                      contextLocal
                          .add(CautionReceiverEventUpdateWasAcceptedWithRefused(
                        cautionModel: widget.cautionModel,
                        description: res,
                      ));
                    }
                  },
                  icon: const Icon(
                    Icons.not_interested,
                  ),
                ),
              if (widget.cautionModel.receiverItemWasAccepted == null)
                IconButton(
                  onPressed: () {
                    context
                        .read<CautionReceiverBloc>()
                        .add(CautionReceiverEventUpdateWasAcceptedWithAccepted(
                          widget.cautionModel,
                        ));
                  },
                  icon: const Icon(
                    Icons.check_outlined,
                  ),
                ),
              if (widget.cautionModel.receiverIsStartGiveback == false)
                IconButton(
                  onPressed: () async {
                    var contextLocal = context.read<CautionReceiverBloc>();

                    String? res = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const DialogDescription(
                          title: 'Descrição',
                          formFieldLabel: '',
                        );
                      },
                    );
                    if (res != null) {
                      contextLocal
                          .add(CautionReceiverEventUpdateIsStartGiveback(
                        cautionModel: widget.cautionModel,
                        description: res,
                      ));
                    }
                  },
                  icon: const Icon(
                    Icons.assignment_return,
                  ),
                ),
              if (widget.cautionModel.receiverItemWasAccepted == true)
                IconButton(
                  onPressed: () {
                    context
                        .read<CautionReceiverBloc>()
                        .add(CautionReceiverEventUpdateIsPermanentItem(
                          widget.cautionModel,
                        ));
                  },
                  icon: widget.cautionModel.receiverIsPermanentItem == true
                      ? const Icon(Icons.home)
                      : const Icon(Icons.person),
                ),
              // if (widget.cautionModel.receiverIsPermanentItem == true &&
              //     widget.cautionModel.receiverItemWasAccepted == true)
              //   IconButton(
              //     onPressed: () {
              //       // Get.toNamed(Routes.itemAddEdit, arguments: cautionModel);
              //       widget._cautionReceiverController
              //           .updateReceiverIsPermanentItem(
              //               widget.cautionModel, false);
              //     },
              //     icon: const Icon(
              //       Icons.person_off,
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
