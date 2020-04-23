import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScanBloc with Validators {

  static final ScanBloc _singleton = ScanBloc._internal();

  factory ScanBloc(){
    return _singleton;
  }

  ScanBloc._internal(){
    //Obtener Scams de la base de datos
    obtenerScans();
  }

  final _scanController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scanStream => _scanController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scanStreamHttp => _scanController.stream.transform(validarHttp);


  dispose(){
    _scanController?.close();
  }

  obtenerScans() async{
    _scanController.sink.add(await DBProvider.db.getTodosSCans());
  }

  agregarScan(ScanModel scan) async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos() async{
    await DBProvider.db.deleteAll();
    obtenerScans();
  }

}

