import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


class CheckListScreen extends StatefulWidget {

  List<String> _objectsIds;

  CheckListScreen({Key key, @required objectsIds}) : super(key: key) {
    _objectsIds = objectsIds;
  }

  @override
  CheckListScreenState createState() {
    return new CheckListScreenState(_objectsIds);
  }
}

class CheckListScreenState extends State<CheckListScreen> {

  List<String> _objectsIds;

  CheckListScreenState(List<String> objectsIds){
    _objectsIds = objectsIds;
  }

  List<Widget> buildList(){
    return [new Text("hello")];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar (
        title: new Text("Check list"),
      ),
      body: new Column(
        children: buildList()
      )
    );
  }
}