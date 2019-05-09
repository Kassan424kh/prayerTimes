import 'dart:async';
import 'dart:ui';
import 'dart:convert' as json;

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;

import 'prayer_times_card.dart';

class PrayerTimesContainer extends StatefulWidget {
  final primaryColor, primaryColorAccent, backgroundImage;

  PrayerTimesContainer(
      this.primaryColor, this.primaryColorAccent, this.backgroundImage);

  _PrayerTimesContainer createState() => _PrayerTimesContainer();
}

class _PrayerTimesContainer extends State<PrayerTimesContainer> {
  List _prayerTimes = null;
  var _now, _primaryColor, _primaryColorAccent, _backgroundImage;
  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  Future playSound() async {
    await _assetsAudioPlayer.open(AssetsAudio(
      asset: "33432.mp3",
      folder: "assets/audios/",
    ));
  }

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

  List<Widget> prayerTimesList() {
    return _prayerTimes.map((pt) {
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

      if (_now.isAtSameMomentAs(DateTime(
              startDateTime.year,
              startDateTime.month,
              startDateTime.day,
              startDateTime.hour,
              startDateTime.minute.toInt())) &&
          key != 'الشروق') {
        playSound().then((s) => null);
      }

      return PrayerTimesCard(
          _primaryColor, _primaryColorAccent, key, start, end, active);
    }).toList();
  }

  Widget prayerContainer() => _prayerTimes != null
      ? Expanded(
          flex: 8,
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _backgroundImage,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black26,
                    BlendMode.darken,
                  ),
                ),
                color: Colors.black54,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child:
                    ListView(scrollDirection: Axis.vertical, children: <Widget>[
                  ...prayerTimesList(),
                ]),
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

  Future<void> setData() async {
    getPrayerTimesFromAPIServer();
    DateTime dtNow = DateTime.now();
    setState(() {
      _now = DateTime(
          dtNow.year, dtNow.month, dtNow.day, dtNow.hour, dtNow.minute);
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {
      _primaryColor = widget.primaryColor;
      _primaryColorAccent = widget.primaryColorAccent;
      _backgroundImage = widget.backgroundImage;
    });
    setData();
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      setData();
    });
  }

  @override
  Widget build(BuildContext context) => prayerContainer();
}
