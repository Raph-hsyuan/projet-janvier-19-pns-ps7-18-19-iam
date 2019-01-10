import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

void main() => runApp(Beacons());
String beaconName;
class Beacons extends StatefulWidget {
  @override
  _BeaconsState createState() => _BeaconsState();
}

class _BeaconsState extends State<Beacons> {
  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  @override
  void initState() {
    super.initState();

    initBeacon();
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
      if (result != null && mounted) {
        setState(() {
          _regionBeacons[result.region] = result.beacons;
          _beacons.clear();
          _regionBeacons.values.forEach((list) {
            _beacons.addAll(list);
          });
          _beacons.sort(_compareParameters);
        });
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

  @override
  void dispose() {
    if (_streamRanging != null) {
      _streamRanging.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search Beacon'),
        ),
        body: _beacons == null
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: ListTile.divideTiles(
                    context: context,
                    tiles: _beacons.map((beacon) {
                      beacon.proximityUUID == '10F86430-1346-11E4-9191-0800200C9A66'? beaconName = 'AppleStore':beaconName = 'UN_KNOWN';
                      return ListTile(
                        title: Text(beaconName),
                        subtitle: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Flexible(
                                child: Text(
                                    'Distance: ${beacon.accuracy}m\n',
                                    style: TextStyle(fontSize: 23.0)),
                                flex: 2,
                                fit: FlexFit.tight)
                          ],
                        ),
                      );
                    })).toList(),
              ),
      ),
    );
  }
}
