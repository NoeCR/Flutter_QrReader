import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/directions_page.dart';
import 'package:qrreaderapp/src/pages/maps_page.dart';

import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {
  static final pageName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          )
        ],
      ),
      body: Center(child: _callPage()),
      bottomNavigationBar: _createBottomNavigatonBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _createFloatingAcctionButton(),
    );
  }

  BottomNavigationBar _createBottomNavigatonBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Maps')),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text('Directions'))
      ],
    );
  }

  Widget _callPage() {
    switch (currentIndex) {
      case 0:
        return MapsPage();
      case 1:
        return DirectionsPage();
      default:
        return MapsPage();
    }
  }

  FloatingActionButton _createFloatingAcctionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: _scanQR,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void _scanQR() async {
    // geo:40.64092015736605,-74.20506849726566
    // https://fernando-herrera.com/#/home
    dynamic futureString = '';

    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (ex) {
    //   futureString = ex.toString();
    // }

    // if (futureString != null) {
    //   print('Future String: ${futureString.rawContent}');
    // }
  }
}
