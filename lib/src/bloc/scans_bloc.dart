import 'dart:async';

import 'package:rickpan_app/src/bloc/validator.dart';
import 'package:rickpan_app/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }
  ScansBloc._internal() {
    // obtener los Scans de la Base de datos
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validarTienda);
  Stream<List<ScanModel>> get scansStreamErroneo =>
      _scansController.stream.transform(scanError);

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBprovider.db.getTodosScans());
  }

  agregarScan(ScanModel scan) async {
    await DBprovider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBprovider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTODOS() async {
    await DBprovider.db.deleteAll();
    obtenerScans();
  }
}
