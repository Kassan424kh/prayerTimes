import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AppSettings {
  static Future get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future get _defaultAppSettingsJsonAsString async {
    return await rootBundle.loadString('assets/defaultAppSettings.json');
  }

  static Future get _appSettingsFile async {
    final path = await _localPath;
    return File('$path/appSettings.json');
  }

  static Future<bool> get isAppSettingsFileExists async {
    final path = await _localPath;
    return File('$path/appSettings.json').exists();
  }

  static Future<Map<String, dynamic>> get jsonFromDefaultAppSettingsFile async {
    try {
      Map<String, dynamic> defaultAppSettings =
          await json.decode(await _defaultAppSettingsJsonAsString);
      return defaultAppSettings;
    } catch (e) {
      print("14"); print(e);
      print('cann\'t read data from defaultAppSettings json File');
      return null;
    }
  }

  // Only write if appSettings not exists, main first time after app installation
  static Future<void> get writeDefaultAppSettingsToAppSettingsJsonFile async {
    await isAppSettingsFileExists.then((isExists) async {
      if (!isExists) {
        try {
          print("created appSettings.json file from defaultAppSettings.json data");
          final file = await _appSettingsFile;
          jsonFromDefaultAppSettingsFile.then((defaultData) async{
            await file.writeAsString(json.encode(defaultData));
          });
        } catch (e) {
          print('cann\'t saved data to appSettings File');
          print("15"); print(e);
        }
      }
    });
  }

  static Future<Map<String, dynamic>> get jsonFromAppSettingsFile async {
    try {
      final file = await _appSettingsFile;
      Map<String, dynamic> appSettings =
      await json.decode(await file.readAsString());
      return appSettings;
    } catch (e) {
      print('cann\'t read data from AppSettings json File');
      print("16"); print(e);
      return null;
    }
  }

  /// To update settings in the appSettingsFile first get all old Settings as Map
  /// from "jsonFromAppSettingsFile" function then set your changes on the Map request
  /// after that use "updateSettingsInAppSettingsJsonFile" function with the new
  /// Map data in the function data attribute.
  static Future<bool> updateSettingsInAppSettingsJsonFile(Map<String, dynamic> data) async {
    return await isAppSettingsFileExists.then((isExists) async {
      if (isExists) {
        try {
          final file = await _appSettingsFile;
          await file.writeAsString(json.encode(data));
          print("Successfully updated settings in appSettings.json file");
          print(data);
          return true;
        } catch (e) {
          print('cann\'t saved data to appSettings.json File');
          print("17"); print(e);
          return false;
        }
      }else{
        print("Cann't updating appSettings file, while file isn't exsets");
        return false;
      }
    });
  }
}
