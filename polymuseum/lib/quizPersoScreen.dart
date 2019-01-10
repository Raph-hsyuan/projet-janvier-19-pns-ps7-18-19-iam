import 'package:flutter/material.dart';

class QuizPersoScreen extends StatelessWidget {

  final List<String> objectsIds;
  QuizPersoScreen({Key key, @required this.objectsIds}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(objectsIds.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz personnalise"),
      ),
      body: Center(
        child: Text(
          '127736',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}