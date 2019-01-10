import 'package:flutter/material.dart';
import 'package:polymuseum/main.dart';

class GenVisitScreen extends StatelessWidget {

  final List<String> objectsIds;
  GenVisitScreen({Key key, @required this.objectsIds}) : super(key: key);

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
              '127736',
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