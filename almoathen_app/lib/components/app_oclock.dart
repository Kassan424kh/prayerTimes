import 'package:flutter/material.dart';
import 'package:almoathen_app/components/place_search_component/place_search_banner.dart';
import 'package:almoathen_app/provider/app_styling.dart';
import 'package:provider/provider.dart';

class AppOclock extends StatelessWidget{
  final now;

  AppOclock({Key key, this.now}):super(key: key);


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appStyling = Provider.of<AppStyling>(context);
    return Flexible(
        flex: size.height <= 650 ? 4: 3,
        child: Column(children: <Widget>[
          PlaceSearchBanner(
            backgroundImageBlurEffect: appStyling.backgroundImageBlurEffect,
          ),
          SizedBox(height: size.height <= 650 ? 20: 20),
          Center(
            child: Text(
              now.toString().substring(11, 16),
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: size.height <= 650 ? size.width <= 350.0? 45: 60: 80,
                  shadows: <Shadow>[
                    Shadow(
                        color: Colors.black12,
                        offset: Offset(0, 5),
                        blurRadius: 50)
                  ]),
            ),
          ),
        ]));
  }
}