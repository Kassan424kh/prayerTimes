import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/provider/founded_places.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

class PlaceSearchBannerField extends StatelessWidget {
  final Color primaryColor, primaryColorAccent;

  const PlaceSearchBannerField(
      {Key key,
      this.primaryColor = Colors.blue,
      this.primaryColorAccent = Colors.white})
      : super(key: key);

  Future closeKeyboard(ctx) async {
    FocusScope.of(ctx).requestFocus(new FocusNode());
    return Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.pop(ctx);
      },
    );
  }

  final String _apiKey =
      "pk.eyJ1Ijoia2Fzc2FuNDI0a2giLCJhIjoiY2pxMmI4NHJxMTA4NzN4cDMxYW1md2x4MiJ9" +
          ".-IuNyxk89rjHrd8_qxBirw&limit";

  @override
  Widget build(BuildContext context) {
    final foundedPlaces = Provider.of<FoundedPlaces>(context);
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          color: primaryColorAccent,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 61,
                    child: RaisedButton(
                      child: Icon(Icons.keyboard_arrow_left,
                          color: primaryColor, size: 30),
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
                        closeKeyboard(context);
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Search after Place ... ',
                          hintStyle: TextStyle(color: Colors.blue[200]),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                      suggestionsCallback: (items) async {
                        viewLatLogFromSearchedPlaceApi(items, foundedPlaces);
                        return [];
                      },
                      hideOnEmpty: true,
                      itemBuilder: (ctx, s) {},
                      onSuggestionSelected: (s) {},
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 61,
                    child: RaisedButton(
                        child: Icon(Icons.gps_fixed, color: primaryColor, size: 30),
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
                        onPressed: () {}),
                  ),
                ]),
          ),
        ),
      ),
    ]);
  }

  Future<List> viewLatLogFromSearchedPlaceApi(s, fp) async {
    var url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$s.json?access_token=$_apiKey=1";
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        List placesList = jsonResponse['features'];
        fp.setFoundedPlaces(placesList);
        return placesList;
      } else {
        print("Request failed with status: ${response.statusCode}.");
        fp.clearFoundedPlaces();
        return [];
      }
    } catch (e) {
      print("cann't connect to server");
      fp.clearFoundedPlaces();
      return [];
    }
  }
}
