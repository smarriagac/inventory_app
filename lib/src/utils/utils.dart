import 'package:flutter/material.dart';
import 'package:rickpan_app/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

abrirScan(BuildContext context, ScanModel scan) {
  if (scan.tipo == 'Tienda') {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
