import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/image_model.dart';
import '../../../utils/app_photo_show.dart';
import '../../../utils/app_text_title_value.dart';
import '../../addedit/image_addedit_page.dart';
import '../bloc/image_search_bloc.dart';

class ImageCard extends StatelessWidget {
  final ImageModel imageModel;
  const ImageCard({Key? key, required this.imageModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AppImageShow(
            photoUrl: imageModel.photoUrl,
            width: 300,
            height: 100,
          ),
          AppTextTitleValue(
            title: 'Id: ',
            value: imageModel.id,
          ),
          Text(
            '${imageModel.keywords?.join(' ')}',
            style: const TextStyle(fontSize: 22),
          ),
          Wrap(
            children: [
              IconButton(
                onPressed: () {
                  // Navigator.of(context)
                  //     .pushNamed('/image/addedit', arguments: imageModel);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ImageSearchBloc>(context),
                        child: ImageAddEditPage(imageModel: imageModel),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Get.back(result: imageModel)
                  Navigator.of(context).pop(imageModel);
                },
                icon: const Icon(
                  Icons.check,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
