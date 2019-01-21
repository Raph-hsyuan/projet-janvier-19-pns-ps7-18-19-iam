

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/sensors/Scanner.dart';
import 'package:polymuseum/sensors/Gyroscope.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'package:polymuseum/sensors/NFCScanner.dart';
<<<<<<< HEAD
import 'package:polymuseum/welcomePage/ChooseDialog.dart';
import 'package:polymuseum/welcomePage/SplagePage.dart';
=======
import 'screens/TennisScreen.dart';

>>>>>>> 7a7d765a6be11faf862e9c684a0e67bc977dae70

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
    return MaterialApp(
      home: new SplashPage(), 
      routes: <String, WidgetBuilder>{ 
      '/HomePage': (BuildContext context) => new Container(
        color: Colors.grey[200],
        child: new ChooseDialog(),
      )
    },
    );
  }
}    

