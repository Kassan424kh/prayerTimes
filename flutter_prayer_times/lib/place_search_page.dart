import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/place_search_banner_field.dart';

class PlaceSearchPage extends StatelessWidget {
  final Color primaryColor, primaryColorAccent;

  PlaceSearchPage({Key key, this.primaryColor, this.primaryColorAccent})
      : super(key: key);

  @override
  Widget build(BuildContext buildContext) => Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: PlaceSearchBannerField(
            primaryColor: primaryColor,
            primaryColorAccent: primaryColorAccent,
          ),
        ),
      );
}
