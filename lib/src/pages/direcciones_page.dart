import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scan_bloc.dart';
import 'package:qrreaderapp/src/model/scan_model.dart';

import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {

  final scanBloc = ScanBloc();

  @override
  Widget build(BuildContext context) {

    scanBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scanBloc.scanStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }else{
          final scans = snapshot.data;
          if(scans.length == 0){
            return Center(child: Text('No Hay Informacion De Direcciones'),);
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red,),
              onDismissed: (direction) => scanBloc.borrarScan(scans[i].id),
              child: ListTile(
                leading: Icon(Icons.search, color: Theme.of(context).primaryColor,),
                title: Text(scans[i].valor),
                subtitle: Text('Tipo: ${scans[i].tipo}'),
                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
                onTap: (){
                  utils.abrirScan(context, scans[i]);
                },
              ),
            ),
          );

        }
      },
    );
  }
}
