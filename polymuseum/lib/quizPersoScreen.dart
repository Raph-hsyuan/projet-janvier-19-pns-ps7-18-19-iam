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
    _QuizPersoScreen({@required this.objectsIds}) : super();

  @override
  Widget build(BuildContext context) {
    if(!enter) {
      getQuestions(objectsIds);
      enter = !enter;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz personnalise"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: objectsIds.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${textAff[index]}'),
            );
          },
        ),
     ),
    );
  }

  void getQuestions(List<String> id) async {
    for(String i in id) {
      var text = await DBHelper.instance.getObject(int.parse(i));
      setState(() {
        textAff.add(text.data["question"]["text"]);
      });
    }
  }

}