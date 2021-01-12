import 'package:flutter/material.dart';

import 'package:rickpan_app/src/bloc/scans_bloc.dart';
import 'package:rickpan_app/src/models/scan_model.dart';

import 'package:rickpan_app/src/pages/direcciones_page.dart';
import 'package:rickpan_app/src/pages/mapas_page.dart';
import 'package:rickpan_app/src/utils/utils.dart' as utils;

import 'package:super_qr_reader/super_qr_reader.dart';

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
      appBar: AppBar(
        title: Text('Rickpan'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTODOS,
          )
        ],
      ),
      body: _cargarPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _scanQR(context),
      ),
    );
  }

  _scanQR(BuildContext context) async {
    // https://fernando-herrera.com
    // geo: 40.7242330447051705,-74.00731459101566
// ================ prueba sin scan =========================== //
/* 
    String result = 'https://fernando-herrera.com';
    if (result != null) {
      final scan = ScanModel(valor: result);
      scansBloc.agregarScan(scan);

      final scan2 =
          ScanModel(valor: 'geo:40.7242330447051705,-74.00731459101566');
      scansBloc.agregarScan(scan2);

      utils.abrirScan(context, scan);
    } */

// =============== codigo funcional comentado con scan ================== //

    String result = '';

    String results = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanView(),
        ));

    if (results != null) {
      result = results;
      //print('Resultados lectura qr= $result');
      final scan = ScanModel(valor: result);
      scansBloc.agregarScan(scan);
      utils.abrirScan(context, scan);
    }

// ===================== ACA TERMINA CON SCAN ============================== //
  }

  Widget _cargarPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      //break;
      default:
        return MapasPage();
    }
  }

  _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        _itemNavigationBar(Icon(Icons.house), Text('Tiendas')),
        _itemNavigationBar(Icon(Icons.inventory), Text('Pedidos')),
      ],
    );
  }

  _itemNavigationBar(Widget icon, Widget title) {
    return BottomNavigationBarItem(
      icon: icon,
      title: title,
    );
  }
}
