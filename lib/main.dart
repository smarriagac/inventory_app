import 'package:flutter/material.dart';

import 'package:rickpan_app/src/pages/home_page.dart';
import 'package:rickpan_app/src/pages/pedido_page.dart';

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
        'pedido': (BuildContext context) => PedidoPage(),
        //'lector': (BuildContext context) => ScanView(),
      },
      theme: ThemeData(primaryColor: Colors.brown),
    );
  }
}
