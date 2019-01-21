import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'dart:math' as math;
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/sensors/NFCScanner.dart';

 Accelerometer accelerometer = Accelerometer.instance;
 DBHelper dbHelper = DBHelper.instance;
 NFCScanner nfcScanner = NFCScanner.instance;
 
 class Tennis extends StatefulWidget{  
  @override
  TennisState createState(){
    return new TennisState();
  }
}

class TennisState extends State<Tennis>  {
  List<double> celerity = [0,0,0];

  double speed = 0;
  double avgSpeed = 0;
  double maxSpeed = 0;

  double result = 0;
  bool stopped = true;
  String title = "Donner un coup puissant pour obtenir votre score";

  double c = 0;
  double maxC = 0;
  
  int oldTime = 0;

  
  Stopwatch stopwatch = new Stopwatch();

  void update(List<double> xyz){
    if(!stopped){
    setState(() {
          celerity[0] =xyz[0]*(stopwatch.elapsedMilliseconds-oldTime)/1000;
          celerity[1] =xyz[1]*(stopwatch.elapsedMilliseconds-oldTime)/1000;
          celerity[2] =xyz[2]*(stopwatch.elapsedMilliseconds-oldTime)/1000;
          
          //calculs de la vitesse selon les 3 axes
          speed = math.sqrt(math.pow(celerity[0], 2)+math.pow(celerity[1], 2)+math.pow(celerity[2], 2));

          oldTime = stopwatch.elapsedMilliseconds;

          if(speed > maxSpeed){
            maxSpeed = speed;
          }

          c = speed*3.6;
          maxC = maxSpeed*3.6;
          result = c;
          
    });}
  }

  Future stop() async{
     setState(() {
            result = maxC;
            stopped = true;
            title = "Points de vitesse du coup maximum :";
        }); 
    stopwatch.reset();
    stopwatch.stop();
  }

  start(){
    accelerometer.listen(update);
    nfc();
    stopwatch.start();
    setState(() {
              stopped = false;
        });
  }


  void nfc() async{
    //active le sacanner NFC, si le le téléphone scan le tag NFC correspondant à la fin de la course, la méthode stop() est appelé
    var o = await nfcScanner.read();
    if(o.split("en")[1] == "4"){
      stop();
    }
  }

  @override
  build(BuildContext context){
    return new Scaffold(
      body: new ListView(
        children : <Widget>[
          Text(title, style: new TextStyle(fontSize: 30.0)),
          Text(result.round().toString(), style: new TextStyle(fontSize: 150.0)),
          Text("POINTS : ", style: new TextStyle(fontSize: 75.0)),
        stopped ? FloatingActionButton.extended(
        icon: Icon(Icons.label_important ),
        label: Text("Start"),
        onPressed: start,
      ) : FloatingActionButton.extended(
        icon: Icon(Icons.stop),
        label: Text("Stop"),
        onPressed: stop,
      ),
    ]
    ));
  }
}