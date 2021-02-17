import 'package:flutter/material.dart';

import 'package:rickpan_app/src/pages/home_page.dart';
import 'package:rickpan_app/src/pages/pedido_page.dart';
import 'package:rickpan_app/src/pages/splash_screen_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de inventario RICKPAN',
      initialRoute: 'splashScreen',
      routes: {
        'splashScreen': (BuildContext context) => SplashScreenPage(),
        'home': (BuildContext context) => HomePage(),
        'pedido': (BuildContext context) => PedidoPage(),

        //'lector': (BuildContext context) => ScanView(),
      },
      theme: ThemeData(primaryColor: Color.fromRGBO(214, 180, 109, 1.0)
          //Color.fromRGBO(214, 180, 109, 1.0),
          ),
    );
  }
}
