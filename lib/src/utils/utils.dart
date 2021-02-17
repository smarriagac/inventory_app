import 'package:flutter/material.dart';
import 'package:rickpan_app/src/models/scan_model.dart';

abrirScan(BuildContext context, ScanModel scan) {
  if (scan.tipo == 'Tienda') {
    Navigator.pushNamed(context, 'pedido', arguments: scan);
  }
}
