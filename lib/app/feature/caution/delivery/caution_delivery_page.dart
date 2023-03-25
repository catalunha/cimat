import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/authentication/bloc/authentication_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/caution_repository.dart';
import '../../../core/repositories/item_repository.dart';
import '../../../core/repositories/user_profile_repository.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/caution_delivery_bloc.dart';
import 'bloc/caution_delivery_event.dart';
import 'bloc/caution_delivery_state.dart';

class CautionDeliveryPage extends StatelessWidget {
  const CautionDeliveryPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ItemRepository(),
        ),
        RepositoryProvider(
          create: (context) => UserProfileRepository(),
        ),
        RepositoryProvider(
          create: (context) => CautionRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => CautionDeliveryBloc(
            itemRepository: RepositoryProvider.of<ItemRepository>(context),
            userProfileRepository:
                RepositoryProvider.of<UserProfileRepository>(context),
            cautionRepository:
                RepositoryProvider.of<CautionRepository>(context)),
        child: const CautionDeliveryView(),
      ),
    );
  }
}

class CautionDeliveryView extends StatefulWidget {
  const CautionDeliveryView({Key? key}) : super(key: key);

  @override
  State<CautionDeliveryView> createState() => _CautionDeliveryViewState();
}

class _CautionDeliveryViewState extends State<CautionDeliveryView> {
  final _formKey = GlobalKey<FormState>();
  final serieTEC = TextEditingController();
  final loteTEC = TextEditingController();
  final registerTEC = TextEditingController();
  final quantityTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    serieTEC.text = "";
    loteTEC.text = "";
    quantityTEC.text = '1';
    registerTEC.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cautela de item - Entrega'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          UserModel user = context.read<AuthenticationBloc>().state.user!;
          context.read<CautionDeliveryBloc>().add(CautionDeliveryEventSendOrder(
                userProfileModelDelivery: user.userProfile!,
              ));
        },
      ),
      body: BlocListener<CautionDeliveryBloc, CautionDeliveryState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == CautionDeliveryStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == CautionDeliveryStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == CautionDeliveryStateStatus.finish) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
          if (state.status == CautionDeliveryStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Center(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text('Selecione o item'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppTextFormField(
                              label: 'Série',
                              controller: serieTEC,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: AppTextFormField(
                              label: 'Lote',
                              controller: loteTEC,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if ((serieTEC.text.isEmpty &&
                                        loteTEC.text.isNotEmpty) ||
                                    (serieTEC.text.isNotEmpty &&
                                        loteTEC.text.isEmpty)) {
                                  context
                                      .read<CautionDeliveryBloc>()
                                      .add(CautionDeliveryEventItemSubmitted(
                                        serie: serieTEC.text,
                                        lote: loteTEC.text,
                                      ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                        content: Text(
                                            'Preencha apenas a série OU lote')));
                                }
                              },
                              icon: const Icon(Icons.search))
                        ],
                      ),
                      BlocBuilder<CautionDeliveryBloc, CautionDeliveryState>(
                        builder: (context, state) {
                          return state.itemList.isNotEmpty
                              ? Column(
                                  children: [
                                    AppImageShow(
                                      photoUrl:
                                          state.itemList[0].image?.photoUrl,
                                      width: 300,
                                      height: 100,
                                    ),
                                    Text(
                                        'Série: ${state.itemList[0].serie} Lote: ${state.itemList[0].lote} Qte :${state.itemList.length}'),
                                    Text(
                                        'Grupos: ${state.itemList[0].groups?.join(', ')}')
                                  ],
                                )
                              : const Text('Nenhum item encontrado');
                        },
                      ),
                      const SizedBox(height: 5),
                      const Divider(height: 5),
                      const Text('Informe a quantidade'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            child: IconButton(
                                onPressed: () {
                                  context.read<CautionDeliveryBloc>().add(
                                      CautionDeliveryEventQuantityDecrement());
                                },
                                icon: const Icon(Icons.exposure_minus_1)),
                          ),
                          const SizedBox(width: 5),
                          BlocBuilder<CautionDeliveryBloc,
                              CautionDeliveryState>(
                            builder: (context, state) {
                              return Text('${state.quantity}',
                                  style: const TextStyle(fontSize: 32));
                            },
                          ),
                          const SizedBox(width: 5),
                          const Text('de'),
                          const SizedBox(width: 5),
                          BlocBuilder<CautionDeliveryBloc,
                              CautionDeliveryState>(
                            builder: (context, state) {
                              return Text('${state.itemList.length}',
                                  style: const TextStyle(fontSize: 24));
                            },
                          ),
                          const SizedBox(width: 5),
                          Card(
                            child: IconButton(
                                onPressed: () {
                                  context.read<CautionDeliveryBloc>().add(
                                      CautionDeliveryEventQuantityIncrement());
                                },
                                icon: const Icon(Icons.plus_one)),
                          ),
                        ],
                      ),
                      const Divider(height: 5),
                      const Text('Informe o operador'),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppTextFormField(
                              label: 'Registro do PM',
                              controller: registerTEC,
                              validator: Validatorless.required(
                                  'Registro do PM é obrigatório'),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                context.read<CautionDeliveryBloc>().add(
                                        CautionDeliveryEventUserProfileSubmitted(
                                      userProfileRegister: registerTEC.text,
                                    ));
                              },
                              icon: const Icon(Icons.search))
                        ],
                      ),
                      BlocBuilder<CautionDeliveryBloc, CautionDeliveryState>(
                        builder: (context, state) {
                          return state.userProfileReceiver != null
                              ? Column(
                                  children: [
                                    AppImageShow(
                                      photoUrl:
                                          state.userProfileReceiver?.photo,
                                      width: 300,
                                      height: 100,
                                    ),
                                    Text(
                                        'Nome: ${state.userProfileReceiver?.nickname}'),
                                    Text(
                                        'Restrições: ${state.userProfileReceiver?.restrictions?.join(', ')}')
                                  ],
                                )
                              : const Text('Nenhum operador encontrado');
                        },
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<bool> saveItem() async {
  //   final formValid = _formKey.currentState?.validate() ?? false;
  //   if (formValid) {
  //     bool resultConsult = await widget._cautionDeliveryController.consult(
  //         serie: serieTEC.text,
  //         lote: loteTEC.text,
  //         register: registerTEC.text,
  //         quantity: int.tryParse(quantityTEC.text) == null
  //             ? 1
  //             : int.parse(quantityTEC.text));
  //     if (resultConsult) {
  //       var result = await Get.toNamed(Routes.cautionDeliveryConfirm);
  //       if (result != null && result == true) {
  //         setState(() {
  //           serieTEC.text = "";
  //           loteTEC.text = "";
  //           quantityTEC.text = '1';
  //         });
  //       } else {
  //         Get.back();
  //       }
  //     }
  //     return resultConsult;
  //   }
  //   return false;
  // }
}
