import 'package:flutter/material.dart';
import 'package:polymuseum/CheckListScreen.dart';
import 'package:polymuseum/global.dart' as global;


class VisitChooserScreen extends StatefulWidget {

  @override
  VisitChooserScreenState createState(){
    return new VisitChooserScreenState();
  }


}

class VisitChooserScreenState extends State<VisitChooserScreen> { 


  String _seed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Visite personnalisée"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Visit seed'
            ),
            onChanged: (text){
              _seed = text;
            },
          ),
          RaisedButton(
            child: Text("Charger check list"),
            onPressed: (){

              global.seed = int.parse(_seed);
              global.checkListObjects.clear();          
              Navigator.pop(context);
            },
          )
        ]
      ),
    );
  }
}