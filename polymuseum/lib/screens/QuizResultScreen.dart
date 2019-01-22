import 'package:flutter/material.dart';
import 'package:polymuseum/main.dart';

class QuizResultScreen extends StatelessWidget {

  final int score;
  final int scoreTotal;
  final List<List<String>> wrongAnswers;

  QuizResultScreen({Key key, @required this.score, @required this.scoreTotal, @required this.wrongAnswers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultat du quiz")
      ),
      body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: 
                ListView.builder(
                  itemCount: wrongAnswers.length,
                  itemBuilder: (context, index){
                    return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child : Text('${wrongAnswers[index][0]}'),
                              ),
                            ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child : Text('${wrongAnswers[index][1]}', style: TextStyle(color : Colors.red),),
                              ),
                              Expanded(
                                child: Text('${wrongAnswers[index][2]}',style: TextStyle(color : Colors.green),),
                              )
                            ],
                          ),
                          Text(''),
                        ]
                    );
                  },  
                )
              ),
              Text('Score: $score sur $scoreTotal'),
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