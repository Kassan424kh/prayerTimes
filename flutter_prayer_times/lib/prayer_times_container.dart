import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'prayer_times_card.dart';
import 'prayer_times_data_from_server.dart';

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
  PrayerTimesDataFromServer _prayerTimesDataFromServer =
      PrayerTimesDataFromServer();
  GlobalKey key;

  Future playSound() async {
    await _assetsAudioPlayer.open(AssetsAudio(
      asset: "33432.mp3",
      folder: "assets/audios/",
    ));
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
              startDateTime.minute.toInt() - 1)) &&
          (startDateTime.second >= 0 || startDateTime.second < 2) &&
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
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black54,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
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
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        ...prayerTimesList(),
                      ]),
                ),
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
    _prayerTimesDataFromServer
        .getPrayerTimes()
        .then((List data) => setState(() => _prayerTimes = data));
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
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setData();
    });
  }

  @override
  Widget build(BuildContext context) => prayerContainer();
}
