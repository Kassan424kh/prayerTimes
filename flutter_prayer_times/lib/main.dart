import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_prayer_times/components/app_oclock.dart';
import 'package:flutter_prayer_times/components/bottom_bar.dart';
import 'package:flutter_prayer_times/components/place_search_component/place_search_banner.dart';
import 'package:flutter_prayer_times/components/splash_screen/splash_screen.dart';
import 'package:flutter_prayer_times/provider/app_settings.dart';
import 'package:flutter_prayer_times/provider/founded_places.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

import 'package:flutter_prayer_times/components/prayer_time_cards/prayer_times_container.dart';
import 'package:flutter_prayer_times/app_settings.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

Future main() async => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with TickerProviderStateMixin {
  // variables
  Color _primaryColor = Color(0xff2196f3);
  Color _primaryColorAccent = Color(0xffe3f2fd);
  AssetImage _backgroundImage =
      AssetImage('assets/background_images/adrian-MBwvFtRqCcQ-unsplash.png');
  AssetImage _backgroundImageBlurEffect = AssetImage(
      'assets/background_images/adrian-MBwvFtRqCcQ-unsplash_blur_effect.png');
  DateTime _now = DateTime.now();

  Future<void> setData() async {
    DateTime dtNow = DateTime.now();
    setState(() {
      _now = DateTime(
          dtNow.year, dtNow.month, dtNow.day, dtNow.hour, dtNow.minute);
    });
  }

  // state functions
  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // keyboard done
    setData();
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setData();
    });

    AppSettings.writeDefaultAppSettingsToAppSettingsJsonFile.then((none) {
      AppSettings.jsonFromAppSettingsFile;
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  // build
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettingsProvider>(
            builder: (_) => AppSettingsProvider()),
        ChangeNotifierProvider<FoundedPlaces>(
            builder: (_) => FoundedPlaces([])),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: Stack(
          children: <Widget>[
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  color: _primaryColorAccent,
                  image: DecorationImage(
                    image: _backgroundImage,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                //color: _primaryColorAccent,
                child: Column(children: <Widget>[
                  AppOclock(
                    primaryColor: _primaryColor,
                    primaryColorAccent: _primaryColorAccent,
                    backgroundImageBlurEffect: _backgroundImageBlurEffect,
                    now: _now,
                  ),
                  PrayerTimesContainer(
                    _primaryColor,
                    _primaryColorAccent,
                    _backgroundImageBlurEffect,
                  ),
                ]),
              ),
            ),
            Positioned(
              child: BottomBar(
                  primaryColor: _primaryColor,
                  primaryColorAccent: _primaryColorAccent),
              bottom: 0,
              left: 0,
            ),
            SplashScreen(_primaryColor, _primaryColorAccent),
          ],
        ),
      ),
    );
  }
}
