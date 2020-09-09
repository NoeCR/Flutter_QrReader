import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBService {
  static Database _database;

  // Instancia del servicio
  static final DBService db = DBService._();

  // Constructor privado
  DBService._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Scans ('
            ' id INTEGER PRIMARY KEY,'
            ' type TEXT,'
            ' value TEXT'
            ')');
      },
    );
  }

  // CREATE - Crear registros //////////////////////////////////////////////////
  newScanRaw(ScanModel newScan) async {
    final db = await database;

    final res = await db.rawInsert("INSERT INTO Scans (id, type, value) "
        "VALUES (${newScan.id}, '${newScan.type}', '${newScan.value}')");

    return res;
  }

  newScan(ScanModel newScan) async {
    final db = await database;

    final res = await db.insert('Scans', newScan.toJson());

    return res;
  }

  // READ - Buscar registros ///////////////////////////////////////////////////

}
