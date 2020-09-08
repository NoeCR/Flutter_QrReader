import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRReader',
      initialRoute: 'home',
      routes: getAppRoutes(),
      theme: ThemeData(primaryColor: Colors.deepPurple),
    );
  }
}
