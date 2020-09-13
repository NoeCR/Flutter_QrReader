import 'dart:async';

import 'package:qrreaderapp/src/bloc/validatior.dart';
import 'package:qrreaderapp/src/services/db_service.dart';

class ScansBloc with Validator {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // Obtener los Scans de la BD
    getScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scansStreamHtpp =>
      _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController?.close();
  }

  addScan(ScanModel scan) async {
    await DBService.db.newScan(scan);
    getScans();
  }

  getScans() async {
    _scansController.sink.add(await DBService.db.getAllScans());
  }

  deleteScan(int id) async {
    await DBService.db.deleteScan(id);
    getScans();
  }

  deleteScansAll() async {
    await DBService.db.deleteAll();
    // Al eliminar todos los registros de la bbdd podemos devolver en el stream un array vacio
    _scansController.sink.add([]);
  }
}
