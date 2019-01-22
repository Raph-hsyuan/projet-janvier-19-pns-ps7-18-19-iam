import 'package:flutter/material.dart';
import 'package:polymuseum/screens/QuizGeneratorScreen.dart';
import 'package:polymuseum/screens/QrScreen.dart';
import 'package:polymuseum/screens/VisitorScreen.dart';
import 'package:polymuseum/sensors/Beacons.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/screens/VisitGeneratorScreen.dart';
import 'RaceScreen.dart';

class GuideScreen extends StatelessWidget {
  DBHelper dbHelper = new DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Guide',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  fontFamily: 'Broadwell')),
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
                      MaterialPageRoute(
                          builder: (context) => VisitGeneratorScreen()),
                    );
                  },
                ),
                RaisedButton(
                  child: Text('Générer Quiz personnalisé'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizGeneratorScreen()),
                    );
                  },
                ),
                RaisedButton(
                  child: Text('Run'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RaceScreen()),
                    );
                  },
                ),
              ]),
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.compare_arrows),
            backgroundColor: new Color(0xFF000000),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VisitorScreen()),
              );
            }));
  }
}
