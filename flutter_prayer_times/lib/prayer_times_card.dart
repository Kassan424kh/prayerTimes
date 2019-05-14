import 'package:flutter/material.dart';

class PrayerTimesCard extends StatelessWidget {
  final primaryColor, primaryColorAccent, primaryName, start, end, active;

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

  Widget prayerElement(displaySize) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          borderRadius: brContainer,
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                            EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: primaryColorAccent,
                          borderRadius: brElements,
                        ),
                        child: Row(children: <Widget>[
                          SizedBox(width: 30),
                          Text(
                            start.substring(11, 16),
                            style: TextStyle(
                              fontSize: displaySize ? 20 : 30,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(width: 30),
                          IconButton(
                              onPressed: primaryName == 'الشروق' ? null : () {},
                              icon: Icon(primaryName == 'الشروق'
                                  ? Icons.volume_off
                                  : Icons.volume_up)),
                          SizedBox(width: 30),
                        ]),
                      ),
                    ]),
                    Text(
                      primaryName,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ]),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    bool displaySize = MediaQuery.of(context).size.width <= 411;
    return active
        ? prayerElement(displaySize)
        : Opacity(
            opacity: 0.5,
            child: prayerElement(displaySize),
          );
  }
}
