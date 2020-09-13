import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DirectionsPage extends StatelessWidget {
  static final pageName = 'directions';

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    scansBloc.getScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHtpp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if (scans.length == 0) {
          return Center(child: Text('No data'));
        }

        return ListView.builder(
            itemCount: scans.length,
            // Dismissible, permite deslizar un elemento a la izquierda o derecha
            // UniqueKey, permite crear una llave única
            itemBuilder: (context, index) => Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red[100]),
                onDismissed: (direction) =>
                    scansBloc.deleteScan(scans[index].id),
                child: ListTile(
                  onTap: () => utils.launchScan(context, scans[index]),
                  leading: Icon(Icons.cloud_queue,
                      color: Theme.of(context).primaryColor),
                  title: Text(scans[index].value),
                  subtitle: Text('ID: ${scans[index].id}'),
                  trailing:
                      Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                )));
      },
    );
  }
}
