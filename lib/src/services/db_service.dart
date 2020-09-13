import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

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
  Future<ScanModel> getScanId(int id) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];

    return list;
  }

  Future<List<ScanModel>> getScanByType(String type) async {
    final db = await database;

    final res = await db.rawQuery("SELECT * FROM Scans WHERE type='$type'");

    List<ScanModel> list = res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];

    return list;
  }

  // UPDATE - Actualizar registros ///////////////////////////////////////////////////
  Future<int> updateScan(ScanModel newScan) async {
    final db = await database;

    return await db.update('Scans', newScan.toJson(),
        where: 'id = ?', whereArgs: [newScan.id]);
  }

  // DELETE - Borrar registros ///////////////////////////////////////////////////
  Future<int> deleteScan(int id) async {
    final db = await database;

    return await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await database;

    return await db.rawDelete('DELETE FROM Scans');
  }
}
