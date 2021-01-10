import 'package:flutter/material.dart';

import 'package:rickpan_app/src/pages/home_page.dart';
import 'package:super_qr_reader/super_qr_reader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de inventario RICKPAN',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'qr': (BuildContext context) => ScanView(),
      },
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
    );
  }
}
