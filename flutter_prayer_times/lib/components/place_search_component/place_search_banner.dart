import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/components/place_search_component/place_search_page.dart';
import 'package:flutter_prayer_times/provider/app_settings.dart';
import 'package:provider/provider.dart';

class PlaceSearchBanner extends StatefulWidget {
  final Color primaryColor, primaryColorAccent;

  const PlaceSearchBanner(
      {Key key,
      this.primaryColor = Colors.blue,
      this.primaryColorAccent = Colors.white})
      : super(key: key);

  @override
  _PlaceSearchBannerState createState() => _PlaceSearchBannerState();
}

class _PlaceSearchBannerState extends State<PlaceSearchBanner> {
  String placeName = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 2000), () {
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
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Colors.white,
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
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: FlareActor(
                      "assets/app_logo/PrayerTimesAnimatedLogo.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "activate",
                    ),
                  ),
                ),
                Container(
                  width: placeName == "" ? 61 : null,
                  height: 61,
                  child: RaisedButton(
                    child: Row(children: <Widget>[
                      if (placeName.length > 0) SizedBox(width: 10),
                      if (placeName.length > 0)
                        Text(
                          placeName,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 20,
                            color: widget.primaryColor,
                          ),
                        ),
                      if (placeName.length > 0) SizedBox(width: 10),
                      Icon(Icons.place, color: widget.primaryColor, size: 30)
                    ]),
                    color: widget.primaryColorAccent,
                    splashColor: Colors.blue[100],
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
                          builder: (context) => PlaceSearchPage(
                            primaryColor: widget.primaryColor,
                            primaryColorAccent: widget.primaryColorAccent,
                          ),
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
