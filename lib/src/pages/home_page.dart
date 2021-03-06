import 'package:flutter/material.dart';

import 'package:rickpan_app/src/bloc/scans_bloc.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:rickpan_app/src/pages/productos_page.dart';
import 'package:rickpan_app/src/pages/tienda_page.dart';
import 'package:rickpan_app/src/pages/Info_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cargarPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
    );
  }

  Widget _cargarPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return ProductosPage();
      case 2:
        return InfoPage();
      //break;
      default:
        return MapasPage();
    }
  }

  _crearBottomNavigationBar() {
    return CurvedNavigationBar(
      index: 0,
      height: 50.0,
      backgroundColor: Theme.of(context).primaryColor,
      items: [
        Icon(Icons.house, size: 30, color: Theme.of(context).primaryColor),
        Icon(Icons.add_box_sharp,
            size: 30, color: Theme.of(context).primaryColor),
        Icon(Icons.info_outline,
            size: 30, color: Theme.of(context).primaryColor)
      ],
      animationCurve: Curves.easeInOutBack,
      animationDuration: Duration(milliseconds: 1000),
      color: Color.fromRGBO(0, 29, 125, 50.0),
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }
}
