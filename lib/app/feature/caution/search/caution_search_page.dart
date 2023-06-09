import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/bloc/authentication_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/caution_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import 'bloc/caution_search_bloc.dart';
import 'bloc/caution_search_event.dart';
import 'bloc/caution_search_state.dart';
import 'list/caution_search_list_page.dart';

class CautionSearchPage extends StatelessWidget {
  final bool isOperator;
  const CautionSearchPage({
    Key? key,
    required this.isOperator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CautionRepository(),
      child: BlocProvider(
        create: (context) {
          UserModel? user;
          if (isOperator) {
            user = context.read<AuthenticationBloc>().state.user!;
          }
          return CautionSearchBloc(
              cautionRepository:
                  RepositoryProvider.of<CautionRepository>(context))
            ..add(CautionSearchEventIsOperator(user));
        },
        child: const CautionSearchView(),
      ),
    );
  }
}

class CautionSearchView extends StatefulWidget {
  const CautionSearchView({Key? key}) : super(key: key);

  @override
  State<CautionSearchView> createState() => _SearchPageState();
}

class _SearchPageState extends State<CautionSearchView> {
  final _formKey = GlobalKey<FormState>();
  bool _deliveryDtSelected = false;
  DateTime _deliveryDtValue = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscando Cautelas'),
      ),
      body: BlocListener<CautionSearchBloc, CautionSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == CautionSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == CautionSearchStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == CautionSearchStateStatus.loading) {
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
                          const Text('por Data de entrega'),
                          Row(
                            children: [
                              Checkbox(
                                value: _deliveryDtSelected,
                                onChanged: (value) {
                                  setState(() {
                                    _deliveryDtSelected = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 300,
                                  height: 100,
                                  child: CupertinoDatePicker(
                                    initialDateTime: _deliveryDtValue,
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (DateTime newDate) {
                                      _deliveryDtValue = newDate;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
            context
                .read<CautionSearchBloc>()
                .add(CautionSearchEventFormSubmitted(
                  deliveryDtSelected: _deliveryDtSelected,
                  deliveryDtValue: _deliveryDtValue,
                ));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<CautionSearchBloc>(context),
                  child: const CautionSearchListPage(),
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
