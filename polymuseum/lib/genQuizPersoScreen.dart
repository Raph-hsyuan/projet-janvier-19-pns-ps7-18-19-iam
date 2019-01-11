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
  List<String> objectsIds = global.objectsIds;
  List<String> objectsIdsBuffer;
  List<String> selectedObjectsIds = [];
  String seed = "";


  @override
  Widget build(BuildContext context) {
    for(int i = 1; i<=objectsIds.length;++i){
      if(nbQuiz.length<objectsIds.length)
      nbQuiz.add(i);
    }
    objectsIdsBuffer = objectsIds;
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
                final _random = new Random();
                while(!(selectedObjectsIds.length == selectedNb)){
                  String element = objectsIdsBuffer[_random.nextInt(objectsIdsBuffer.length)];
                  if(!selectedObjectsIds.contains(element)) {
                    selectedObjectsIds.add(element);
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPersoScreen(objectsIds : selectedObjectsIds)),
                );
              },
            ),
            RaisedButton(
              child: Text('Generer un pdf'),
              onPressed: () {
                final _random = new Random();
                while(!(selectedObjectsIds.length == selectedNb)){
                  String element = objectsIdsBuffer[_random.nextInt(objectsIdsBuffer.length)];
                  if(!selectedObjectsIds.contains(element)) {
                    selectedObjectsIds.add(element);
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pdf()),
                );
              },
            ),
            RaisedButton(
              child: Text('Generer une visite'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GenVisitScreen(objectsIds : objectsIds)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}