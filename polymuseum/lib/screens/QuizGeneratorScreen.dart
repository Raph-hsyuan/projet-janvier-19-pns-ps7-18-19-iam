import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polymuseum/screens/VisitGeneratorScreen.dart';
import 'package:polymuseum/screens/DocGeneratorScreen.dart';
import 'package:polymuseum/screens/QuizGeneratorScreen.dart';
import 'package:polymuseum/screens/QuizPersoScreen.dart';
import 'package:polymuseum/global.dart' as global;

class QuizGeneratorScreen extends StatefulWidget {

  QuizGeneratorScreen({Key key}) : super(key: key);

  @override
  _QuizGeneratorScreenState createState() => _QuizGeneratorScreenState();

}

class _QuizGeneratorScreenState extends State<QuizGeneratorScreen> {

  List<int> nbQuiz = [];
  int selectedNb = 0;
  List<Map<String, dynamic>> objects = global.instance.getScannedObjects();
  List<Map<String, dynamic>> selectedObjects = [];
  String seed = "";

  selectRandomObjects(){
    final _random = new Random();
    while(!(selectedObjects.length == selectedNb)){
      var element = objects[_random.nextInt(objects.length)];
      if(!selectedObjects.contains(element)) {
        selectedObjects.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    for(int i = 1; i<=objects.length;++i){
      if(nbQuiz.length<objects.length)
      nbQuiz.add(i);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Génération de quiz"),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Choisissez le nombre de question :',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, ),
              textAlign: TextAlign.center,
            ),
            DropdownButton<int>(
                items: nbQuiz.map((int val) {
                  return new DropdownMenuItem<int>(
                    value: val,
                    child: new Text(val.toString()),
                  );
                }).toList(),
                hint: Text("$selectedNb"),
                onChanged: (newVal) {
                  selectedNb = newVal;
                  setState(() {
                    print('objet selectionne : $selectedNb');
                  });
                }
            ),
            Container(
              padding: EdgeInsets.only(top: 30.0, left: 70, right: 70),
              child : FloatingActionButton.extended(
                heroTag: "btn1",
                icon: Icon(Icons.check),
                label: Text("Commencer"),
                onPressed: () {
                  selectRandomObjects();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPersoScreen(objects : selectedObjects)),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 70, right: 70),
              child : FloatingActionButton.extended(
                heroTag: "btn2",
                icon: Icon(Icons.picture_as_pdf),
                label: Text("Generer un document"),
                onPressed: () {
                  selectRandomObjects();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DocGenScreen(objects: selectedObjects,)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}