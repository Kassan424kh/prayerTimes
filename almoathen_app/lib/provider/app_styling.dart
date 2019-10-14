import 'package:flutter/material.dart';

class AppStyling with ChangeNotifier{

  AssetImage backgroundImage =
  AssetImage('assets/background_images/adrian-MBwvFtRqCcQ-unsplash.png');
  AssetImage backgroundImageBlurEffect = AssetImage(
      'assets/background_images/adrian-MBwvFtRqCcQ-unsplash_blur_effect.png');

  static bool isDark = false;

  bool get themeStatusIsDark {
    return isDark;
  }

  Radius primaryRadius50 = Radius.circular(50);
  Radius primaryRadius = Radius.circular(30);
  Radius primaryRadiusMinus10 = Radius.circular(20);

  static Color primaryColorDark= Color(0xff1e1e1e);
  static Color primaryColorAccentDark= Color(0xFF0c2934);
  static Color primaryColorWhiteDark= primaryColorAccentDark;
  static Color primaryTextColorDark = Color(0xff0089ff);

  static Color primaryColorLight= Color(0xff2196f3);
  static Color primaryColorAccentLight= Color(0xFFBBDEFB);
  static Color primaryColorWhiteLight= Colors.white;
  static Color primaryTextColorLight = Color(0xff383f51);

  Color primaryColor= isDark ? primaryColorDark : primaryColorLight;
  Color primaryColorAccent= isDark ? primaryColorAccentDark : primaryColorAccentLight;
  Color primaryColorWhite= isDark ? primaryColorWhiteDark : primaryColorWhiteLight;
  Color primaryTextColor = isDark ? primaryTextColorDark : primaryColorLight;

  bool isRtl = false;

  setTextDirection(direction){
    this.isRtl = direction;
  }

  setTheme(bool themeStatus){
    isDark = themeStatus;
    primaryColor= isDark ? primaryColorDark : primaryColorLight;
    primaryColorAccent= isDark ? primaryColorAccentDark : primaryColorAccentLight;
    primaryColorWhite= isDark ? primaryColorWhiteDark : primaryColorWhiteLight;
    primaryTextColor = isDark ? primaryTextColorDark : primaryColorLight;
  }

  bool stylingIsUpdated = false;

}