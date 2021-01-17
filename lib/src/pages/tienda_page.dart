import 'package:flutter/material.dart';

import 'package:rickpan_app/src/bloc/scans_bloc.dart';
import 'package:rickpan_app/src/models/scan_model.dart';
import 'package:rickpan_app/src/utils/utils.dart' as utils;
import 'package:super_qr_reader/super_qr_reader.dart';

class MapasPage extends StatefulWidget {
  @override
  _MapasPageState createState() => _MapasPageState();
}

class _MapasPageState extends State<MapasPage> {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();
    return Scaffold(
      appBar: AppBar(title: Text('Tiendas'), actions: [
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: scansBloc.borrarScanTODOS,
        )
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _scanQR(context),
        tooltip: 'Boton de sacan QR',
      ),
      body: StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scansStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final scans = snapshot.data;
          if (scans.length == 0) {
            return Center(child: Text('No hay informacion'));
          }
          return ListView.builder(
              padding: EdgeInsets.all(5.0),
              itemCount: scans.length,
              itemBuilder: (context, i) => Dismissible(
                    key: UniqueKey(),
                    background:
                        Container(color: Theme.of(context).primaryColor),
                    onDismissed: (direction) =>
                        scansBloc.borrarScan(scans[i].id),
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        _infoTarjeta(context, scans, i),
                      ],
                    ),
                  ));
        },
      ),
    );
  }

  Widget _infoTarjeta(BuildContext context, List<ScanModel> scans, int i) {
    return Card(
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: ListTile(
        onTap: () => utils.abrirScan(context, scans[i]),
        leading: Icon(Icons.house, color: Theme.of(context).primaryColor),
        title: Text(scans[i].valor,
            style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic)),
        subtitle: Text('ID: ${scans[i].id}'),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
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
}
