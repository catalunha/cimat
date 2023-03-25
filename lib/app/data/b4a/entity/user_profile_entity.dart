import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/user_profile_model.dart';

class UserProfileEntity {
  static const String className = 'UserProfile';

  UserProfileModel fromParse(ParseObject parseObject) {
    UserProfileModel profileModel = UserProfileModel(
      id: parseObject.objectId!,
      email: parseObject.get('email'),
      name: parseObject.get('name'),
      nickname: parseObject.get('nickname'),
      cpf: parseObject.get('cpf'),
      register: parseObject.get('register'),
      phone: parseObject.get('phone'),
      photo: parseObject.get('photo')?.get('url'),
      routes: parseObject.get<List<dynamic>>('routes') != null
          ? parseObject
              .get<List<dynamic>>('routes')!
              .map((e) => e.toString())
              .toList()
          : [],
      restrictions: parseObject.get<List<dynamic>>('restrictions') != null
          ? parseObject
              .get<List<dynamic>>('restrictions')!
              .map((e) => e.toString())
              .toList()
          : [],
      isActive: parseObject.get('isActive'),
    );
    return profileModel;
  }

  Future<ParseObject> toParse(UserProfileModel profileModel) async {
    final profileParseObject = ParseObject(UserProfileEntity.className);
    profileParseObject.objectId = profileModel.id;
    if (profileModel.name != null) {
      profileParseObject.set('name', profileModel.name);
    }
    if (profileModel.nickname != null) {
      profileParseObject.set('nickname', profileModel.nickname);
    }

    if (profileModel.phone != null) {
      profileParseObject.set('phone', profileModel.phone);
    }
    if (profileModel.cpf != null) {
      profileParseObject.set('cpf', profileModel.cpf);
    }
    if (profileModel.register != null) {
      profileParseObject.set('register', profileModel.register);
    }
    if (profileModel.phone != null) {
      profileParseObject.set('phone', profileModel.phone);
    }
    if (profileModel.routes != null) {
      profileParseObject.set('routes', profileModel.routes);
    }
    if (profileModel.restrictions != null) {
      profileParseObject.set('restrictions', profileModel.restrictions);
    }
    profileParseObject.set('isActive', profileModel.isActive);
    return profileParseObject;
  }
}
