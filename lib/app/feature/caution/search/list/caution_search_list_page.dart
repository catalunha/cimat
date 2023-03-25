import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/caution_search_bloc.dart';
import '../bloc/caution_search_event.dart';
import '../bloc/caution_search_state.dart';
import 'comp/caution_list.dart';

class CautionSearchListPage extends StatelessWidget {
  const CautionSearchListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CautionSearchListView();
  }
}

class CautionSearchListView extends StatelessWidget {
  const CautionSearchListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cautelas encontrados'),
        actions: [
          IconButton(
            onPressed: () {
              // Get.to(() => CautionPrintPage());
            },
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BlocBuilder<CautionSearchBloc, CautionSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.firstPage
                        ? null
                        : () {
                            context
                                .read<CautionSearchBloc>()
                                .add(CautionSearchEventPreviousPage());
                          },
                    child: Card(
                      color: state.firstPage ? Colors.black : Colors.black45,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: state.firstPage
                              ? const Text('Primeira página')
                              : const Text('Página anterior'),
                        ),
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<CautionSearchBloc, CautionSearchState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: state.lastPage
                        ? null
                        : () {
                            context
                                .read<CautionSearchBloc>()
                                .add(CautionSearchEventNextPage());
                          },
                    child: Card(
                      color: state.lastPage ? Colors.black : Colors.black45,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: state.lastPage
                              ? const Text('Última página')
                              : const Text('Próxima página'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: BlocBuilder<CautionSearchBloc, CautionSearchState>(
                builder: (context, state) {
                  return CautionList(
                    cautionList: state.cautionModelList,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
