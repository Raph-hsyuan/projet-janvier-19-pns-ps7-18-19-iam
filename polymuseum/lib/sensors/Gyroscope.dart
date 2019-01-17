// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:sensors/sensors.dart';


class Gyroscope {

  static Gyroscope  _instance;
  static Gyroscope get instance => _instance;

  List<double> _gyroscopeValues;
  List<double> get   gyroscopeValues => _gyroscopeValues;


  static setInstanceOnce(Gyroscope obj){
    if(_instance == null){
      _instance = obj;
    }
  }

  listen(
    void callback (List<double> coordinates)
  ){
  gyroscopeEvents.listen((GyroscopeEvent event) {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
        callback(_gyroscopeValues);
  });

  }

}