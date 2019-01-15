import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:polymuseum/DBHelper.dart';

class BeaconsTool {

  factory BeaconsTool() => _getInstance();
  static BeaconsTool get instance => _getInstance();
  static BeaconsTool _instance;

  static setInstanceOnce(BeaconsTool obj){
    if(_instance == null)
      _instance = obj;
  }

  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  DBHelper dbHelper = DBHelper.instance;
  double LEGALDISTANCE = 2.0;


  BeaconsTool._internal(){
    return;
  }

  static BeaconsTool _getInstance(){
    if(_instance == null){
      _instance = new BeaconsTool._internal();
    }
    return _instance;
  }

  List<Beacon> getBeacons(){
    return _beacons;
  }

  initBeacon() async {
    try {
      await flutterBeacon.initializeScanning;
      print('Beacon scanner initialized');
    } on PlatformException catch (e) {
      print(e);
    }

    final regions = <Region>[];

    if (Platform.isIOS) {
      regions.add(
        Region(
            identifier: 'Cubeacon',
            proximityUUID: 'CB10023F-A318-3394-4199-A8730C7C1AEC'),
      );
      regions.add(Region(
          identifier: 'Apple Airlocate',
          proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
    } else {
      regions.add(Region(identifier: 'com.beacon'));
    }

    _streamRanging = flutterBeacon.ranging(regions).listen((result) {
      if (result != null) {
        _regionBeacons.clear();
        _regionBeacons[result.region] = result.beacons;
        _beacons.clear();
        _regionBeacons.values.forEach((list) {
          _beacons.addAll(list);
        });
      _beacons.sort(_compareParameters);

      }
    });
  }

    int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  Future<bool> checkPosition(int index) async {
    var obj = await DBHelper.instance.getObject(index);
    String beaconUUID = obj.data['checkBeacons']['UUID'];
    String beaconMinor = obj.data['checkBeacons']['minor'];
    for(Beacon beacon in _beacons)
      if(beacon.proximityUUID == beaconUUID && beacon.minor.toString() == beaconMinor)
        if(beacon.accuracy <= LEGALDISTANCE)
          return true;
    return false;
  }

  Future<Beacon> getNearby() async {
    final find = <Beacon>[] ;
    var obj = await DBHelper.instance.getExhibition(3);
    int j = 0;
    final map = obj.data['beacons'];
    while(map.length>j){
      for(Beacon b in _beacons){
        String id = b.proximityUUID+b.major.toString()+b.minor.toString();
        if(id == map[j]['ID'])
          find.add(b);
      }
      j++;
    }
    Beacon mark;
    for(Beacon b in find){
      double min = 999;
      if(b.accuracy<min){
        min = b.accuracy;
        mark = b;
      }
    }
    print(mark.accuracy);
    return mark;
  }

}