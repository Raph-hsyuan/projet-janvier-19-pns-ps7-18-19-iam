import 'package:flutter/material.dart';
import 'package:polymuseum/sensors/NFCScanner.dart';
import 'package:polymuseum/screens/RaceScreen.dart';
import 'TennisScreen.dart';

NFCScanner nfcScanner = NFCScanner.instance;

const _NFC_ID_TO_ACTIVITY_MAP = {
  "0": RaceScreen.create,
  "1": Tennis.create,
};

const _NFC_ID_TO_ACTIVITY_NAME = {"0": "Course", "1": "Tennis"};

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() {
    return new _ActivityScreenState();
  }
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    nfcScanner.read().then((result) {
      var activity_constructor = _NFC_ID_TO_ACTIVITY_MAP[result];
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => activity_constructor()));
      nfcScanner.stop();
    });

    return Scaffold(
      appBar: AppBar(title: Text("Activités")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                  "Passez votre téléphone sur le tag NFC d'une des activités suivantes pour la démarrer :")),
          Expanded(
              child: ListView.builder(
            itemCount: _NFC_ID_TO_ACTIVITY_NAME.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(_NFC_ID_TO_ACTIVITY_NAME.values.elementAt(index),
                      textAlign: TextAlign.center));
            },
          )),
        ],
      )),
    );
  }
}
