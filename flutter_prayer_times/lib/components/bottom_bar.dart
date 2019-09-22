import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final primaryColor, primaryColorAccent;

  BottomBar({Key key, this.primaryColor, this.primaryColorAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height <= 650 ? 50: 70,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: size.height <= 650 ? 5: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: Colors.blue[100],
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(size.height <= 650 ? 10: 20),
                child: Text(
                  "© 2019 Khalil Khalil",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: size.height <= 650 ? size.width <= 350.0 ?11 : 13: 20,
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(right: 10),
                width: size.height <= 650 ? 60: 80,
                child: RaisedButton(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Container(
                    width: size.height <= 650 ? 30: 50,
                    height: size.height <= 650 ? 30: 50,
                    child: Icon(
                      Icons.settings,
                      color: primaryColorAccent,
                      size: size.width <= 350.0 ?15 : 20,
                    ),
                  ),
                  onPressed: () {},
                ))
          ]),
    );
  }
}
