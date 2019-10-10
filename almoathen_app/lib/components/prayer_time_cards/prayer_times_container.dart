import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:almoathen_app/app_settings.dart';

import 'package:almoathen_app/components/prayer_time_cards/prayer_times_card.dart';
import 'package:almoathen_app/prayer_times_data_from_server.dart';
import 'package:almoathen_app/provider/app_styling.dart';
import 'package:provider/provider.dart';

class PrayerTimesContainer extends StatefulWidget {
  _PrayerTimesContainer createState() => _PrayerTimesContainer();
}

class _PrayerTimesContainer extends State<PrayerTimesContainer> {
  List _prayerTimes;
  var _now;
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
          bool active = false;
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
              index, PrayerTimesCard(key, start, end, active, index));
        })
        .values
        .toList();
  }

  Widget prayerContainer() {
    final size = MediaQuery.of(context).size;
    final appStyling = Provider.of<AppStyling>(context);
    return _prayerTimes != null
        ? Expanded(
            flex: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(appStyling.primaryRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(appStyling.primaryRadius),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(appStyling.primaryRadius),
                  ),
                  child: Stack(fit: StackFit.passthrough, children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: size.height,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(appStyling.primaryRadius),
                          image: DecorationImage(
                            image: appStyling.backgroundImageBlurEffect,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await _prayerTimesDataFromServer
                            .updatePrayerTimesCompletely;
                      },
                      child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            ...prayerTimesList(),
                            SizedBox(height: size.height <= 650 ? 73 : 85)
                          ]),
                    ),
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
                  color: appStyling.primaryColor,
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
    setData();
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setData();
    });
  }

  @override
  Widget build(BuildContext context) => prayerContainer();
}
