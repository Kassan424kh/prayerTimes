import 'package:flutter/material.dart';

class AppStyling with ChangeNotifier{

  AssetImage backgroundImage =
  AssetImage('assets/background_images/adrian-MBwvFtRqCcQ-unsplash.png');
  AssetImage backgroundImageBlurEffect = AssetImage(
      'assets/background_images/adrian-MBwvFtRqCcQ-unsplash_blur_effect.png');

  Radius primaryRadius50 = Radius.circular(50);
  Radius primaryRadius = Radius.circular(30);
  Radius primaryRadiusMinus10 = Radius.circular(20);

  Color primaryColor= Color(0xff2196f3);
  Color primaryColorAccent= Color(0xFFBBDEFB);
  Color primaryColorWhite= Color(0xffe3f2fd);

  bool isRtl = false;

  setTextDirection(direction){
    this.isRtl = direction;
  }



}