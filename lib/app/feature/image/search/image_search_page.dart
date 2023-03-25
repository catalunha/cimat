import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/image_repository.dart';
import '../../utils/app_icon.dart';
import '../../utils/app_textformfield.dart';
import '../addedit/image_addedit_page.dart';
import 'bloc/image_search_bloc.dart';
import 'bloc/image_search_event.dart';
import 'bloc/image_search_state.dart';
import 'comp/image_card.dart';

class ImageSearchPage extends StatelessWidget {
  const ImageSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ImageRepository(),
      child: BlocProvider(
        create: (context) => ImageSearchBloc(
            imageRepository: RepositoryProvider.of<ImageRepository>(context)),
        child: const ImageSearchView(),
      ),
    );
  }
}

class ImageSearchView extends StatefulWidget {
  const ImageSearchView({super.key});

  @override
  State<ImageSearchView> createState() => _ImageSearchViewState();
}

class _ImageSearchViewState extends State<ImageSearchView> {
  final _formKey = GlobalKey<FormState>();
  final _keywordsTEC = TextEditingController();

  @override
  void initState() {
    _keywordsTEC.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar images'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.print),
          )
        ],
      ),
      body: BlocListener<ImageSearchBloc, ImageSearchState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ImageSearchStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ImageSearchStateStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == ImageSearchStateStatus.loading) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        label: 'Informe palavra(s) chave',
                        controller: _keywordsTEC,
                        // validator: Validatorless.required(
                        //     'Palavra(s) é/são obrigatório(as)'),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          print('formValid');

                          // final formValid =
                          //     _formKey.currentState?.validate() ?? false;
                          // if (formValid) {
                          // print(formValid);
                          context.read<ImageSearchBloc>().add(
                                ImageSearchEventFormSubmitted(
                                  keywords: _keywordsTEC.text,
                                ),
                              );
                          // }
                        },
                        icon: const Icon(Icons.search))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<ImageSearchBloc, ImageSearchState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: state.firstPage
                            ? null
                            : () {
                                context
                                    .read<ImageSearchBloc>()
                                    .add(ImageSearchEventPreviousPage());
                              },
                        child: Card(
                          color:
                              state.firstPage ? Colors.black : Colors.black45,
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
                  BlocBuilder<ImageSearchBloc, ImageSearchState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: state.lastPage
                            ? null
                            : () {
                                context
                                    .read<ImageSearchBloc>()
                                    .add(ImageSearchEventNextPage());
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
                  child: BlocBuilder<ImageSearchBloc, ImageSearchState>(
                    builder: (context, state) {
                      return ListView.builder(
                        itemCount: state.imageModelList.length,
                        itemBuilder: (context, index) {
                          final item = state.imageModelList[index];
                          return ImageCard(
                            imageModel: item,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Inserir nova imagem',
          child: const Icon(AppIconData.addInCloud),
          onPressed: () {
            // Navigator.of(context).pushNamed('/image/addedit', arguments: null);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<ImageSearchBloc>(context),
                  child: const ImageAddEditPage(imageModel: null),
                ),
              ),
            );
          }),
    );
  }
}
