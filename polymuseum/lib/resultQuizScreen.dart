import 'package:flutter/material.dart';
import 'package:polymuseum/main.dart';

class ResultQuizScreen extends StatelessWidget {

  final int score;
  final int scoreTotal;

  ResultQuizScreen({Key key, @required this.score, @required this.scoreTotal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultat du quiz"),
      ),
      body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$score'),
              Text('Sur'),
              Text('$scoreTotal'),
              Text(''),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FirstScreen()),
                  );
                },
                child: Text('Retour a l accueil'),
              ),
            ]
        )
      ),
    );
  }
}