// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' hide Point;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

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

  AnimationController controller;
  final lines = <Line>[];
  _CarteState();

  @override
  void initState() {
    super.initState();
    lines.add(Line(Offset(80.0,250.0),Offset(140.0,250.0)));
    lines.add(Line(Offset(80.0,250.0),Offset(80.0,310.0)));
    lines.add(Line(Offset(60.0,310.0),Offset(90.0,310.0)));//
    lines.add(Line(Offset(60.0,310.0),Offset(60.0,410.0)));
    lines.add(Line(Offset(60.0,410.0),Offset(160.0,410.0)));
    lines.add(Line(Offset(160.0,400.0),Offset(160.0,410.0)));//
    lines.add(Line(Offset(160.0,410.0),Offset(300.0,410.0)));
    lines.add(Line(Offset(300.0,410.0),Offset(300.0,270.0)));
    lines.add(Line(Offset(300.0,270.0),Offset(160.0,270.0)));
    lines.add(Line(Offset(160.0,270.0),Offset(160.0,320.0)));//
    lines.add(Line(Offset(160.0,310.0),Offset(130.0,310.0)));//
    lines.add(Line(Offset(140.0,310.0),Offset(140.0,250.0)));
  }

  @override
  void dispose() {
    controller.stop();
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
                        foregroundPainter: new LinePainter(lines)))),
        ));
  }
}
class LinePainter extends CustomPainter{
  final lines;
  LinePainter(this.lines);

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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


