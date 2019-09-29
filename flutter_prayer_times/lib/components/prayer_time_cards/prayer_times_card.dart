import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/app_settings.dart';
import 'package:flutter_prayer_times/provider/app_settings.dart';
import 'package:flutter_prayer_times/provider/app_styling.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../prayer_times_data_from_server.dart';

// ignore: must_be_immutable
class PrayerTimesCard extends StatefulWidget {
  final primaryName, start, end, active, index;

  PrayerTimesCard(
    this.primaryName,
    this.start,
    this.end,
    this.active,
    this.index,
  );

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
    Future.delayed(const Duration(milliseconds: 1000), () {
      Provider.of<AppSettingsProvider>(context)
          .getAppSettings()
          .then((appSettings) {
        String selectedLanguage = appSettings["languages"]["selected"];
        if (appSettings["languages"]["isRtl"] != null)
          for (var isThisLangRtl in appSettings["languages"]["isRtl"])
            for (var key in isThisLangRtl.keys)
              if (key == selectedLanguage)
                Provider.of<AppStyling>(context)
                    .setTextDirection(isThisLangRtl[key]);

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

  Widget prayerElement(displaySize) {
    // Card status
    IconData cs;
    if (_cardStatus == 2)
      cs = Icons.volume_up;
    else if (_cardStatus == 1)
      cs = Icons.vibration;
    else if (_cardStatus == 0) cs = Icons.alarm_off;

    final size = MediaQuery.of(context).size;
    final appStyling = Provider.of<AppStyling>(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.transparent,
        borderRadius: BorderRadius.all(appStyling.primaryRadiusMinus10),
      ),
      margin: EdgeInsets.all(0),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(0),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Row(
                textDirection: Provider.of<AppStyling>(context).isRtl
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: size.width <= 350.0 ? 20 : 25,
                          horizontal: size.width <= 350.0 ? 10 : 15),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: appStyling.primaryColorWhite,
                        borderRadius:
                            BorderRadius.all(appStyling.primaryRadiusMinus10),
                      ),
                      child: Row(
                          textDirection: Provider.of<AppStyling>(context).isRtl
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          children: <Widget>[
                            SizedBox(width: size.width <= 350.0 ? 20 : 30),
                            Text(
                              widget.start.substring(11, 16),
                              style: TextStyle(
                                fontSize: displaySize
                                    ? size.width <= 350.0 ? 15 : 20
                                    : 30,
                                color: appStyling.primaryColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                                // disable if Sunrise/الشروق
                                onPressed: widget.index == 1
                                    ? null
                                    : () {
                                        Vibration.vibrate(duration: 50);
                                        AppSettings.isAppSettingsFileExists
                                            .then((check) => check
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
                                icon: Icon(
                                    widget.index == 1 ? Icons.alarm_off : cs)),
                            SizedBox(width: 10),
                          ]),
                    ),
                  ]),
                  Text(
                    widget.primaryName,
                    style: TextStyle(
                        fontSize: size.width <= 350.0 ? 20 : 30,
                        color: Colors.black54),
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
        String selectedLanguage = appSettings["languages"]["selected"];
        if (appSettings["languages"]["isRtl"] != null)
          for (var isThisLangRtl in appSettings["languages"]["isRtl"])
            for (var key in isThisLangRtl.keys)
              if (key == selectedLanguage)
                Provider.of<AppStyling>(context)
                    .setTextDirection(isThisLangRtl[key]);

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
