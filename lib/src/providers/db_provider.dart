import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:rickpan_app/src/models/scan_model.dart';
export 'package:rickpan_app/src/models/scan_model.dart';

class DBprovider {
  static Database _darabase;
  static final DBprovider db = DBprovider._();

  DBprovider._();

  Future<Database> get database async {
    if (_darabase != null) return _darabase;

    _darabase = await initDB();

    return _darabase;
  }

  initDB() async {
    Directory documentsDirectory =
        await getApplicationDocumentsDirectory(); // donde se encuentra la base de datos

    String path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE Scans ('
            ' id INTEGER PRIMARY KEY,'
            ' tipo TEXT,'
            ' valor TEXT'
            ')');
      },
    );
  }

  // CREAR REGISTRO EN LA BASE DE DATOS

  // forma 1

  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.rawInsert("INSERT Into Scans (id, tipo, valor) "
        "VALUES ( ${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}' )");
    return res;
  }

  // forma 2 , la usada mas facil que la 1
  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  // SELECT - Obtener información

  //Scans por id
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id= ?', whereArgs: [id]);
    return res.isEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //todos los Scans
  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list =
        res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];

    return list;
  }

  //scan por tipo
  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELCT * FROM Scans WHERE tipo='$tipo'");

    List<ScanModel> list =
        res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];

    return list;
  }

  // Actualizar Registros

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  // borrar registro

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll(int id) async {
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }
}
