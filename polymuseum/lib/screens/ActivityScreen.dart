import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';


Accelerometer accelerometer = Accelerometer.instance;

class ActivityScreen extends StatefulWidget{  
  @override
  _ActivityScreenState createState(){
    
    return new _ActivityScreenState();
  }
}

class _ActivityScreenState extends State<ActivityScreen>  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Activités")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Text("Pour lancer une activité poser votre téléphone sur le tag NFC de l'activité.", textAlign: TextAlign.center)
            )
          ],
        ) 
      ),
    );
  }
}