// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/BeaconsTool.dart';

BeaconsTool beaconsTool = BeaconsTool.instance;

class Line{
  Offset p1;
  Offset p2;
  Line(Offset p1, Offset p2){
    this.p1 = p1;
    this.p2 = p2;
  }
}

class Carte extends StatefulWidget {
  @override
  _CarteState createState() => new _CarteState();
}

class _CarteState extends State<Carte>
    with SingleTickerProviderStateMixin {

  //AnimationController controller;
  final lines = <Line>[];
  final points = <Offset>[];
  _CarteState();

  @override
  void initState() {
    super.initState();
    downloadMap();
  }

  downloadMap() async{
    var obj = await DBHelper.instance.getExhibition(2);
    int i = 1;
    String index = '';
    while(obj.data['l'+i.toString()]!=null){
      index = 'l'+i.toString();
      setState(() {
              lines.add(Line (Offset(obj.data[index][0]*1.0,
                            obj.data[index][1]*1.0),
                      Offset(obj.data[index][2]*1.0,
                            obj.data[index][3]*1.0)));
            });
      i++;
    }
    var obj2 = await DBHelper.instance.getExhibition(3);
    int j = 0;
    List<dynamic> map = obj2.data['beacons'];
    while(map.length>j){
      setState(() {
              points.add(Offset(map[j]['x']*1.0,map[j]['y']*1.0));
            });
      j++;
    }
  }

  @override
  void dispose() {
    //controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Carte de musee')),
        body: new Builder(
            builder: (context) => new GestureDetector(
                child: new Container(
                    decoration:BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/carte.png')
                      )
                    ),
                    child: new CustomPaint(
                        willChange: true,
                        child: new Container(),
                        foregroundPainter: new MapPainter(lines,points))))));
  }

}

class MapPainter extends CustomPainter{
  final lines;
  final points;
  MapPainter(this.lines,this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..color = Colors.brown[500]
    ..maskFilter = MaskFilter.blur(BlurStyle.inner, 0.5);
    for (Line line in lines)
      canvas.drawLine(line.p1,line.p2, paint);
    for (Offset point in points)
      canvas.drawCircle(point, 10, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}




