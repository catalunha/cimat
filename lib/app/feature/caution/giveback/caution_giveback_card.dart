import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/authentication/bloc/authentication_bloc.dart';
import '../../../core/models/caution_model.dart';
import '../../../core/models/user_model.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_text_title_value.dart';
import '../utils/dialog_description.dart';
import 'bloc/caution_giveback_bloc.dart';
import 'bloc/caution_giveback_event.dart';

class CautionGivebackCard extends StatefulWidget {
  final CautionModel cautionModel;
  const CautionGivebackCard({Key? key, required this.cautionModel})
      : super(key: key);

  @override
  State<CautionGivebackCard> createState() => _CautionGivebackCardState();
}

class _CautionGivebackCardState extends State<CautionGivebackCard> {
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/y HH:mm');
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
                  const Text('Entregador'),
                  Text('${widget.cautionModel.deliveryUserProfile?.nickname}'),
                ],
              ),
              Column(
                children: [
                  AppImageShow(
                    photoUrl: widget.cautionModel.item!.image?.photoUrl,
                    height: 125,
                    width: 150,
                  ),
                  Text(
                    '${widget.cautionModel.item!.description}',
                  ),
                  Text(
                    'Série: ${widget.cautionModel.item!.serie} Lote: ${widget.cautionModel.item!.lote}',
                  ),
                ],
              ),
              Column(
                children: [
                  AppImageShow(
                    photoUrl: widget.cautionModel.receiverUserProfile!.photo,
                    height: 125,
                    // width: 150,
                  ),
                  const Text('operador'),
                  Text('${widget.cautionModel.receiverUserProfile?.nickname}'),
                ],
              ),
            ],
          ),
          // AppTextTitleValue(
          //   title: 'Item: ',
          //   value: widget.cautionModel.item!.description,
          // ),
          // AppTextTitleValue(
          //   title: 'Entregue por: ',
          //   value: widget.cautionModel.deliveryUserProfile!.nickname!,
          // ),
          AppTextTitleValue(
            title: 'Entregue em: ',
            value: dateFormat.format(widget.cautionModel.deliveryDt!),
          ),
          // AppTextTitleValue(
          //   title: 'Cautelado a: ',
          //   value: widget.cautionModel.receiverUserProfile!.nickname!,
          // ),
          AppTextTitleValue(
            title: 'Situação da análise ? ',
            value: widget.cautionModel.receiverItemWasAccepted == null
                ? 'Analisando'
                : widget.cautionModel.receiverItemWasAccepted == true
                    ? 'Aceito'
                    : 'Recusado',
          ),
          AppTextTitleValue(
            title: 'Analisado em: ',
            value: widget.cautionModel.receiverAnalyzedItemDt == null
                ? '...'
                : dateFormat
                    .format(widget.cautionModel.receiverAnalyzedItemDt!),
          ),
          AppTextTitleValue(
            title: 'Em item permanente ? ',
            value: widget.cautionModel.receiverIsPermanentItem == false
                ? 'Não'
                : 'Sim',
          ),
          AppTextTitleValue(
            title: 'Situação da devolução ? ',
            value: widget.cautionModel.receiverIsStartGiveback == null
                ? 'Analisando'
                : widget.cautionModel.receiverIsStartGiveback == false
                    ? 'Nao devolver. Em uso.'
                    : 'Devolução iniciada',
          ),
          AppTextTitleValue(
            title: 'Devolvido em: ',
            value: widget.cautionModel.receiverGivebackItemDt == null
                ? '...'
                : dateFormat
                    .format(widget.cautionModel.receiverGivebackItemDt!),
          ),
          AppTextTitleValue(
            title: 'Descrição da devolução: ',
            value: widget.cautionModel.receiverGivebackDescription,
            inColumn: true,
          ),
          AppTextTitleValue(
            title: 'Recebido por: ',
            value: widget.cautionModel.givebackUserProfile?.nickname,
          ),
          AppTextTitleValue(
            title: 'Situação da recebimento ? ',
            value: widget.cautionModel.receiverIsStartGiveback != true
                ? '...'
                : widget.cautionModel.givebackItemWasAccepted == null
                    ? 'Analisando'
                    : widget.cautionModel.givebackItemWasAccepted == false
                        ? 'Com observações.'
                        : 'Normal',
          ),
          AppTextTitleValue(
            title: 'Recebido em: ',
            value: widget.cautionModel.givebackAnalyzedItemDt == null
                ? '...'
                : dateFormat
                    .format(widget.cautionModel.givebackAnalyzedItemDt!),
          ),
          AppTextTitleValue(
            title: 'Descrição do recebimento: ',
            value: widget.cautionModel.givebackDescription,
          ),
          Wrap(
            children: [
              if (widget.cautionModel.receiverIsStartGiveback == true)
                IconButton(
                  onPressed: () async {
                    var contextBlocLocal = context.read<CautionGivebackBloc>();
                    var contextAuthLocal = context.read<AuthenticationBloc>();

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
                      UserModel user = contextAuthLocal.state.user!;
                      contextBlocLocal
                          .add(CautionGivebackEventUpdateWasAcceptedWithRefused(
                        userProfileGiveback: user.userProfile!,
                        cautionModel: widget.cautionModel,
                        description: res,
                      ));
                    }
                    // setState(() {});
                  },
                  icon: const Icon(
                    Icons.not_interested,
                  ),
                ),
              if (widget.cautionModel.receiverIsStartGiveback == true)
                IconButton(
                  onPressed: () {
                    UserModel user =
                        context.read<AuthenticationBloc>().state.user!;
                    context
                        .read<CautionGivebackBloc>()
                        .add(CautionGivebackEventUpdateWasAcceptedWithAccepted(
                          userProfileGiveback: user.userProfile!,
                          cautionModel: widget.cautionModel,
                        ));
                  },
                  icon: const Icon(
                    Icons.check_outlined,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
