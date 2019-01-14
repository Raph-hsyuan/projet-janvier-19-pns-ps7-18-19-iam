import 'package:flutter/material.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/resultQuizScreen.dart';

class QuizPersoScreen extends StatefulWidget {

  final List<Map<String, dynamic>> objects;

  QuizPersoScreen({Key key, @required this.objects}) : super(key: key);

  @override
  _QuizPersoScreen createState() => _QuizPersoScreen(objects : objects);
}
  class _QuizPersoScreen extends State<QuizPersoScreen> {

    final List<String> textAff = [];
    final List<Map<String, dynamic>> objects;
    bool enter = false;
    List<String> answers = [];
    List<String> goodAnswers =[];
    int score = 0;
    int scoreTotal = 0;
    final myController = TextEditingController();

    _QuizPersoScreen({@required this.objects}) : super() {
      for(var o in objects){
        textAff.add(o["question"]["text"]);
        goodAnswers.add(o["question"]["good_answer"]);
      }
    }

  @override
  Widget build(BuildContext context) {
    myController.addListener(registerAns);
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz personnalise"),
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child:
                ListView.builder(
                  itemCount: objects.length,
                  itemBuilder: (context, index) {
                    if(textAff.length==objects.length) {
                      print(index);
                      return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child : Text('${textAff[index]}'),
                                ),
                                Expanded(
                                  child : TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Votre Réponse'
                                    ),
                                    //controller: myController,
                                    onChanged: (text) {
                                      answers.add(text);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text(''),
                          ]
                      );
                    }else{
                      return ListTile(
                        title: Text('Chargement des questions'),
                      );
                    }
                  },
                ),
            ),
            RaisedButton(
              child: Text('Valider'),
              onPressed: () {
                checkAnswers();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultQuizScreen(score : score, scoreTotal : scoreTotal)),
                );
              },
            ),
          ]
        ),
     ),
    );
  }


  void checkAnswers(){
    print('Valider');
    print(answers);
    for(int  i=0; i<goodAnswers.length;++i){
      if(answers.contains(goodAnswers[i]))
        score = score + 10;
    }
    scoreTotal = 10 * objects.length;
    print(score);
    print(scoreTotal);
  }

    void registerAns() {
      answers.add(myController.text);
    }

}