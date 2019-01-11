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
    loadObjects();
  }
  

  loadObjects() async {
    
    int seed = global.seed;
    if(seed != -1  && global.checkListObjects.isEmpty){
      var objectsIds = (await DBHelper.instance.getVisit(seed)).data["objects"];

      objectsIds.forEach((id) async {
        DocumentSnapshot obj = await DBHelper.instance.getObject(int.parse(id));
        global.checkListObjects.add(obj.data);
        setState((){});
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar (
        title: new Text("Check list"),
      ),
      body: ListView.builder(
        itemCount: global.checkListObjects.length,
        itemBuilder: (context, index) => ListTile(title: new Text(global.checkListObjects[index]["name"].toString())),
      ),
    );
  }
}