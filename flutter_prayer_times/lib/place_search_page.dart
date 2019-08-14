import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/place_search_banner_field.dart';
import 'package:flutter_prayer_times/provider/founded_places.dart';

import 'package:provider/provider.dart';

class PlaceSearchPage extends StatefulWidget {
  final Color primaryColor, primaryColorAccent;

  PlaceSearchPage({Key key, this.primaryColor, this.primaryColorAccent})
      : super(key: key);

  @override
  _PlaceSearchPageState createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final foundedPlaces = Provider.of<FoundedPlaces>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(children: <Widget>[
          PlaceSearchBannerField(
            primaryColor: widget.primaryColor,
            primaryColorAccent: widget.primaryColorAccent,
          ),
          SizedBox(height: 30),
          foundedPlaces.getFoundedPlaces().length != 0
              ? Column(
                  children: foundedPlaces.getFoundedPlaces().map<Widget>((e) {
                  return ListTile(
                    onTap: () => print(e['place_name']),
                    leading: Icon(Icons.place),
                    title: Text(e['place_name']),
                    subtitle: Text(
                        '${"Lng: " + e['center'][0].toString() + " -- " + "Lat: " + e['center'][1].toString()}'),
                  );
                }).toList())
              : Center( child: Text('No searched places'))
        ]),
      ),
    );
  }
}
