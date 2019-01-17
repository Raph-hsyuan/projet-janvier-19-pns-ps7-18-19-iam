import 'package:flutter/material.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
// BeaconsTool beaconsTool = BeaconsTool.instance;

class Line{
  Offset p1;
  Offset p2;
  Line(Offset p1, Offset p2){
    this.p1 = p1;
    this.p2 = p2;
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => new _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {

  //AnimationController controller;
  final lines = <Line>[];
  final points = <Offset>[];
  String region = '';
  Offset current = Offset(-100, -100);
  _MapScreenState();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  StreamSubscription<RangingResult> _streamRanging;
  StreamSubscription<double> _streamdoubleRanging;
  List<double> _userAccelerometerValues;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  double _direction;
  double pi = 3.1415926;
  double shaking = 0.2;
  bool shakeState = false;
  int shakeStopCount = 0;

  @override
  void initState() {
    initBeacon();
    initNotification();
    super.initState();
    downloadMap();
    _streamdoubleRanging = FlutterCompass.events.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    });
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      double standard = 20.0;
      double ac = pow(pow(event.x,2)+pow(event.y,2)+pow(event.z,2),0.5);
      if(ac>standard && !shakeState){
        setState(() {
                  shakeState = true;       
                  print('startshaking');
                });
      }else if(ac<standard && shakeState && shakeStopCount++ > 5){
        setState(() {
                  shakeState =false;
                  shakeStopCount =0;
                  print('stopshaking');
                });
      }
      if(shakeState){
        shaking == 0? shaking = 0.2:shaking = 0;
      }
    });
  }

  updatePosition() async{
    Beacon nearby = await getNearby();
    Beacon mark = nearby;
    for(int i = 0;i<40;i++){
      Beacon check;
      nearby = await getNearby();
      check = nearby;
      if(check == null) break;
      if(nearby.accuracy<mark.accuracy)
        mark = nearby;
      // print(mark.minor.toString()+' : '+mark.accuracy.toString());
    }
    if(mark == null){
      return;
    }

    nearby = mark;
    var o = await DBHelper.instance.getExhibition(3);
    final map = o['beacons'];
    double x;
    double y;
    int j=0;
    String regionName = '';
    // String UUID = nearby.proximityUUID;
    if(nearby == null) return;
    while(map.length>j){
      String id = nearby.proximityUUID.toString() + nearby.major.toString()+nearby.minor.toString();
      if(id == map[j]['ID']){
        x= map[j]['x']*1.0;
        y= map[j]['y']*1.0;
        regionName = map[j]['region'];
      }
      j++;
    }
    if(region == regionName) return;
    setState(() {
    // MEMORY LEAK hasn't been handled
    // this cause the memory leak because it can be still running after the 
    // _streamdoubleRanging have been cancelled, but it must be a async method called by
    // _streamdoubleRanging beacause _streandoubleRanging itself can't be async
    // -HUANG
          current = Offset(x, y);
          region = regionName;
        });
    print('---------------\n\n\n'+'Now at '+region+'\n\n\n----------------');
    var text = await DBHelper.instance.getExhibitionByUUID(nearby.proximityUUID);
    await _showNotification(text['message'][nearby.minor.toString()]);


  }
  
  downloadMap() async{
    setState(() {
          region = 'Locating...';
        });
    updatePosition();
    var o = await DBHelper.instance.getExhibition(3);
    final map = o['beacons'];
    var obj = await DBHelper.instance.getExhibition(2);
    int i = 1;
    String index = '';
    while(obj['l'+i.toString()]!=null){
      index = 'l'+i.toString();
      setState(() {
              lines.add(Line (Offset(obj[index][0]*1.0,
                            obj[index][1]*1.0),
                      Offset(obj[index][2]*1.0,
                            obj[index][3]*1.0)));
            });
      i++;
    }
    // var obj2 = await DBHelper.instance.getExhibition(3);
    int j = 0;
    while(map.length>j){
      setState(() {
              points.add(Offset(map[j]['x']*1.0,map[j]['y']*1.0));
            });
      j++;
    }
  }

  @override
  void dispose() {
    if (_streamRanging != null) {
      _streamRanging.cancel();
    }
    if (_streamdoubleRanging != null) {
      _streamdoubleRanging.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        //appBar: new AppBar(title: new Text(region)),
        body: new Builder(
            builder: (context) => new GestureDetector(
                child: new Container(
                    decoration:BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/carte.png'),
                        fit: BoxFit.fill
                      )
                    ),
                    child: new Stack(
                      children: <Widget>[
                        Positioned(
                          top: 490,
                          left: 35,
                          child : FloatingActionButton.extended(
                                  backgroundColor:Colors.brown[600],
                                  icon: Icon(Icons.camera_alt),
                                  label: Text("Scan"),
                                  )
                          ),
                        Positioned(
                          top: 180,
                          left: 35,
                          child:
                            new Text(
                              region,
                              style: new TextStyle(fontSize: 21.0, color: Colors.brown[600],fontFamily: 'Broadwell'),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                       )),
                        Positioned(
                          top: 100,
                          left:35,
                          right:35,
                          child:
                            new Text(
                              'PolyMuseum',
                              style: new TextStyle(fontSize: 41.0, color: Colors.brown[600],fontFamily: 'Broadwell'),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                       )),
                       Positioned(
                        top:450,
                        left: 230,
                        child:Transform.rotate(
                          angle: shaking,
                          child: new Image.asset('images/shake.png'))
                        ),
                      Positioned(
                        top: 560,
                        left: 200,
                        child:
                          new Text(
                              'Secouez le telephone\nCherchez les tresors',
                              style: new TextStyle(fontSize: 11.0, color: Colors.brown[600],fontFamily: 'Broadwell'),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                          )
                        ),
                       CustomPaint(
                        willChange: true,
                        child: new Container(),
                        foregroundPainter: new MapPainter(lines,points)),
                       Positioned(
                        top:current.dy-27.5,
                        left: current.dx-27.5,
                        child:Transform.rotate(
                          angle: ((_direction ?? 0) * (pi / 180)),
                          child: new Image.asset('images/Point.png'))),
                      ])))));
  }

  initNotification() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    await flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            title: new Text('Notification'),
            content: new Text('$payload'),
          ),
    );  
  }

  Future _showNotification(String message) async {
    if(message.isEmpty) return;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Welcome to '+ message,
      'Bonne journee',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
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
      regions.add(Region(
          identifier: 'PolyMuseum',
          proximityUUID: '61687109-905F-4436-91F8-E602F514C96D'));
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
        updatePosition();
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

  int currentMinor = 9999;
  String currentUUID = '';
  String currentRegion = '';
  
  Future<Beacon> getNearby() async {
    final find = <Beacon>[] ;
    var obj = await DBHelper.instance.getExhibition(3);
    int j = 0;
    final map = obj['beacons'];
    while(map.length>j){
      for(Beacon b in _beacons){
        String id = b.proximityUUID+b.major.toString()+b.minor.toString();
        if(id == map[j]['ID'])
          find.add(b);
      }
      j++;
    }
    Beacon mark;
    double min = 999;
    for(Beacon b in find){
      if(b.accuracy<min){
        min = b.accuracy;
        mark = b;
      }
    }
    return mark;
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
    //canvas.drawCircle(current, 20, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}




