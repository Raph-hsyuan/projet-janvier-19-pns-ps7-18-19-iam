import 'package:flutter/material.dart';
import 'package:polymuseum/main.dart';
import '../DBHelper.dart';
import '../global.dart' as global;

class VisitGeneratorScreen extends StatelessWidget {

  VisitGeneratorScreen({Key key}) : super(key: key);
  DBHelper dbHelper = DBHelper.instance; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generateur de visite"),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Voici votre clé de visite :',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              dbHelper.addVisit(global.instance.getScannedObjects().map((o) => o["id"].toString()).toSet()).toString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ]
        ),
      ),
    );
  }
}