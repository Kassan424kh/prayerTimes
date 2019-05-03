import 'dart:async';
import 'dart:convert' as json;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:assets_audio_player/assets_audio_player.dart';

import 'PrayerTimesCard.dart';

Future main() async => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  // variables
  Color _primaryColor = Colors.deepPurpleAccent; //Colors.deepPurpleAccent;
  DateTime now = DateTime.now();
  List _prayerTimes = [
    {
      "لا يوجد صلوات": ["2019-05-02 22:17:00Z", "2019-05-02 23:59:00Z", 6]
    }
  ];
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  Future getPrayerTimesFromAPIServer() async {
    var url = 'https://prayer-times.vsyou.app/';
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _prayerTimes = json.jsonDecode(response.body);
        });
      } else {
        print('[Error] connection faild');
      }
    } catch (e) {
      print('[Error] connection to server $url faild');
      setState(() {
        _prayerTimes = null;
      });
    }
  }

  Future playSound() async {
    await _assetsAudioPlayer.open(AssetsAudio(
      asset: "33432.mp3",
      folder: "assets/audios/",
    ));
  }

  // state functions
  @override
  void initState() {
    super.initState();
    getPrayerTimesFromAPIServer();
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      getPrayerTimesFromAPIServer();
      DateTime dtNow = DateTime.now();
      setState(() {
        now = DateTime(
            dtNow.year, dtNow.month, dtNow.day, dtNow.hour, dtNow.minute);
      });
    });
  }

  // build
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: _prayerTimes != null
            ? ListView(
          scrollDirection: Axis.vertical,
          children: _prayerTimes.map((pt) {
            String key;
            String start;
            String end;
            pt.forEach((k, v) {
              setState(() {
                key = k.toString();
                start = v[0].toString();
                end = v[1].toString();
              });
            });
            DateTime startDateTime = DateTime.parse(start);

            if (now.isAtSameMomentAs(DateTime(
                startDateTime.year,
                startDateTime.month,
                startDateTime.day,
                startDateTime.hour,
                startDateTime.minute.toInt() + 1))) {
              playSound().then((s) => null);
            }

            return PrayerTimesCard(_primaryColor, key, start, end);
          }).toList(),
        )
            : Center(
          child: Text(
            'لا يوجد صلواة',
            style: TextStyle(
              fontSize: 28,
              color: _primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
