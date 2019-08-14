import 'package:flutter/material.dart';

class FoundedPlaces with ChangeNotifier{
  List _places = [];
  FoundedPlaces(this._places);

  getFoundedPlaces() => _places;
  setFoundedPlaces(List places) {
    _places.clear();
    _places.addAll(places);
  }
  clearFoundedPlaces() => _places.clear();
}