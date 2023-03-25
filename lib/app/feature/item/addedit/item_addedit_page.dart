import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/image_model.dart';
import '../../../core/models/item_model.dart';
import '../../../core/repositories/item_repository.dart';
import '../../utils/app_photo_show.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/item_search_bloc.dart';
import '../search/bloc/item_search_event.dart';
import 'bloc/item_add_edit_bloc.dart';
import 'bloc/item_add_edit_event.dart';
import 'bloc/item_add_edit_state.dart';

class ItemAddEditPage extends StatelessWidget {
  final ItemModel? itemModel;

  const ItemAddEditPage({super.key, this.itemModel});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ItemRepository(),
      child: BlocProvider(
        create: (context) => ItemAddEditBloc(
            itemModel: itemModel,
            itemRepository: RepositoryProvider.of<ItemRepository>(context)),
        child: ItemAddEditView(
          itemModel: itemModel,
        ),
      ),
    );
  }
}

class ItemAddEditView extends StatefulWidget {
  final ItemModel? itemModel;
  const ItemAddEditView({Key? key, required this.itemModel}) : super(key: key);

  @override
  State<ItemAddEditView> createState() => _ItemAddEditViewState();
}

class _ItemAddEditViewState extends State<ItemAddEditView> {
  final _formKey = GlobalKey<FormState>();
  final descriptionTEC = TextEditingController();
  final serieTEC = TextEditingController();
  final loteTEC = TextEditingController();
  final brandTEC = TextEditingController();
  final modelTEC = TextEditingController();
  final calibreTEC = TextEditingController();
  final docTEC = TextEditingController();
  final obsCautionTEC = TextEditingController();
  bool isMunition = false;
  bool isBlockedOperator = false;
  bool isBlockedDoc = false;
  final groupsTEC = TextEditingController();
  final quantityTEC = TextEditingController();
  ImageModel? imageModel;
  DateTime? validate;
  @override
  void initState() {
    super.initState();
    descriptionTEC.text = widget.itemModel?.description ?? "";
    serieTEC.text = widget.itemModel?.serie ?? "";
    loteTEC.text = widget.itemModel?.lote ?? "";
    brandTEC.text = widget.itemModel?.brand ?? "";
    modelTEC.text = widget.itemModel?.model ?? "";
    calibreTEC.text = widget.itemModel?.calibre ?? "";
    docTEC.text = widget.itemModel?.doc ?? "";
    obsCautionTEC.text = widget.itemModel?.obsCaution ?? "";
    isMunition = widget.itemModel?.isMunition ?? false;
    isBlockedOperator = widget.itemModel?.isBlockedOperator ?? false;
    isBlockedDoc = widget.itemModel?.isBlockedDoc ?? false;
    groupsTEC.text = widget.itemModel?.groups?.join('\n') ?? "";
    quantityTEC.text = '1';
    imageModel = widget.itemModel?.image;
    validate = widget.itemModel?.validate ??
        DateTime.now().add(const Duration(days: 365));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar/Editar este item'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<ItemAddEditBloc>().add(
                  ItemAddEditEventFormSubmitted(
                    description: descriptionTEC.text,
                    serie: serieTEC.text,
                    lote: loteTEC.text,
                    brand: brandTEC.text,
                    model: modelTEC.text,
                    calibre: calibreTEC.text,
                    doc: docTEC.text,
                    obsCaution: obsCautionTEC.text,
                    isMunition: isMunition,
                    isBlockedOperator: isBlockedOperator,
                    isBlockedDoc: isBlockedDoc,
                    groups: groupsTEC.text,
                    quantity: int.tryParse(quantityTEC.text) == null
                        ? 1
                        : int.parse(quantityTEC.text),
                    imageModel: imageModel,
                    validate: validate,
                  ),
                );
          }
        },
      ),
      body: BlocListener<ItemAddEditBloc, ItemAddEditState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ItemAddEditStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ItemAddEditStateStatus.success) {
            Navigator.of(context).pop();
            if (widget.itemModel != null) {
              context
                  .read<ItemSearchBloc>()
                  .add(ItemSearchEventUpdateList(state.itemModel!));
            }
            Navigator.of(context).pop();
          }
          if (state.status == ItemAddEditStateStatus.loading) {
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
                      const SizedBox(height: 5),
                      AppTextFormField(
                        label: 'Descrição',
                        controller: descriptionTEC,
                        validator:
                            Validatorless.required('Descrição é obrigatório'),
                      ),
                      AppTextFormField(
                        label: 'Série',
                        controller: serieTEC,
                      ),
                      AppTextFormField(
                        label: 'Lote',
                        controller: loteTEC,
                      ),
                      AppTextFormField(
                        label: 'Marca',
                        controller: brandTEC,
                      ),
                      AppTextFormField(
                        label: 'Modelo',
                        controller: modelTEC,
                      ),
                      AppTextFormField(
                        label: 'Calibre',
                        controller: calibreTEC,
                      ),
                      AppTextFormField(
                        label: 'Documentação',
                        controller: docTEC,
                        maxLines: 5,
                      ),
                      AppTextFormField(
                        label: 'Observações para cautelar',
                        controller: obsCautionTEC,
                      ),
                      CheckboxListTile(
                        title: const Text("É uma munição de arma de fogo ?"),
                        value: isMunition,
                        onChanged: (value) {
                          setState(() {
                            isMunition = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text("Esta bloqueada para cautela ?"),
                        value: isBlockedOperator,
                        onChanged: (value) {
                          setState(() {
                            isBlockedOperator = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text("Esta bloqueada pela documentação ?"),
                        value: isBlockedDoc,
                        onChanged: (value) {
                          setState(() {
                            isBlockedDoc = value!;
                          });
                        },
                      ),
                      AppTextFormField(
                        label: 'Grupos a que pertence (um grupo por linha):',
                        controller: groupsTEC,
                        maxLines: 5,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                ImageModel? result = await Navigator.of(context)
                                    .pushNamed('/image/search') as ImageModel?;
                                if (result != null) {
                                  setState(() {
                                    imageModel = result;
                                  });
                                }
                              },
                              icon: const Icon(Icons.search)),
                          Expanded(
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: AppImageShow(
                                photoUrl: imageModel?.photoUrl,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text('Manutenção/Validade'),
                      SizedBox(
                        width: 300,
                        height: 100,
                        child: CupertinoDatePicker(
                          initialDateTime: validate,
                          mode: CupertinoDatePickerMode.date,
                          onDateTimeChanged: (DateTime newDate) {
                            validate = newDate;
                          },
                        ),
                      ),
                      if (widget.itemModel == null)
                        AppTextFormField(
                          label: 'Quantidade a ser inserida:',
                          controller: quantityTEC,
                          validator: Validatorless.multiple([
                            Validatorless.number('Apenas números.'),
                            Validatorless.required('Quantidade é obrigatório'),
                            Validatorless.min(
                                1, 'Valor mínimo é 1 (uma) unidade'),
                            Validatorless.max(
                                100, 'Valor máximo é 100 (cem) unidades'),
                          ]),
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
}
