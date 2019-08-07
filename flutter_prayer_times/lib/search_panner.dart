import 'package:flutter/material.dart';

class SearchPanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          color: Colors.blue[50],
        ),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(left: 25, right: 5, top: 5, bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Your Place:',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontStyle: FontStyle.italic)),
                  Container(
                    width: 61,
                    child: RaisedButton(
                      child: Icon(Icons.place, color: Colors.blue, size: 30),
                      color: Colors.blue[100],
                      padding: EdgeInsets.all(15),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ]),
          ),
        ),
      );
}
