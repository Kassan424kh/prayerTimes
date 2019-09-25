import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/app_settings.dart';
import 'package:flutter_prayer_times/prayer_times_data_from_server.dart';
import 'package:flutter_prayer_times/provider/app_settings.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  final primaryColor, primaryColorAccent;

  BottomBar({Key key, this.primaryColor, this.primaryColorAccent})
      : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  double _volume = 0.10;
  List<String> _languages = [];
  String _selectedLanguages;
  PrayerTimesDataFromServer prayerTimesDataFromServer = PrayerTimesDataFromServer();

  @override
  initState() {
    super.initState();
  }

  Future<void> _volumeHandler(volume) async {
    AppSettings.jsonFromAppSettingsFile
        .then((Map<String, dynamic> oldSettings) {
      int decimals = 2;
      int fac = pow(10, decimals);
      volume = (volume * fac).round() / fac;
      oldSettings["alathanVolume"] = volume.toString();
      Provider.of<AppSettingsProvider>(context).updateAppSettings(oldSettings);
      AppSettings.updateSettingsInAppSettingsJsonFile(oldSettings)
          .then((isUpdated) {
        if (isUpdated) print("Alathan volume is updated");
      });
    });
  }

  Future<void> _selectedLangageHandler(String selectedLanguage) async {
    AppSettings.jsonFromAppSettingsFile
        .then((Map<String, dynamic> oldSettings) {
      oldSettings["languages"]["selected"] = selectedLanguage;
      Provider.of<AppSettingsProvider>(context).updateAppSettings(oldSettings);
      AppSettings.updateSettingsInAppSettingsJsonFile(oldSettings)
          .then((isUpdated) {
        setState(() =>
        _selectedLanguages = selectedLanguage);
        if (isUpdated) print("App language is updated");
        prayerTimesDataFromServer.updatePrayerTimesCompletely.then((isUpdated) => print("PrayerTimes ${isUpdated? "is": "isn't"} updated"));
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(const Duration(milliseconds: 3000), () {
      Provider.of<AppSettingsProvider>(context)
          .getAppSettings()
          .then((Map<String, dynamic> appSettings) async {
        if (appSettings != null ||
            appSettings["languages"]["names"].length == 0) {
          _selectedLanguages = appSettings["languages"]["selected"];
          _languages.clear();
          for (var key in await appSettings["languages"]["names"])
            _languages.add(key);
        }
      });
      Provider.of<AppSettingsProvider>(context)
          .getAppSettings()
          .then((appSettings) async {
        for (String key in await appSettings.keys)
          if (key == "alathanVolume")
            setState(() => _volume = double.parse(appSettings[key]));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 2,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: size.height <= 650 ? 5 : 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Colors.blue[100],
      ),
      child: Column(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(size.height <= 650 ? 10 : 20),
                  child: Text(
                    "© 2019 Khalil Khalil",
                    style: TextStyle(
                      color: widget.primaryColor,
                      fontSize: size.height <= 650
                          ? size.width <= 350.0 ? 11 : 13
                          : 20,
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(right: 15, top: 10),
                  width: size.height <= 650 ? 60 : 80,
                  child: RaisedButton(
                    color: widget.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Container(
                      width: size.height <= 650 ? 30 : 50,
                      height: size.height <= 650 ? 30 : 50,
                      child: Icon(
                        Icons.settings,
                        color: widget.primaryColorAccent,
                        size: size.width <= 350.0 ? 15 : 25,
                      ),
                    ),
                    onPressed: () {},
                  ))
            ]),
        Material(
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20),
              color: Colors.blue[100],
              child: ListTile(
                title: Text(
                  "Alathan volume",
                  style: TextStyle(
                    fontSize:
                        size.height <= 650 ? size.width <= 350.0 ? 11 : 13 : 17,
                  ),
                ),
                subtitle: Slider(
                  label: (_volume * 1000).toInt().toString(),
                  activeColor: widget.primaryColor,
                  inactiveColor: Colors.white,
                  value: _volume,
                  min: 0,
                  max: 0.10,
                  divisions: 10,
                  onChanged: (volume) {
                    setState(() => _volume = volume);
                  },
                  onChangeEnd: (volume) {
                    _volumeHandler(volume);
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              color: Colors.blue[100],
              child: ListTile(
                title: Text(
                  "App language",
                  style: TextStyle(
                    fontSize:
                        size.height <= 650 ? size.width <= 350.0 ? 11 : 13 : 17,
                  ),
                ),
                subtitle: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Container(
                      color: Colors.white54,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: _languages.length != 0 || _languages == null
                          ? DropdownButton(
                              value: _selectedLanguages,
                              isExpanded: true,
                              onChanged: (selectedLanguage) {
                                _selectedLangageHandler(selectedLanguage);
                              },
                              style: TextStyle(color: widget.primaryColor),
                              iconEnabledColor: widget.primaryColor,
                              icon: Icon(Icons.language),
                              underline: Container(),
                              items: _languages.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    child: Text(
                                      value,
                                      style:
                                          TextStyle(color: widget.primaryColor),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : Container(
                              child: Text(
                                "No language founded",
                                style: TextStyle(
                                  color: Colors.blue[100],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        )
      ]),
    );
  }
}
