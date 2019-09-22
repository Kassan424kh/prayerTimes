import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/app_settings.dart';
import 'package:flutter_prayer_times/provider/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../prayer_times_data_from_server.dart';

// ignore: must_be_immutable
class PrayerTimesCard extends StatefulWidget {
  final primaryColor,
      primaryColorAccent,
      primaryName,
      start,
      end,
      active,
      index;

  PrayerTimesCard(this.primaryColor, this.primaryColorAccent, this.primaryName,
      this.start, this.end, this.active, this.index);

  @override
  _PrayerTimesCardState createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard> {
  int _cardStatus = 2;
  PrayerTimesDataFromServer prayerTimesDataFromServer =
      new PrayerTimesDataFromServer();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 2000), () {
      Provider.of<AppSettingsProvider>(context)
          .getAppSettings()
          .then((appSettings) {
        setState(() {
          List<dynamic> prayerStatus =
              appSettings["acceptPlayingAthans"][widget.index];
          if (prayerStatus[0] && prayerStatus[1])
            _cardStatus = 2;
          else if (!prayerStatus[0] && prayerStatus[1])
            _cardStatus = 1;
          else if (!prayerStatus[0] && !prayerStatus[1]) _cardStatus = 0;
        });
      });
    });
  }

  BorderRadius brContainer = BorderRadius.only(
      topLeft: Radius.circular(30),
      bottomLeft: Radius.circular(30),
      topRight: Radius.circular(30),
      bottomRight: Radius.circular(5));

  BorderRadius brElements = BorderRadius.all(Radius.circular(30));

  Widget prayerElement(displaySize) {
    // Card status
    IconData cs;
    if (_cardStatus == 2)
      cs = Icons.volume_up;
    else if (_cardStatus == 1)
      cs = Icons.vibration;
    else if (_cardStatus == 0) cs = Icons.alarm_off;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.transparent,
        borderRadius: brContainer,
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(5),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: widget.primaryColorAccent,
                        borderRadius: brElements,
                      ),
                      child: Row(children: <Widget>[
                        SizedBox(width: 30),
                        Text(
                          widget.start.substring(11, 16),
                          style: TextStyle(
                            fontSize: displaySize ? 20 : 30,
                            color: widget.primaryColor,
                          ),
                        ),
                        SizedBox(width: 30),
                        IconButton(
                            // disable if Sunrise/الشروق
                            onPressed: widget.index == 1
                                ? null
                                : () {
                                    Vibration.vibrate(duration: 50);
                                    AppSettings.isAppSettingsFileExists.then(
                                        (check) => check
                                            ? AppSettings
                                                .jsonFromAppSettingsFile
                                                .then((oldAppSettings) {
                                                //card status
                                                List<bool> _cs;
                                                if (_cardStatus == 2)
                                                  _cs = [false, true];
                                                else if (_cardStatus == 1)
                                                  _cs = [false, false];
                                                else if (_cardStatus == 0)
                                                  _cs = [true, true];

                                                oldAppSettings[
                                                        "acceptPlayingAthans"]
                                                    [widget.index] = _cs;
                                                AppSettings
                                                    .updateSettingsInAppSettingsJsonFile(
                                                        oldAppSettings);
                                                Provider.of<AppSettingsProvider>(
                                                        context)
                                                    .updateAppSettings(
                                                        oldAppSettings);

                                                prayerTimesDataFromServer
                                                    .updateTodayPrayerTimes
                                                    .then(((check) {
                                                  if (check)
                                                    print(
                                                        "Prayer Times reseted");
                                                  else
                                                    print(
                                                        "Prayer Times cann't reseted");
                                                }));
                                              })
                                            : null);
                                  },
                            icon:
                                Icon(widget.index == 1 ? Icons.alarm_off : cs)),
                        SizedBox(width: 30),
                      ]),
                    ),
                  ]),
                  Text(
                    widget.primaryName,
                    style: TextStyle(fontSize: 30, color: Colors.black54),
                  ),
                ]),
          ),
        ]),
      ),
    );
  }

  @override
  void didUpdateWidget(PrayerTimesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(const Duration(milliseconds: 2000), () {
      Provider.of<AppSettingsProvider>(context)
          .getAppSettings()
          .then((appSettings) {
        setState(() {
          List<dynamic> prayerStatus =
              appSettings["acceptPlayingAthans"][widget.index];
          if (prayerStatus[0] && prayerStatus[1])
            _cardStatus = 2;
          else if (!prayerStatus[0] && prayerStatus[1])
            _cardStatus = 1;
          else if (!prayerStatus[0] && !prayerStatus[1]) _cardStatus = 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool displaySize = MediaQuery.of(context).size.width <= 411;
    return widget.active
        ? prayerElement(displaySize)
        : Opacity(
            opacity: 0.5,
            child: prayerElement(displaySize),
          );
  }
}
