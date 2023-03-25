import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/authentication/bloc/authentication_bloc.dart';
import '../../../core/models/user_model.dart';
import '../../../core/repositories/caution_repository.dart';
import 'bloc/caution_receiver_bloc.dart';
import 'bloc/caution_receiver_event.dart';
import 'bloc/caution_receiver_state.dart';
import 'caution_receiver_card.dart';

class CautionReceiverPage extends StatelessWidget {
  const CautionReceiverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider(
        create: (context) => CautionRepository(),
        child: BlocProvider(
          create: (context) {
            UserModel user = context.read<AuthenticationBloc>().state.user!;

            return CautionReceiverBloc(
                cautionRepository:
                    RepositoryProvider.of<CautionRepository>(context))
              ..add(CautionReceiverEventGetCautions(user));
          },
          child: const CautionReceiverView(),
        ),
      ),
    );
  }
}

class CautionReceiverView extends StatefulWidget {
  const CautionReceiverView({super.key});

  @override
  State<CautionReceiverView> createState() => _CautionReceiverViewState();
}

class _CautionReceiverViewState extends State<CautionReceiverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CautionReceiverBloc, CautionReceiverState>(
          builder: (context, state) {
            if (state.filteredIsTemporary) {
              return const Text('Itens temporários');
            } else {
              return const Text('Itens permanentes');
            }
          },
        ),
        actions: [
          BlocBuilder<CautionReceiverBloc, CautionReceiverState>(
            builder: (context, state) {
              if (state.filteredIsTemporary) {
                return IconButton(
                    onPressed: () {
                      context.read<CautionReceiverBloc>().add(
                          CautionReceiverEventFilterChange(
                              filterIsTemporary: false));
                    },
                    icon: const Icon(Icons.timelapse));
              } else {
                return IconButton(
                    onPressed: () {
                      context.read<CautionReceiverBloc>().add(
                          CautionReceiverEventFilterChange(
                              filterIsTemporary: true));
                    },
                    icon: const Icon(Icons.access_time));
              }
            },
          )
        ],
      ),
      body: BlocListener<CautionReceiverBloc, CautionReceiverState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == CautionReceiverStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == CautionReceiverStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == CautionReceiverStateStatus.loading) {
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
                  child: BlocBuilder<CautionReceiverBloc, CautionReceiverState>(
                    builder: (context, state) {
                      return ListView.builder(
                        itemCount: state.cautionModelListFiltered.length,
                        itemBuilder: (context, index) {
                          final cautionModel =
                              state.cautionModelListFiltered[index];
                          return CautionReceiverCard(
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
      ),
    );
  }
}
