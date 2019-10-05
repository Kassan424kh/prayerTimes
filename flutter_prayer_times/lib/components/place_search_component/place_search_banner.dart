import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/components/place_search_component/place_search_page.dart';
import 'package:flutter_prayer_times/provider/app_settings.dart';
import 'package:flutter_prayer_times/provider/app_styling.dart';
import 'package:provider/provider.dart';

class PlaceSearchBanner extends StatefulWidget {
  final AssetImage backgroundImageBlurEffect;

  const PlaceSearchBanner(
      {Key key,
      this.backgroundImageBlurEffect})
      : super(key: key);

  @override
  _PlaceSearchBannerState createState() => _PlaceSearchBannerState();
}

class _PlaceSearchBannerState extends State<PlaceSearchBanner> {
  String placeName = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 3000), () {
      Provider.of<AppSettingsProvider>(context).getAppSettings().then((s) {
        Map<String, dynamic> appSettingsObject = s;
        String place = appSettingsObject != null
            ? appSettingsObject["place"]["place"]
            : "";
        String placeN = place.length != 0
            ? place.length > 15 ? place.substring(0, 15) + "..." : place
            : "No selected place";
        setState(() {
          placeName = placeN;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appStyling = Provider.of<AppStyling>(context);
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: appStyling.primaryColor,
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 10), blurRadius: 30)
        ],
        borderRadius: BorderRadius.all(
          Provider.of<AppStyling>(context).primaryRadius50,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                      width: size.width <= 350.0? 50:62,
                      height: size.width <= 350.0? 50:62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Image.asset("assets/app_logo/mosque_3d.png")),
                ),
                Container(
                  width: placeName == "" ? 61 : null,
                  height: size.width <= 350.0? 50:61,
                  child: RaisedButton(
                    child: Row(children: <Widget>[
                      if (placeName.length > 0) SizedBox(width: 10),
                      if (placeName.length > 0)
                        Text(
                          placeName,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: size.width <= 350.0? 12:20,
                            color: appStyling.primaryTextColor,
                          ),
                        ),
                      if (placeName.length > 0) SizedBox(width: 10),
                      Icon(Icons.place, color: appStyling.primaryTextColor, size: size.width <= 350.0 ? 15 : 25)
                    ]),
                    color: appStyling.primaryColorAccent,
                    splashColor: appStyling.primaryColorAccent,
                    highlightColor: Colors.white10,
                    highlightElevation: 0,
                    padding: EdgeInsets.all(15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceSearchPage(),
                        ),
                      );
                    },
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
