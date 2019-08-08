import 'package:flutter/material.dart';

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
      const Duration(milliseconds: 100),
      () {
        Navigator.pop(ctx);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: TextField(
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
                          contentPadding: EdgeInsets.all(18)),
                      style: TextStyle(fontSize: 20, color: primaryColor),
                      cursorColor: primaryColor,
                      onChanged: (text) {},
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: 61,
                    child: RaisedButton(
                        child: Icon(Icons.check, color: primaryColor, size: 30),
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
}
