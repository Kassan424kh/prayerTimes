import 'package:flutter/material.dart';
import 'package:flutter_prayer_times/provider/app_styling.dart';
import 'package:flutter_prayer_times/provider/founded_places.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

class PlaceSearchBannerField extends StatelessWidget {

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
    final size = MediaQuery.of(context).size;
    final foundedPlaces = Provider.of<FoundedPlaces>(context);
    final appStyling = Provider.of<AppStyling>(context);
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          color: appStyling.primaryColorAccent,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(size.width <= 350.0 ? 2 : 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 61,
                    child: RaisedButton(
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        color: appStyling.primaryColor,
                        size: size.width <= 350.0 ? 15 : 25,
                      ),
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
                          hintStyle: TextStyle(
                              color: Colors.blue[200],
                              fontSize: size.width <= 350.0 ? 12 : null),
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
                          contentPadding:
                              EdgeInsets.all(size.width <= 350.0 ? 10 : 18),
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
                        child: Icon(
                          Icons.gps_fixed,
                          color: appStyling.primaryColor,
                          size: size.width <= 350.0 ? 15 : 25,
                        ),
                        color: appStyling.primaryColorAccent,
                        splashColor: appStyling.primaryColorWhite,
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