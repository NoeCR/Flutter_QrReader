import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  static final pageName = 'map';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String mapType = 'streets-v11';
  String mapTitle = 'Coords QR';
  LatLng _currentMapCenter;
  double _currentZoom = 15;
  final MapController mapCtrl = new MapController();

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(mapTitle),
        actions: [
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                mapCtrl.move(scan.getLatLng(), 15.0);
              })
        ],
      ),
      body: _createFlutterMap(scan),
      floatingActionButton: _createFloatingButton(context),
    );
  }

  Widget _createFlutterMap(ScanModel scan) {
    return new FlutterMap(
      mapController: mapCtrl,
      options: MapOptions(
          onPositionChanged: (position, hasGesture) {
            _currentMapCenter = position.center;
            _currentZoom = position.zoom;
          },
          center: scan.getLatLng(),
          zoom: _currentZoom),
      layers: [
        _createMap(),
        _createMark(scan),
      ],
    );
  }

  _createMap() {
    return TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1Ijoibm9lMjAyMSIsImEiOiJja2YxNXo3c3Iwdms0MnFvMG94bzdmNXBkIn0.agF8i1QlNV40nuSQvK4tiA',
          'id': 'mapbox/$mapType'
        });
  }

  _createMark(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
        width: 100.0,
        height: 100.0,
        point: scan.getLatLng(),
        builder: (context) => Container(
          child: Icon(Icons.location_on,
              size: 45.0, color: Theme.of(context).primaryColor),
        ),
      )
    ]);
  }

  Widget _createFloatingButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        if (mapType == 'streets-v11') {
          mapType = 'dark-v10';
        } else if (mapType == 'dark-v10') {
          mapType = 'outdoors-v11';
        } else if (mapType == 'outdoors-v11') {
          mapType = 'light-v10';
        } else if (mapType == 'light-v10') {
          mapType = 'satellite-v9';
        } else if (mapType == 'satellite-v9') {
          mapType = 'satellite-streets-v11';
        } else if (mapType == 'satellite-streets-v11') {
          mapType = 'streets-v11';
        }

        setState(() {
          // Hay un bug por el cual no cambia de tipo de mapa, por ello es necesario
          // Ejecutar el método move del controlador del mapa para que detecte el cambio
          mapTitle = 'Coords QR $mapType';
          mapCtrl.move(_currentMapCenter, 30);
          Future.delayed(Duration(milliseconds: 50), () {
            mapCtrl.move(_currentMapCenter, 15);
          });
        });
      },
    );
  }
}
