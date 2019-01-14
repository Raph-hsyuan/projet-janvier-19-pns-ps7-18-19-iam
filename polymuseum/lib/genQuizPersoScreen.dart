import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polymuseum/genVisitScreen.dart';
import 'package:polymuseum/pdf.dart';
import 'package:polymuseum/quizPersoScreen.dart';
import 'package:polymuseum/global.dart' as global;

class GenQuizPersoScreen extends StatefulWidget {

  GenQuizPersoScreen({Key key}) : super(key: key);

  @override
  _GenQuizPersoScreenState createState() => _GenQuizPersoScreenState();

}

class _GenQuizPersoScreenState extends State<GenQuizPersoScreen> {

  List<int> nbQuiz = [];
  int selectedNb = 1;
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
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
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
            RaisedButton(
              child: Text('Commencer'),
              onPressed: () {
                selectRandomObjects();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPersoScreen(objects : selectedObjects)),
                );
              },
            ),
            RaisedButton(
              child: Text('Generer un pdf'),
              onPressed: () {
                selectRandomObjects();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pdf(objects: selectedObjects,)),
                );
              },
            ),
            RaisedButton(
              child: Text('Generer une visite'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenVisitScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}