import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
}
