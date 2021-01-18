import 'package:flutter/material.dart';

import 'package:rickpan_app/src/models/scan_model.dart';

class PedidoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Pedido'),
      ),
      body: Column(
        children: [
          _infodelatienda(scan),
          SizedBox(height: 10),
          _infoProductos(context),
        ],
      ),
    );
  }

  _infodelatienda(ScanModel scan) {
    return Card(
      margin: EdgeInsets.all(15.0),
      elevation: 15.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Align(
        child: Text(
          scan.valor,
          style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
        ),
        alignment: Alignment.topLeft,
      ),
    );
  }

  _infoProductos(BuildContext context) {
    return Flexible(child: ListView());
  }
}
