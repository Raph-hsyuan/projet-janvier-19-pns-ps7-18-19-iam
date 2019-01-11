

import 'package:flutter/material.dart';
import 'package:polymuseum/genQuizPersoScreen.dart';
import 'package:polymuseum/secondScreen.dart';
import 'package:polymuseum/QrScreen.dart';
import 'package:polymuseum/Beacons.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/global.dart' as global;
import 'genVisitScreen.dart';

void main() async {
  await DBHelper.updateSettings();
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
                    MaterialPageRoute(builder: (context) => Beacons()),
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
                    MaterialPageRoute(builder: (context) => SecondScreen()),
                  );
                },
              ),
            ]
        ),
      ),
    );
  }
}