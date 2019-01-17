// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:sensors/sensors.dart';


class Accelerometer {

  static Accelerometer  _instance;
  static Accelerometer get instance => _instance;

  List<double> _userAccelerometerValues;
  List<double> get accelerometerValues => _userAccelerometerValues;


  static setInstanceOnce(Accelerometer obj){
    if(_instance == null){
      _instance = obj;
    }
  }

  listen(){
  userAccelerometerEvents.listen((UserAccelerometerEvent event) {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
  });
  }

}