import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

import './prayer_times_container.dart';

Future main() async => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with TickerProviderStateMixin {
  // variables
  Color _primaryColor = Color(0xff2196f3); //Colors.deepPurpleAccent;
  Color _primaryColorAccent = Color(0xffe3f2fd); //Colors.deepPurpleAccent;
  AssetImage _backgroundImage =
      AssetImage('assets/background_images/285563.jpg');
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
    Screen.keepOn(true);
    setData();
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setData();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: _primaryColorAccent,
            image: DecorationImage(
              image: _backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          //color: _primaryColorAccent,
          child: Column(children: <Widget>[
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  _now.toString().substring(11, 16),
                  style: TextStyle(color: _primaryColor, fontSize: 50),
                ),
              ),
            ),
            PrayerTimesContainer(
                _primaryColor, _primaryColorAccent, _backgroundImage)
          ]),
        ),
      ),
    );
  }
}
