import 'package:flutter/material.dart';
import 'package:polymuseum/screens/GuideScreen.dart';
import 'package:polymuseum/screens/QuizGeneratorScreen.dart';
import 'package:polymuseum/screens/QrScreen.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/screens/VisitChooserScreen.dart';
import 'package:polymuseum/screens/CheckListScreen.dart';
import 'package:polymuseum/screens/MapScreen.dart';
import 'package:polymuseum/screens/ActivityScreen.dart';

class VisitorScreen extends StatelessWidget {

  DBHelper dbHelper = new DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visiteur'),
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
                child: Text('Activité'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivityScreen()),
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
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.compare_arrows),
            backgroundColor: new Color(0xFFE57373),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GuideScreen()),
              );
            }
        )
    );
  }
}