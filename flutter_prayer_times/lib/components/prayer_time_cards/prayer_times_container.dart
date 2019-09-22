import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/app_settings.dart';

import 'package:flutter_prayer_times/components/prayer_time_cards/prayer_times_card.dart';
import 'package:flutter_prayer_times/prayer_times_data_from_server.dart';

class PrayerTimesContainer extends StatefulWidget {
  final primaryColor, primaryColorAccent, backgroundImageBlurEffect;

  PrayerTimesContainer(this.primaryColor, this.primaryColorAccent,
      this.backgroundImageBlurEffect);

  _PrayerTimesContainer createState() => _PrayerTimesContainer();
}

class _PrayerTimesContainer extends State<PrayerTimesContainer> {
  List _prayerTimes;
  var _now, _primaryColor, _primaryColorAccent;
  PrayerTimesDataFromServer _prayerTimesDataFromServer =
      PrayerTimesDataFromServer();
  ScrollController _scrollController;
  int indexOfActivePrayer = 0;
  GlobalKey key;

  List<Widget> prayerTimesList() {
    return _prayerTimes
        .asMap()
        .map((index, pt) {
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

          if (active) {
            setState(() {
              indexOfActivePrayer = index;
            });
          }

          return MapEntry(
              index,
              PrayerTimesCard(_primaryColor, _primaryColorAccent, key, start,
                  end, active, index));
        })
        .values
        .toList();
  }

  Widget prayerContainer() {
    final size = MediaQuery.of(context).size;
    return _prayerTimes != null
      ? Expanded(
          flex: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  image: DecorationImage(
                      image: widget.backgroundImageBlurEffect,
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomLeft),
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _prayerTimesDataFromServer
                        .updatePrayerTimesAfterNewPlaceData;
                  },
                  child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        ...prayerTimesList(),
                        SizedBox(height: size.height <= 650 ? 60: 85)
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
  }

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
    });
    setData();
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setData();
    });
  }

  @override
  Widget build(BuildContext context) => prayerContainer();
}
