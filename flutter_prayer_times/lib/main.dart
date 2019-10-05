import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_prayer_times/components/home.dart';
import 'package:flutter_prayer_times/provider/app_settings.dart';
import 'package:flutter_prayer_times/provider/app_styling.dart';
import 'package:flutter_prayer_times/provider/founded_places.dart';
import 'package:provider/provider.dart';
import 'package:flutter_prayer_times/app_settings.dart';

Future main() async => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with TickerProviderStateMixin {
  // variables
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
        ChangeNotifierProvider<AppStyling>(
          builder: (_) => AppStyling(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: Home(_now),
      ),
    );
  }
}
