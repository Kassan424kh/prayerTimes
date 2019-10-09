import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'app_settings.dart';

class PrayerTimesDataFromServer {
  AppSettings appSettings = new AppSettings();
  static const android = const MethodChannel("app.native/updater");

  Future get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future get _localFile async {
    final path = await _localPath;
    return File('$path/serverDataFile.json');
  }

  Future<List> get prayerTimesFromJsonFile async {
    try {
      //print('Read data from file');
      final file = await _localFile;
      List prayerTimesWithDateFromToday = await json.decode(await file.readAsString());
      return prayerTimesWithDateFromToday;
    } catch (e) {
      print('cann\t read data from File');
      return null;
    }
  }

  Future writePrayerTimesToJsonFile(List data) async {
    final file = await _localFile;
    try {
      print('Write data to file');
      print(data.toString());
      await file.writeAsString(json.encode(data));
    } catch (e) {
      Timer(const Duration(seconds: 5), () {
        updatePrayerTimesCompletely;
      });

      print("cann't saved data to json File");
    }
  }

  DateTime dateTimeFromStringConverter(String dtString) {
    DateTime dt = DateTime.parse(dtString);
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  }

  DateTime dateTimeFromDateConverter(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  }

  List setActivePrayerTime(data) {
    return data.map((prsData) {
      for (String key in prsData.keys.toList()) {
        if (key != 'active') {
          List times = prsData[key];
          DateTime now = dateTimeFromDateConverter(DateTime.now());
          DateTime start = dateTimeFromStringConverter(times[0]);
          DateTime end = dateTimeFromStringConverter(times[1]);

          if (start.isAtSameMomentAs(now) || start.isBefore(now) && end.isAfter(now)) {
            prsData['active'] = true;
          } else {
            prsData['active'] = false;
          }
          return prsData;
        }
      }
    }).toList();
  }

  Future<bool> get updateTodayPrayerTimes async {
    try {
      final bool result = await android.invokeMethod('updateTodayPrayerTimes');
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> get updatePrayerTimesCompletely async {
    try {
      final bool result = await android.invokeMethod('updatePrayerTimesAfterNewPlaceData');
      if (result) updateTodayPrayerTimes;
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List> getPrayerTimes() async {
    return await prayerTimesFromJsonFile.then((data) async {
      List getData;
      if (data == null) updatePrayerTimesCompletely;
      getData = data;

      return getData;
    });
  }
}
