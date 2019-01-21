

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polymuseum/screens/GuideScreen.dart';
import 'package:polymuseum/screens/VisitorScreen.dart';
import 'package:polymuseum/sensors/BeaconScanner.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/sensors/BeaconsTool.dart';
import 'package:polymuseum/sensors/Scanner.dart';
import 'package:polymuseum/sensors/Gyroscope.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'screens/RaceScreen.dart';
import 'package:polymuseum/sensors/NFCScanner.dart';
import 'screens/TennisScreen.dart';


void main() async {


  //DBHelper
  DBHelper.setInstanceOnce(DBHelper());
  await DBHelper.instance.updateSettings();

  //Global
  global.setInstanceOnce(global.DefaultGlobal());

  //QrCode Scanner
  Scanner.setInstanceOnce(new Scanner());

  //Accelerometer
  Accelerometer.setInstanceOnce(new Accelerometer());

  //Gyroscope
  Gyroscope.setInstanceOnce(new Gyroscope());

  //NFC Scanner
  NFCScanner.setInstanceOnce(new NFCScanner());

  //Beacon Scanner
  BeaconsTool.setInstanceOnce(new BeaconsTool());


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
                child: Text('Visiteur'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VisitorScreen()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Guide'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GuideScreen()),
                  );
                },
              ),RaisedButton(
                child: Text('Run'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tennis()),
                  );
                },
              ),
            ]
        ),
      ),
    );
  }
}