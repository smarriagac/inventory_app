import 'package:flutter/material.dart';
import 'package:rickpan_app/src/pages/home_page.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SplashScreenView(
        home: HomePage(),
        duration: 3000,
        imageSize: 200,
        imageSrc: 'assets/info.jpg',
        text: 'APP RICKPAN',
        textType: TextType.ScaleAnimatedText,
        textStyle: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
    );
  }
}
