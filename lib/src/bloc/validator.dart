import 'dart:async';

import 'package:rickpan_app/src/models/scan_model.dart';

class Validators {
  // scan tienda
  final validarTienda =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final tiendaScan =
          scans.where((element) => element.tipo == 'Tienda').toList();
      sink.add(tiendaScan);
    },
  );

  // scan error
  final scanError =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final tiendaScan =
          scans.where((element) => element.tipo == 'error').toList();
      sink.add(tiendaScan);
    },
  );
}
