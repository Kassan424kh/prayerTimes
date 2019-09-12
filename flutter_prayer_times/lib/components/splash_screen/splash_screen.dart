import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Color _primaryColor, _primaryColorAccent;

  SplashScreen(this._primaryColor, this._primaryColorAccent);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  BoxShadow _logoBoxShadow = BoxShadow(
    color: Colors.transparent,
    blurRadius: 0,
    offset: Offset(0, 0),
  );
  bool _showSplashScreen = true;
  double _splashScreenAnimatedOpacity = 1;
  double _logoAnimatedOpacity = 0;

  setTimeout(Duration duration, void doThis) {
    Future.delayed(duration, () {
      doThis;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _logoBoxShadow = BoxShadow(
          color: Colors.black12,
          blurRadius: 30,
          offset: Offset(0, 30),
        );
        _logoAnimatedOpacity = 1;
      });
    });
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        _splashScreenAnimatedOpacity = 0;
      });
    });
    Future.delayed(Duration(milliseconds: 3250), () {
      setState(() {
        _showSplashScreen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplashScreen
        ? Positioned(
            top: 0.0,
            left: 0.0,
            child: AnimatedOpacity(
              opacity: _splashScreenAnimatedOpacity,
              duration: Duration(milliseconds: 250),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: widget._primaryColor),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedOpacity(
                        opacity: _logoAnimatedOpacity,
                        duration: Duration(seconds: 1),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              boxShadow: <BoxShadow>[_logoBoxShadow]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 150,
                              height: 150,
                              child: Image.asset("assets/app_logo/logo.png"),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            "Al-Moathen",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: "Righteous",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
