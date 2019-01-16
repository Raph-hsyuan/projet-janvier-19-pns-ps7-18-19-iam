

import 'package:flutter/material.dart';
import 'package:polymuseum/screens/QuizGeneratorScreen.dart';
import 'package:polymuseum/screens/QrScreen.dart';
import 'package:polymuseum/sensors/Beacons.dart';
import 'package:polymuseum/sensors/BeaconScanner.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/screens/VisitGeneratorScreen.dart';
import 'package:polymuseum/screens/VisitChooserScreen.dart';
import 'package:polymuseum/screens/CheckListScreen.dart';
import 'package:polymuseum/sensors/BeaconsTool.dart';
import 'package:polymuseum/screens/MapScreen.dart';
import 'package:polymuseum/sensors/Scanner.dart';

void main() async {

  //Beacons
  BeaconScanner.setInstanceOnce(new BeaconScanner());
  BeaconsTool.setInstanceOnce(new BeaconsTool());
  BeaconsTool beaconsTool = BeaconsTool.instance;
  await beaconsTool.initBeacon();

  //DBHelper
  DBHelper.setInstanceOnce(DBHelper());
  await DBHelper.instance.updateSettings();

  //Global
  global.setInstanceOnce(global.DefaultGlobal());

  //QrCode Scanner
  Scanner.setInstanceOnce(new Scanner());



  runApp(MaterialApp(
    title: 'PolyMusem',
    home: FirstScreen(),
  ));
}

class FirstScreen extends StatelessWidget {

  DBHelper dbHelper = new DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Scan QR-code'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrScreen()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Explorer'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Beacons Finder'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Beacons()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Générer une visite personnalisé'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisitGeneratorScreen()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Générer Quiz personnalisé'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizGeneratorScreen()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Visite personnalisée'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisitChooserScreen()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Check list'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckListScreen()),
                  );
                },
              ),
            ]
        ),
      ),
    );
  }
}