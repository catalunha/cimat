import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../../core/models/image_model.dart';
import '../../../../core/repositories/image_repository.dart';
import '../../../../data/b4a/entity/image_entity.dart';
import '../../../../data/utils/pagination.dart';
import 'image_search_event.dart';
import 'image_search_state.dart';

class ImageSearchBloc extends Bloc<ImageSearchEvent, ImageSearchState> {
  final ImageRepository _imageRepository;

  ImageSearchBloc({required ImageRepository imageRepository})
      : _imageRepository = imageRepository,
        super(ImageSearchState.initial()) {
    on<ImageSearchEventPreviousPage>(_onImageSearchEventPreviousPage);
    on<ImageSearchEventNextPage>(_onImageSearchEventNextPage);
    on<ImageSearchEventFormSubmitted>(_onImageSearchEventFormSubmitted);
    on<ImageSearchEventUpdateList>(_onImageSearchEventUpdateList);
  }

  FutureOr<void> _onImageSearchEventPreviousPage(
      ImageSearchEventPreviousPage event,
      Emitter<ImageSearchState> emit) async {
    emit(
      state.copyWith(
        status: ImageSearchStateStatus.loading,
      ),
    );
    if (state.page > 1) {
      emit(
        state.copyWith(
          page: state.page - 1,
        ),
      );
      List<ImageModel> imageModelListGet = await _imageRepository.list(
        state.query,
        Pagination(page: state.page, limit: state.limit),
      );
      if (state.page == 1) {
        emit(
          state.copyWith(
            page: 1,
            firstPage: true,
            lastPage: false,
          ),
        );
      }
      emit(state.copyWith(
        status: ImageSearchStateStatus.success,
        imageModelList: imageModelListGet,
        lastPage: false,
      ));
    } else {
      emit(state.copyWith(
        status: ImageSearchStateStatus.success,
        lastPage: false,
      ));
    }
  }

  FutureOr<void> _onImageSearchEventNextPage(
      ImageSearchEventNextPage event, Emitter<ImageSearchState> emit) async {
    emit(
      state.copyWith(status: ImageSearchStateStatus.loading),
    );
    List<ImageModel> imageModelListGet = await _imageRepository.list(
      state.query,
      Pagination(page: state.page + 1, limit: state.limit),
    );
    if (imageModelListGet.isEmpty) {
      emit(state.copyWith(
        status: ImageSearchStateStatus.success,
        // firstPage: false,
        lastPage: true,
      ));
    } else {
      emit(state.copyWith(
        status: ImageSearchStateStatus.success,
        imageModelList: imageModelListGet,
        page: state.page + 1,
        firstPage: false,
      ));
    }
  }

  FutureOr<void> _onImageSearchEventFormSubmitted(
      ImageSearchEventFormSubmitted event,
      Emitter<ImageSearchState> emit) async {
    emit(state.copyWith(
      status: ImageSearchStateStatus.loading,
      firstPage: true,
      lastPage: false,
      page: 1,
      imageModelList: [],
      query: QueryBuilder<ParseObject>(ParseObject(ImageEntity.className)),
    ));
    try {
      QueryBuilder<ParseObject> query =
          QueryBuilder<ParseObject>(ParseObject(ImageEntity.className));

      var keywordsList =
          event.keywords.isEmpty ? [] : event.keywords.split(' ');
      if (keywordsList.isNotEmpty) {
        query.whereContainedIn('keywords', keywordsList);
      }
      query.orderByDescending('updatedAt');
      List<ImageModel> imageModelListGet = await _imageRepository.list(
        query,
        Pagination(page: state.page, limit: state.limit),
      );
      emit(state.copyWith(
        status: ImageSearchStateStatus.success,
        imageModelList: imageModelListGet,
        query: query,
      ));
    } catch (_) {
      emit(
        state.copyWith(
            status: ImageSearchStateStatus.error,
            error: 'Erro na montagem da busca'),
      );
    }
  }

  FutureOr<void> _onImageSearchEventUpdateList(
      ImageSearchEventUpdateList event, Emitter<ImageSearchState> emit) {
    int index = state.imageModelList
        .indexWhere((model) => model.id == event.imageModel.id);
    if (index >= 0) {
      List<ImageModel> imageModelListTemp = [...state.imageModelList];
      imageModelListTemp.replaceRange(index, index + 1, [event.imageModel]);
      emit(state.copyWith(imageModelList: imageModelListTemp));
    }
  }
}
