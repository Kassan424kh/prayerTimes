import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/components/place_search_component/place_search_page.dart';
import 'package:flutter_prayer_times/provider/founded_places.dart';
import 'package:provider/provider.dart';

class PlaceSearchBanner extends StatelessWidget {
  final Color primaryColor, primaryColorAccent;

  const PlaceSearchBanner(
      {Key key,
      this.primaryColor = Colors.blue,
      this.primaryColorAccent = Colors.white})
      : super(key: key);

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
          padding: EdgeInsets.only(left: 25, right: 5, top: 5, bottom: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Prayer Times',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Container(
                  width: 61,
                  child: RaisedButton(
                    child: Icon(Icons.place, color: primaryColor, size: 30),
                    color: primaryColorAccent,
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
                          builder: (context) => ChangeNotifierProvider<FoundedPlaces>(
                            builder: (_) => FoundedPlaces([]),
                            child: PlaceSearchPage(
                              primaryColor: primaryColor,
                              primaryColorAccent: primaryColorAccent,
                            ),
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
