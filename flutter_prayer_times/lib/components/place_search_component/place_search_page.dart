import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/components/place_search_component/place_search_banner_field.dart';
import 'package:flutter_prayer_times/prayer_times_data_from_server.dart';
import 'package:flutter_prayer_times/provider/app_settings.dart';
import 'package:flutter_prayer_times/provider/founded_places.dart';

import 'package:provider/provider.dart';

import '../../app_settings.dart';

class PlaceSearchPage extends StatefulWidget {
  final Color primaryColor, primaryColorAccent;

  PlaceSearchPage({Key key, this.primaryColor, this.primaryColorAccent})
      : super(key: key);

  @override
  _PlaceSearchPageState createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  PrayerTimesDataFromServer prayerTimesDataFromServer =
      new PrayerTimesDataFromServer();

  Future closeKeyboard(ctx) async {
    FocusScope.of(ctx).requestFocus(new FocusNode());
    return Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.pop(ctx);
      },
    );
  }

  Future<void> _tapHandling(e) async {
    AppSettings.jsonFromAppSettingsFile
        .then((Map<String, dynamic> oldSettings) {
      oldSettings["place"]["lng"] = e['center'][0].toString();
      oldSettings["place"]["lat"] = e['center'][1].toString();
      oldSettings["place"]["place"] = e['place_name'];
      Provider.of<AppSettingsProvider>(context).updateAppSettings(oldSettings);
      AppSettings
          .updateSettingsInAppSettingsJsonFile(oldSettings)
          .then((isUpdated) {
        if (isUpdated)
          prayerTimesDataFromServer
              .updatePrayerTimesCompletely
              .then((result) {
            if (result)
              Timer(
                  const Duration(milliseconds: 200), () {
                prayerTimesDataFromServer
                    .updateTodayPrayerTimes
                    .then((result) {
                  if (result)
                    closeKeyboard(context);
                  else
                    print("PrayerTimes cann't updated");
                });
              });
          });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final foundedPlaces = Provider.of<FoundedPlaces>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(children: <Widget>[
          PlaceSearchBannerField(
            primaryColor: widget.primaryColor,
            primaryColorAccent: widget.primaryColorAccent,
          ),
          SizedBox(height: 30),
          foundedPlaces.getFoundedPlaces().length != 0
              ? Column(
                  children: foundedPlaces.getFoundedPlaces().map<Widget>((e) {
                  return ListTile(
                    onTap: () async {
                      _tapHandling(e);
                    },
                    leading: Icon(Icons.place),
                    title: Text(e['place_name']),
                    subtitle: Text(
                        '${"Lng: " + e['center'][0].toString() + " -- " + "Lat: " + e['center'][1].toString()}'),
                  );
                }).toList())
              : Center(child: Text('No searched places'))
        ]),
      ),
    );
  }
}
