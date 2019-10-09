import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:almoathen_app/app_settings.dart';
import 'package:almoathen_app/prayer_times_data_from_server.dart';
import 'package:almoathen_app/provider/app_settings.dart';
import 'package:almoathen_app/provider/app_styling.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  PrayerTimesDataFromServer prayerTimesDataFromServer =
      PrayerTimesDataFromServer();
  bool _themeStatus = false;

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
        setState(() => _selectedLanguages = selectedLanguage);
        if (isUpdated) print("App language is updated");
        prayerTimesDataFromServer.updatePrayerTimesCompletely.then(
            (isUpdated) =>
                print("PrayerTimes ${isUpdated ? "is" : "isn't"} updated"));
      });
    });
  }

  Future<void> _themeStatusHandler(bool themeStatus) async {
    AppSettings.jsonFromAppSettingsFile
        .then((Map<String, dynamic> oldSettings) {
      oldSettings["themeStatus"]["isDark"] = themeStatus;
      Provider.of<AppSettingsProvider>(context).updateAppSettings(oldSettings);
      AppSettings.updateSettingsInAppSettingsJsonFile(oldSettings)
          .then((isUpdated) {
        if (isUpdated) print("App theme is updated");
        prayerTimesDataFromServer.updatePrayerTimesCompletely.then(
            (isUpdated) =>
                print("App theme ${isUpdated ? "is" : "isn't"} updated"));
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
        setState(() {
          _volume = double.parse(appSettings["alathanVolume"]);
          _themeStatus = appSettings["themeStatus"]["isDark"];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appStyling = Provider.of<AppStyling>(context);
    return Container(
      key: widget.key,
      width: size.width,
      margin: EdgeInsets.only(top: size.height <= 650 ? 5 : 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(appStyling.primaryRadius),
        color: appStyling.primaryColorAccent,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 5),
                  padding: EdgeInsets.all(size.height <= 650 ? 10 : 20),
                  child: Text(
                    "© 2019 Khalil Khalil",
                    style: TextStyle(
                      color: appStyling.primaryTextColor,
                      fontSize: size.height <= 650
                          ? size.width <= 350.0 ? 11 : 13
                          : 20,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 15, top: 5),
                width: size.height <= 650 ? 60 : 80,
                child: RaisedButton(
                  color: appStyling.primaryColorAccent,
                  highlightElevation: 0,
                  focusElevation: 0,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  elevation: 0,
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
                      color: appStyling.primaryTextColor,
                      size: size.width <= 350.0 ? 15 : 25,
                    ),
                  ),
                  onPressed: () {},
                ),
              )
            ]),
        Material(
          child: Container(
            constraints: BoxConstraints(minWidth: 230.0, minHeight: 25.0),
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20),
                color: appStyling.primaryColorAccent,
                child: ListTile(
                  title: ListTileTitle("Alathan volume"),
                  subtitle: Slider(
                    label: (_volume * 1000).toInt().toString(),
                    activeColor: appStyling.primaryTextColor,
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
                color: appStyling.primaryColorAccent,
                child: ListTile(
                  title: ListTileTitle("App language"),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: Container(
                        color: appStyling.primaryTextColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: _languages.length != 0 || _languages != null
                            ? DropdownButton(
                                value: _selectedLanguages,
                                isExpanded: true,
                                onChanged: (selectedLanguage) {
                                  _selectedLangageHandler(selectedLanguage);
                                },
                                style:
                                    TextStyle(color: appStyling.primaryColor),
                                iconEnabledColor: appStyling.primaryColor,
                                icon: Icon(Icons.language),
                                underline: Container(),
                                items: _languages.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: appStyling.themeStatusIsDark
                                                ? appStyling.primaryColor
                                                : appStyling
                                                    .primaryColorAccent),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : Container(
                                child: Text(
                                  "No language founded",
                                  style: TextStyle(
                                    color: appStyling.primaryColorAccent,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                color: appStyling.primaryColorAccent,
                child: ListTile(
                  title: ListTileTitle("Darkmode"),
                  trailing: Switch(
                    value: _themeStatus,
                    onChanged: (themeStatus) {
                      setState(() {
                        _themeStatus = themeStatus;
                        appStyling.setTheme(themeStatus);
                        _themeStatusHandler(themeStatus);
                      });
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 25),
                color: appStyling.primaryColorAccent,
                child: ListTile(
                    title: ListTileTitle("Rights"),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        BtnUrlInBrowserLauncher(
                            text: "T & C",
                            url:
                                "http://prayer-times.vsyou.app/terms-and-conditions"),
                        BtnUrlInBrowserLauncher(
                            text: "Privacy Policy",
                            url: "http://prayer-times.vsyou.app/privacy-policy")
                      ],
                    )),
              )
            ]),
          ),
        ),
      ]),
    );
  }
}

class ListTileTitle extends StatelessWidget {
  final _title;

  ListTileTitle(this._title);

  @override
  Widget build(BuildContext context) {
    final appStyling = Provider.of<AppStyling>(context);
    final size = MediaQuery.of(context).size;
    return Text(
      _title,
      style: TextStyle(
        color: appStyling.primaryTextColor,
        fontSize: size.height <= 650 ? size.width <= 350.0 ? 11 : 13 : 17,
      ),
    );
  }
}

class BtnUrlInBrowserLauncher extends StatelessWidget {
  final text, url;

  BtnUrlInBrowserLauncher({Key key, this.text, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appStyling = Provider.of<AppStyling>(context);
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(appStyling.primaryRadius),
        child: Container(
          color: appStyling.primaryTextColor,
          child: RaisedButton(
            color: appStyling.primaryTextColor,
            elevation: 0,
            onPressed: () async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Row(
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                      color: appStyling.themeStatusIsDark
                          ? appStyling.primaryColor
                          : appStyling.primaryColorAccent),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.open_in_new,
                  color: appStyling.themeStatusIsDark
                      ? appStyling.primaryColor
                      : appStyling.primaryColorAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
