import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PrayerTimesDataFromServer {
  String _dtNow =
      "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  Future get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future get _localFile async {
    final path = await _localPath;
    return File('$path/serverDataFile.json');
  }

  Future<Map> get prayerTimesFromJsonFile async {
    try {
      final file = await _localFile;
      Map prayerTimesWithDateFromToday =
          await json.decode(await file.readAsString());
      return prayerTimesWithDateFromToday;
    } catch (e) {
      print('cann\t read data from File');
      return null;
    }
  }

  Future writePrayerTimesToJsonFile(Map data) async {
    final file = await _localFile;
    try {
      print('save data to file');
      print(data.toString());
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print('cann\'t saved data to json File');
    }
  }

  Future<List> get getPrayerTimesFromApiServer async {
    //print('get data from restful server');
    String url = 'https://prayer-times.vsyou.app/';
    Map prayerTimesDataToDay = {};
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        prayerTimesDataToDay[_dtNow] = await json.decode(response.body);
        await writePrayerTimesToJsonFile(prayerTimesDataToDay);
        return prayerTimesDataToDay[_dtNow];
      } else {
        print('[Error] connection faild');
        return null;
      }
    } catch (e) {
      print('[Error] faild connection to server $url');
      return null;
    }
  }

  Future<List> getPrayerTimes() async {
    return await prayerTimesFromJsonFile.then((data) async {
      if (data == null) {
        return getPrayerTimesFromApiServer;
      } else {
        if (!data.containsKey(_dtNow)) {
          return getPrayerTimesFromApiServer;
        } else {
          return data[_dtNow];
        }
      }
    });
  }
}
