import 'package:flutter/material.dart';
import 'package:polymuseum/DBHelper.dart';

class QuizPersoScreen extends StatefulWidget {

  final List<String> objectsIds;

  QuizPersoScreen({Key key, @required this.objectsIds}) : super(key: key);

  @override
  _QuizPersoScreen createState() => _QuizPersoScreen(objectsIds : objectsIds);
}
  class _QuizPersoScreen extends State<QuizPersoScreen> {

    final List<String> textAff = [];
    final List<String> objectsIds;
    bool enter = false;
    List<String> answers = [];
    List<String> goodAnswers =[];
    int score = 0;
    int scoreTotal = 0;
    final myController = TextEditingController();

    _QuizPersoScreen({@required this.objectsIds}) : super();

  @override
  Widget build(BuildContext context) {
    myController.addListener(registerAns);
    if(!enter) {
      getQuestions(objectsIds);
      enter = !enter;
    }
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
                  itemCount: objectsIds.length,
                  itemBuilder: (context, index) {
                    if(textAff.isNotEmpty) {
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
                                    controller: myController,
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
              },
            ),
          ]
        ),
     ),
    );
  }

  void getQuestions(List<String> id) async {
    for(String i in id) {
      var text = await DBHelper.instance.getObject(int.parse(i));
      setState(() {
        textAff.add(text.data["question"]["text"]);
        goodAnswers.add(text.data["question"]["good_answer"]);
      });
    }
  }

  void checkAnswers() async{
    print('Valider');
    print(answers);
    for(int  i=0; i<answers.length;++i){
      if(answers[i] == goodAnswers[i])
        score = score + 10;
    }
    scoreTotal = 10 * objectsIds.length;
    print(score);
    print(scoreTotal);
  }

    void registerAns() {
      answers.add(myController.text);
    }

}