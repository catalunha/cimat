import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cimat/app/core/models/image_model.dart';
import 'package:cimat/app/core/repositories/image_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/b4a/entity/image_entity.dart';
import '../../../../data/b4a/utils/xfile_to_parsefile.dart';

part 'image_add_edit_event.dart';
part 'image_add_edit_state.dart';

class ImageAddEditBloc extends Bloc<ImageAddEditEvent, ImageAddEditState> {
  final ImageRepository _imageRepository;
  ImageAddEditBloc(
      {required ImageModel? imageModel,
      required ImageRepository imageRepository})
      : _imageRepository = imageRepository,
        super(ImageAddEditState.initial(imageModel: imageModel)) {
    on<ImageAddEditEventSendXFile>(_onImageAddEditEventSendXFile);
    on<ImageAddEditEventFormSubmitted>(_onImageAddEditEventFormSubmitted);
  }

  FutureOr<void> _onImageAddEditEventSendXFile(
      ImageAddEditEventSendXFile event, Emitter<ImageAddEditState> emit) {
    emit(state.copyWith(xfile: event.xfile));
  }

  FutureOr<void> _onImageAddEditEventFormSubmitted(
      ImageAddEditEventFormSubmitted event,
      Emitter<ImageAddEditState> emit) async {
    emit(state.copyWith(status: ImageAddEditStateStatus.loading));
    try {
      List<String> keywordsList =
          event.keywords.isEmpty ? [] : event.keywords.split(' ');
      ImageModel imageModel;
      if (state.imageModel == null) {
        imageModel = ImageModel(keywords: keywordsList);
      } else {
        imageModel = state.imageModel!.copyWith(
          keywords: keywordsList,
        );
      }

      String imageModelId = await _imageRepository.update(imageModel);
      if (state.xfile != null) {
        String? photoUrl = await XFileToParseFile.xFileToParseFile(
          xfile: state.xfile!,
          className: ImageEntity.className,
          objectId: imageModelId,
          objectAttribute: 'file',
        );
        imageModel = imageModel.copyWith(id: imageModelId, photoUrl: photoUrl);
      }

      emit(state.copyWith(
          imageModel: imageModel, status: ImageAddEditStateStatus.success));
    } catch (e) {
      print(e);
      emit(state.copyWith(
          status: ImageAddEditStateStatus.error,
          error: 'Erro ao salvar imagem'));
    }
  }
}
