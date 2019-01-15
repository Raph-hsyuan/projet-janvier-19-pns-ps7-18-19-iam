

import 'package:flutter/material.dart';
import 'package:polymuseum/genQuizPersoScreen.dart';
import 'package:polymuseum/QrScreen.dart';
import 'package:polymuseum/Beacons.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/global.dart' as global;
import 'genVisitScreen.dart';
import 'package:polymuseum/VisitChooserScreen.dart';
import 'package:polymuseum/CheckListScreen.dart';
import 'package:polymuseum/BeaconsTool.dart';
import 'package:polymuseum/Carte.dart';
void main() async {
  BeaconsTool beaconsTool = BeaconsTool.instance;
  await beaconsTool.initBeacon();
  await DBHelper.updateSettings();
  global.setInstanceOnce(global.DefaultGlobal());

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
                child: Text('Beacons'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Carte()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Générer une visite personnalisé'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenVisitScreen()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Générer Quiz personnalisé'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenQuizPersoScreen()),
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