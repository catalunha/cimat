import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/item_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/item_search_bloc.dart';
import 'bloc/item_search_event.dart';
import 'bloc/item_search_state.dart';
import 'list/item_search_list_page.dart';

class ItemSearchPage extends StatelessWidget {
  const ItemSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ItemRepository(),
      child: BlocProvider(
        create: (context) => ItemSearchBloc(
            itemRepository: RepositoryProvider.of<ItemRepository>(context)),
        child: const ItemSearchView(),
      ),
    );
  }
}

class ItemSearchView extends StatefulWidget {
  const ItemSearchView({Key? key}) : super(key: key);

  @override
  State<ItemSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<ItemSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool _descriptionContains = false;
  bool _serieContains = false;
  bool _loteContains = false;
  bool _brandContains = false;
  bool _modelContains = false;
  bool _calibreContains = false;
  bool _docContains = false;
  bool _obsCautionContains = false;
  bool _isMunitionEqualsTo = false;
  bool _isBlockedOperatorEqualsTo = false;
  bool _isBlockedDocEqualsTo = false;
  bool _groupEqualsTo = false;
  final _descriptionContainsTEC = TextEditingController();
  final _serieContainsTEC = TextEditingController();
  final _loteContainsTEC = TextEditingController();
  final _brandContainsTEC = TextEditingController();
  final _modelContainsTEC = TextEditingController();
  final _calibreContainsTEC = TextEditingController();
  final _docContainsTEC = TextEditingController();
  final _obsCautionContainsTEC = TextEditingController();
  bool _isMunitionEqualsToValue = false;
  bool _isBlockedOperatorEqualsToValue = false;
  bool _isBlockedDocEqualsToValue = false;
  final _groupEqualsToTEC = TextEditingController();

  @override
  void initState() {
    _descriptionContainsTEC.text = '';
    _serieContainsTEC.text = '';
    _loteContainsTEC.text = '';
    _brandContainsTEC.text = '';
    _modelContainsTEC.text = '';
    _calibreContainsTEC.text = '';
    _docContainsTEC.text = '';
    _obsCautionContainsTEC.text = '';
    _groupEqualsToTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando item'),
      ),
      body: BlocListener<ItemSearchBloc, ItemSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ItemSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ItemSearchStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == ItemSearchStateStatus.loading) {
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          const Text('por Descrição'),
                          Row(
                            children: [
                              Checkbox(
                                value: _descriptionContains,
                                onChanged: (value) {
                                  setState(() {
                                    _descriptionContains = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contém',
                                  controller: _descriptionContainsTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Serie'),
                          Row(
                            children: [
                              Checkbox(
                                value: _serieContains,
                                onChanged: (value) {
                                  setState(() {
                                    _serieContains = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contém',
                                  controller: _serieContainsTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Lote'),
                          Row(
                            children: [
                              Checkbox(
                                value: _loteContains,
                                onChanged: (value) {
                                  setState(() {
                                    _loteContains = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contém',
                                  controller: _loteContainsTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Marca'),
                          Row(
                            children: [
                              Checkbox(
                                value: _brandContains,
                                onChanged: (value) {
                                  setState(() {
                                    _brandContains = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contém',
                                  controller: _brandContainsTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          const Text('por Modelo'),
                          Row(
                            children: [
                              Checkbox(
                                value: _modelContains,
                                onChanged: (value) {
                                  setState(() {
                                    _modelContains = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'que contém',
                                  controller: _modelContainsTEC,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SearchCardText(
                      title: 'por Calibre',
                      label: 'que contém',
                      isSelected: _calibreContains,
                      selectedOnChanged: (value) {
                        setState(() {
                          _calibreContains = value!;
                        });
                      },
                      controller: _calibreContainsTEC,
                    ),
                    SearchCardText(
                      title: 'por Documentação',
                      label: 'que contém',
                      isSelected: _docContains,
                      selectedOnChanged: (value) {
                        setState(() {
                          _docContains = value!;
                        });
                      },
                      controller: _docContainsTEC,
                    ),
                    SearchCardText(
                      title: 'por Observações na cautela',
                      label: 'que contém',
                      isSelected: _obsCautionContains,
                      selectedOnChanged: (value) {
                        setState(() {
                          _obsCautionContains = value!;
                        });
                      },
                      controller: _obsCautionContainsTEC,
                    ),
                    SearchCardText(
                      title: 'por grupo',
                      label: 'igual a',
                      isSelected: _groupEqualsTo,
                      selectedOnChanged: (value) {
                        setState(() {
                          _groupEqualsTo = value!;
                        });
                      },
                      controller: _groupEqualsToTEC,
                    ),
                    SearchCardBool(
                      title: 'Que seja uma Munição',
                      label: 'Selecionada como ?',
                      isSelected: _isMunitionEqualsTo,
                      selectedOnChanged: (value) {
                        setState(() {
                          _isMunitionEqualsTo = value!;
                        });
                      },
                      isSelectedValue: _isMunitionEqualsToValue,
                      selectedValueOnChanged: (value) {
                        setState(() {
                          _isMunitionEqualsToValue = value!;
                        });
                      },
                    ),
                    SearchCardBool(
                      title: 'Que esteja bloqueado para operador',
                      label: 'Selecionada como ?',
                      isSelected: _isBlockedOperatorEqualsTo,
                      selectedOnChanged: (value) {
                        setState(() {
                          _isBlockedOperatorEqualsTo = value!;
                        });
                      },
                      isSelectedValue: _isBlockedOperatorEqualsToValue,
                      selectedValueOnChanged: (value) {
                        setState(() {
                          _isBlockedOperatorEqualsToValue = value!;
                        });
                      },
                    ),
                    SearchCardBool(
                      title: 'Que esteja bloqueado para documentação',
                      label: 'Selecionada como ?',
                      isSelected: _isBlockedDocEqualsTo,
                      selectedOnChanged: (value) {
                        setState(() {
                          _isBlockedDocEqualsTo = value!;
                        });
                      },
                      isSelectedValue: _isBlockedDocEqualsToValue,
                      selectedValueOnChanged: (value) {
                        setState(() {
                          _isBlockedDocEqualsToValue = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 70)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Executar busca',
        child: const Icon(AppIconData.search),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<ItemSearchBloc>().add(ItemSearchEventFormSubmitted(
                  serieContainsBool: _serieContains,
                  serieContainsString: _serieContainsTEC.text,
                  descriptionContainsBool: _descriptionContains,
                  descriptionContainsString: _descriptionContainsTEC.text,
                  loteContainsBool: _loteContains,
                  loteContainsString: _loteContainsTEC.text,
                  brandContainsBool: _brandContains,
                  brandContainsString: _brandContainsTEC.text,
                  modelContainsBool: _modelContains,
                  modelContainsString: _modelContainsTEC.text,
                  calibreContainsBool: _calibreContains,
                  calibreContainsString: _calibreContainsTEC.text,
                  docContainsBool: _docContains,
                  docContainsString: _docContainsTEC.text,
                  obsCautionContainsBool: _obsCautionContains,
                  obsCautionContainsString: _obsCautionContainsTEC.text,
                  groupEqualsToBool: _groupEqualsTo,
                  groupEqualsToString: _groupEqualsToTEC.text,
                  isMunitionEqualsToBool: _isMunitionEqualsTo,
                  isMunitionEqualsToValue: _isMunitionEqualsToValue,
                  isBlockedOperatorEqualsToBool: _isBlockedOperatorEqualsTo,
                  isBlockedOperatorEqualsToValue:
                      _isBlockedOperatorEqualsToValue,
                  isBlockedDocEqualsToBool: _isBlockedDocEqualsTo,
                  isBlockedDocEqualsToValue: _isBlockedDocEqualsToValue,
                ));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ItemSearchBloc>(context),
                  child: const ItemSearchListPage(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class SearchCardText extends StatelessWidget {
  final String title;
  final String label;
  final bool isSelected;
  final Function(bool?)? selectedOnChanged;
  final TextEditingController controller;
  const SearchCardText({
    super.key,
    required this.title,
    required this.label,
    required this.isSelected,
    required this.controller,
    this.selectedOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: selectedOnChanged,
              ),
              Expanded(
                child: AppTextFormField(
                  label: label,
                  controller: controller,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchCardBool extends StatelessWidget {
  final String title;
  final String label;
  final bool isSelected;
  final Function(bool?)? selectedOnChanged;
  final bool isSelectedValue;
  final Function(bool?)? selectedValueOnChanged;
  const SearchCardBool({
    super.key,
    required this.title,
    required this.label,
    required this.isSelected,
    this.selectedOnChanged,
    required this.isSelectedValue,
    this.selectedValueOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: selectedOnChanged,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12,
                  ),
                  child: Row(
                    children: [
                      Text(label),
                      Checkbox(
                        value: isSelectedValue,
                        onChanged: selectedValueOnChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
