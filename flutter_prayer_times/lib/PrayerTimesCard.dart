import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class PrayerTimesCard extends StatelessWidget {
  final primaryColor;
  final primaryName;
  final start;
  final end;

  PrayerTimesCard(this.primaryColor, this.primaryName, this.start, this.end);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: primaryColor,
              blurRadius: 40,
              spreadRadius: -30,
              offset: Offset(0, 20))
        ],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        child: Column(children: <Widget>[
          Card(
            clipBehavior: Clip.hardEdge,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Container(
              height: 400,
              color: primaryColor,
              child: null,
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(children: <Widget>[
                    Text(
                      start.substring(11, 16),
                      style: TextStyle(
                        fontSize: 28,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(start.substring(0, 10)),
                    SizedBox(height: 10),
                    Text(
                      end.substring(11, 16),
                      style: TextStyle(
                        fontSize: 28,
                        color: primaryColor,
                      ),
                    ),
                  ]),
                  Text(
                    primaryName,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ]),
          ),
        ]),
      ),
    );
  }
}
