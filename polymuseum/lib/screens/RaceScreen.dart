import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'dart:math' as math;
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/sensors/NFCScanner.dart';

 Accelerometer accelerometer = Accelerometer.instance;
 DBHelper dbHelper = DBHelper.instance;
 NFCScanner nfcScanner = NFCScanner.instance;
 
 class RaceScreen extends StatefulWidget{  
  @override
  RaceScreenState createState(){
    return new RaceScreenState();
  }
}

class RaceScreenState extends State<RaceScreen>  {
  List<double> acceleration = [0,0,0];
  List<double> celerity = [0,0,0];

  double maxAcceleration = 0;
  double speed = 0;
  double avgSpeed = 0;
  double maxSpeed = 0;

  double result = 0;
  bool stopped = false;
  String title = "Vitesse en direct : ";

  double c = 0;
  double maxC = 0;
  
  int oldTime = 0;

  List<Widget> leaderboard = [Text("\nLEARDERBOARD :\n")];
  
  final control = TextEditingController();
  Stopwatch stopwatch = new Stopwatch();

  @override
  void initState() {
    super.initState();
    accelerometer.listen(update);
    nfc();
    stopwatch.start();
  }


  void update(List<double> xyz){
    if(!stopped){
    setState(() {
          acceleration = xyz;
          celerity[0] =xyz[0]*(stopwatch.elapsedMilliseconds-oldTime)/1000;
          celerity[1] =xyz[1]*(stopwatch.elapsedMilliseconds-oldTime)/1000;
          celerity[2] =xyz[2]*(stopwatch.elapsedMilliseconds-oldTime)/1000;
          
          //calculs de la vitesse selon les 3 axes
          speed = math.sqrt(math.pow(celerity[0], 2)+math.pow(celerity[1], 2)+math.pow(celerity[2], 2));

          oldTime = stopwatch.elapsedMilliseconds;

          if(speed > maxSpeed){
            maxSpeed = speed;
          }

          //c = speed in Km/H
          c = speed*3.6;
          maxC = maxSpeed*3.6;
          result = c;
          
    });}
  }

  Future stop() async{
     setState(() {
            result = maxC;
            stopped = true;
            title = "Vitesse maximum :";
        }); 
    stopwatch.reset();
    stopwatch.stop();


    for(int id = 0; id<10; id++ ){
      var o = await dbHelper.getDocumentInCollectionById("sprints", id);
      if(o!=null){
        setState(() {
          leaderboard.add(Text(o["name"]+"temps : "+o["speed"].toString()));
         });
      }

    }
  }

  void nfc() async{
    //active le sacanner NFC, si le le téléphone scan le tag NFC correspondant à la fin de la course, la méthode stop() est appelé
    var o = await nfcScanner.read();
    if(o.split("en")[1] == "4"){
      stop();
    }
  }

  void submit() async{
    for(int id = 0; id<10;id++ ){
      var o = await dbHelper.getDocumentInCollectionById("sprints", id);
      if( o==null || o!=null && double.parse(o["speed"]) < maxC){ //le participant peut entrer dans le leaderboard seulement s'il fait parti du top10
        if(control.text != null){
          dbHelper.addSprint(id,control.text, maxC);
        }
        else{
          dbHelper.addSprint(id,"default", maxC);
        }
        Navigator.of(context).pop();
        return;
      }
    }
    Navigator.of(context).pop();
  }
  
    @override
  build(BuildContext context){

    return new Scaffold(
      body: new ListView(
        children : <Widget>[
          Text(title, style: new TextStyle(fontSize: 30.0)),
          Text(result.round().toString(), style: new TextStyle(fontSize: 150.0)),
          Text("Km/h", style: new TextStyle(fontSize: 75.0)),
          stopped ?  TextField(
              controller: control,
              onEditingComplete: submit,              
              decoration: InputDecoration (
              hintText: 'Votre NOM',
              filled: true,
              )) : FloatingActionButton.extended(
        icon: Icon(Icons.stop),
        label: Text("Stop"),
        onPressed: stop,
      ),
      !stopped ? Text("loading...") : Column ( children : leaderboard,),      ]
    ));
  }
}