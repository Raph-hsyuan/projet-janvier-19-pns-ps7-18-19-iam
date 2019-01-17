import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/Accelerometer.dart';
import 'dart:math' as math;

 Accelerometer accelerometer = Accelerometer.instance;
 
 class RaceScreen extends StatefulWidget{  
  @override
  RaceScreenState createState(){
    return new RaceScreenState();
  }
}

class RaceScreenState extends State<RaceScreen>  {
  List<double> coordinates;
  double speed = 0;
  double maxSpeed = 0;

  @override
  void initState() {
    accelerometer.listen(update);
  }

  void update(List<double> xyz){
    print(xyz);
    setState(() {
          coordinates = xyz;
          speed = math.sqrt(math.pow(xyz[0], 2) + math.pow(xyz[1], 2)+ math.pow(xyz[2], 2));
          if(maxSpeed < speed){
            maxSpeed = speed;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(maxSpeed.toString()),
    ));
    }
}


