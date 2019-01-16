import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/global.dart' as global;

class CheckListScreen extends StatefulWidget {

  int _seed;

  CheckListScreen({Key key}) : super(key: key);

  @override
  CheckListScreenState createState() {
    return new CheckListScreenState();
  }
}


class CheckListScreenState extends State<CheckListScreen> {


  CheckListScreenState(){
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar (
        title: new Text("Check list"),
      ),
      body: ListView.builder(
        itemCount: global.instance.checkListObjectsCount,
        itemBuilder: (context, index) => ListTile(title: new Text(global.instance.checkListObjects[index]["name"].toString())),
      ),
    );
  }
}