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
        child: ListView.builder(
          itemCount: objectsIds.length,
          itemBuilder: (context, index) {
            return ListTile( 
              title: Text('${objectsIds[index]}'),
            );
          },
        ),
     ),
    );
  }
}