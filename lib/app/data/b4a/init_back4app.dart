import 'dart:developer';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'b4a_exception.dart';

class InitBack4app {
  Future<bool> init() async {
    try {
      log('+++InitBack4app');
      const keyApplicationIdDartDefineFile =
          String.fromEnvironment('keyApplicationId');
      const keyClientKeyDartDefineFile = String.fromEnvironment('keyClientKey');
      const keyParseServerUrl = 'https://parseapi.back4app.com';
      log('---InitBack4app: $keyApplicationIdDartDefineFile');
      log('---InitBack4app');
      await Parse().initialize(
        keyApplicationIdDartDefineFile,
        keyParseServerUrl,
        clientKey: keyClientKeyDartDefineFile,
        autoSendSessionId: true,
        debug: true,
      );
      ParseResponse healthCheck = (await Parse().healthCheck());
      if (healthCheck.success) {
        return true;
      }
      throw Exception();
    } catch (e) {
      print('+++ InitBack4app.init');
      print(e);
      print('--- InitBack4app.init');
      throw B4aException('Erro em inicializar o banco de dados');
    }
  }
}
