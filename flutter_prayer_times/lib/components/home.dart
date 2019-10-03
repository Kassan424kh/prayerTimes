import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/components/app_oclock.dart';
import 'package:flutter_prayer_times/components/bottom_bar.dart';
import 'package:flutter_prayer_times/components/prayer_time_cards/prayer_times_container.dart';
import 'package:flutter_prayer_times/components/splash_screen/splash_screen.dart';
import 'package:flutter_prayer_times/provider/app_styling.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatelessWidget {
  final _now;

  Home(this._now);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appStyling = Provider.of<AppStyling>(context);
    return Stack(children: <Widget>[
      Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: appStyling.primaryColor,
            image: DecorationImage(
              image: appStyling.backgroundImage,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(appStyling.primaryRadius),
          ),
          //color: _primaryColorAccent,
          child: Column(children: <Widget>[
            AppOclock(now: _now),
            PrayerTimesContainer(),
          ]),
        ),
      ),
      ClipRRect(
        borderRadius: BorderRadius.all(appStyling.primaryRadius),
        child: SlidingUpPanel(
          maxHeight: 500,
          backdropEnabled: true,
          color: Colors.transparent,
          backdropColor: Colors.transparent,
          border: Border.all(color: Colors.transparent, width: 0),
          boxShadow: [BoxShadow(color: Colors.transparent)],
          borderRadius: BorderRadius.all(appStyling.primaryRadius),
          minHeight: size.height <= 650 ? 63 : 83,
          panel: BottomBar(),
        ),
      ),
      SplashScreen(),
    ]);
  }
}