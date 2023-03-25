import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/models/image_model.dart';
import '../../../core/repositories/image_repository.dart';
import '../../utils/app_import_image.dart';
import '../../utils/app_textformfield.dart';
import '../search/bloc/image_search_bloc.dart';
import '../search/bloc/image_search_event.dart';
import 'bloc/image_add_edit_bloc.dart';

class ImageAddEditPage extends StatelessWidget {
  final ImageModel? imageModel;

  const ImageAddEditPage({super.key, this.imageModel});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ImageRepository(),
      child: BlocProvider(
        create: (context) => ImageAddEditBloc(
            imageModel: imageModel,
            imageRepository: RepositoryProvider.of<ImageRepository>(context)),
        child: ImageAddEditView(
          imageModel: imageModel,
        ),
      ),
    );
  }
}

class ImageAddEditView extends StatefulWidget {
  final ImageModel? imageModel;
  const ImageAddEditView({Key? key, required this.imageModel})
      : super(key: key);

  @override
  State<ImageAddEditView> createState() => _ImageAddEditViewState();
}

class _ImageAddEditViewState extends State<ImageAddEditView> {
  final _formKey = GlobalKey<FormState>();
  final keywordsTEC = TextEditingController();
  @override
  void initState() {
    super.initState();
    keywordsTEC.text = widget.imageModel?.keywords?.join(' ') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar/Editar imagem'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.cloud_upload),
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            context.read<ImageAddEditBloc>().add(
                  ImageAddEditEventFormSubmitted(
                    keywords: keywordsTEC.text,
                  ),
                );
          }
        },
      ),
      body: BlocListener<ImageAddEditBloc, ImageAddEditState>(
        listenWhen: (previous, current) {
          return previous.status != current.status;
        },
        listener: (context, state) async {
          if (state.status == ImageAddEditStateStatus.error) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error ?? '...')));
          }
          if (state.status == ImageAddEditStateStatus.success) {
            Navigator.of(context).pop();
            context
                .read<ImageSearchBloc>()
                .add(ImageSearchEventUpdateList(state.imageModel!));
            Navigator.of(context).pop();
          }
          if (state.status == ImageAddEditStateStatus.loading) {
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
                        label: 'Palavra(s) chave. Separados por espaço.',
                        controller: keywordsTEC,
                        validator: Validatorless.required(
                            'Palavra(s) chave é obrigatório'),
                      ),
                      const SizedBox(height: 50),
                      AppImportImage(
                        label:
                            'Click aqui para buscar sua foto, apenas face. Padrão 3x4.',
                        imageUrl: widget.imageModel?.photoUrl,
                        setXFile: (value) => context
                            .read<ImageAddEditBloc>()
                            .add(ImageAddEditEventSendXFile(xfile: value)),
                        maxHeightImage: 150,
                        maxWidthImage: 100,
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
