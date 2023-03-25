import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/caution_repository.dart';
import '../../../core/repositories/item_repository.dart';
import 'bloc/caution_giveback_bloc.dart';
import 'bloc/caution_giveback_event.dart';
import 'bloc/caution_giveback_state.dart';
import 'caution_giveback_card.dart';

class CautionGivebackPage extends StatelessWidget {
  const CautionGivebackPage({
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
          create: (context) => CautionRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => CautionGivebackBloc(
            itemRepository: RepositoryProvider.of<ItemRepository>(context),
            cautionRepository:
                RepositoryProvider.of<CautionRepository>(context))
          ..add(CautionGivebackEventGetCautions()),
        child: const CautionGivebackView(),
      ),
    );
  }
}

class CautionGivebackView extends StatefulWidget {
  const CautionGivebackView({super.key});

  @override
  State<CautionGivebackView> createState() => _CautionGivebackViewState();
}

class _CautionGivebackViewState extends State<CautionGivebackView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CautionGivebackBloc, CautionGivebackState>(
            builder: (context, state) {
              return Text(
                  'Itens para devolução: ${state.cautionModelList.length}');
            },
          ),
        ),
        body: BlocListener<CautionGivebackBloc, CautionGivebackState>(
          listenWhen: (previous, current) {
            return previous.status != current.status;
          },
          listener: (context, state) async {
            if (state.status == CautionGivebackStateStatus.error) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
            }
            if (state.status == CautionGivebackStateStatus.success) {
              Navigator.of(context).pop();
            }
            if (state.status == CautionGivebackStateStatus.loading) {
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 600,
                    child:
                        BlocBuilder<CautionGivebackBloc, CautionGivebackState>(
                      builder: (context, state) {
                        return ListView.builder(
                          itemCount: state.cautionModelList.length,
                          itemBuilder: (context, index) {
                            final cautionModel = state.cautionModelList[index];
                            return CautionGivebackCard(
                              cautionModel: cautionModel,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
