import 'package:flutter/material.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// StreamSubscription<RangingResult> _streamRanging;
// BeaconsTool beaconsTool = BeaconsTool.instance;

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
  String region = '';
  Offset current;
  _CarteState();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  @override
  void initState() {
    initBeacon();
    initNotification();
    super.initState();
    downloadMap();
  }

  updatePosition() async{
    Beacon nearby = await getNearby();
    // for(int i = 0;i<50;i++){
    //   nearby = await getNearby();
    //   if(nearby.accuracy<mark.accuracy)
    //     mark = nearby;
    //   print(mark.minor.toString()+' : '+mark.accuracy.toString());
    // }
    var o = await DBHelper.instance.getExhibition(3);
    final map = o.data['beacons'];
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
    setState(() {
          current = Offset(x, y);
          region = regionName;
        });
    pushWelcomeMessage(nearby.proximityUUID, nearby.minor, nearby.accuracy);
  }
  
  downloadMap() async{
    updatePosition();
    var o = await DBHelper.instance.getExhibition(3);
    final map = o.data['beacons'];
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
    // var obj2 = await DBHelper.instance.getExhibition(3);
    int j = 0;
    while(map.length>j){
      setState(() {
              points.add(new Offset(map[j]['x']*1.0,map[j]['y']*1.0));
            });
      j++;
    }
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
    return new Scaffold(
        appBar: new AppBar(title: new Text(region)),
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
                        foregroundPainter: new MapPainter(lines,points,current))))));
  }

  initNotification() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
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

  int currentMinor;
  String currentUUID;
  String currentRegion;

  void pushWelcomeMessage(String UUID, int minor, double distance) async {
    if(currentMinor == minor && currentUUID == UUID) return;
    if(distance > 0.6) return;
    currentMinor = minor;
    currentUUID = UUID;
    var text = await DBHelper.instance.getExhibitionByUUID(UUID);
     _showNotification(text.data['message'][minor.toString()]);
     currentRegion = text.data['message'][minor.toString()] + ' Region';
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
  final current;
  MapPainter(this.lines,this.points,this.current);

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
    canvas.drawCircle(current, 20, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}




