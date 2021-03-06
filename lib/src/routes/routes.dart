import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/directions_page.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';
import 'package:qrreaderapp/src/pages/map_deploy_page.dart';
import 'package:qrreaderapp/src/pages/maps_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return <String, WidgetBuilder>{
    HomePage.pageName: (BuildContext context) => HomePage(),
    MapsPage.pageName: (BuildContext context) => MapsPage(),
    MapPage.pageName: (BuildContext context) => MapPage(),
    DirectionsPage.pageName: (BuildContext context) => DirectionsPage(),
  };
}
