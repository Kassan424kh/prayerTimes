import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PrayerTimesCard extends StatelessWidget {
  final primaryColor;
  final primaryColorAccent;
  final primaryName;
  final start;
  final end;
  final active;

  BorderRadius brContainer = BorderRadius.only(
      topLeft: Radius.circular(30),
      bottomLeft: Radius.circular(30),
      topRight: Radius.circular(30),
      bottomRight: Radius.circular(5));
  BorderRadius brElements = BorderRadius.only(
      topLeft: Radius.circular(25),
      bottomLeft: Radius.circular(25),
      topRight: Radius.circular(25),
      bottomRight: Radius.circular(5));

  PrayerTimesCard(this.primaryColor, this.primaryColorAccent, this.primaryName,
      this.start, this.end, this.active);

  Widget prayerElement() => Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: brContainer,
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(5),
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                        decoration: BoxDecoration(
                            color: primaryColorAccent,
                            borderRadius: brElements),
                        child: Row(children: <Widget>[
                          Text(
                            start.substring(11, 16),
                            style: TextStyle(
                              fontSize: 25,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.keyboard_arrow_right, color: primaryColor),
                          SizedBox(width: 10),
                          Text(
                            end.substring(11, 16),
                            style: TextStyle(
                              fontSize: 25,
                              color: primaryColor,
                            ),
                          ),
                        ]),
                      ),
                    ]),
                    Text(
                      primaryName,
                      style: TextStyle(fontSize: 30, color: primaryColor),
                    ),
                  ]),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return active
        ? prayerElement()
        : Opacity(
            opacity: 0.3,
            child: prayerElement(),
          );
  }
}
