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
  Color _primaryColor = Color(0xff2196f3); //Colors.deepPurpleAccent;
  Color _primaryColorAccent = Color(0xffe3f2fd); //Colors.deepPurpleAccent;
  DateTime now = DateTime.now();
  List _prayerTimes = null;
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  Future getPrayerTimesFromAPIServer() async {
    String url = 'https://prayer-times.vsyou.app/';
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
      print('[Error] faild connection to server $url');
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

  Widget prayerContainer() => _prayerTimes != null
      ? Expanded(
    flex: 8,
    child: ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        color: Colors.white,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: _prayerTimes.map((pt) {
            String key;
            String start;
            String end;
            bool active;
            pt.forEach((k, v) {
              if (k != 'active') {
                key = k.toString();
                start = v[0].toString();
                end = v[1].toString();
              } else if (k == 'active') {
                active = v;
              }
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

            return PrayerTimesCard(_primaryColor, _primaryColorAccent,
                key, start, end, active);
          }).toList(),
        ),
      ),
    ),
  )
      : Container(
    height: 200,
    child: Center(
      child: Text(
        'لا يوجد صلواة',
        style: TextStyle(
          fontSize: 28,
          color: _primaryColor,
        ),
      ),
    ),
  );

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
        body: Container(
          color: _primaryColorAccent,
          child: Column(children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: Text(now.toString().substring(11, 16),
                    style: TextStyle(color: _primaryColor, fontSize: 50)),
              ),
            ),
            prayerContainer()
          ]),
        ),
      ),
    );
  }
}
