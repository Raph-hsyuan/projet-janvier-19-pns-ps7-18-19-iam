import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';

class Pdf extends StatefulWidget {

  List<Map<String, dynamic>> objects;

  Pdf({Key key, @required this.objects}) : super(key: key);

  @override
  _PdfState createState() => _PdfState(objects : objects);
}

class _PdfState extends State<Pdf> {

  List<String> textAff = [];
  List<Map<String, dynamic>> objects;
  bool enter = false;
  List<String> goodAnswers =[];

  _PdfState({@required this.objects}) : super(){
    for(var o in objects){
      textAff.add(o["question"]["text"]);
      goodAnswers.add(o["question"]["good_answer"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF"),
      ),
      body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  print("Yolo");
                  print(objects.length);
                  print(textAff.length);
                  print(goodAnswers.length);
                  if (textAff.length == objects.length && goodAnswers.length == objects.length) {
                    print("Yolo1");
                    _write();
                  }
                },
                child: Text('Generer un pdf'),
              ),
            ],
        ),
      ),
    );
  }

  requestPermission() async {
    final res = await Permission.requestSinglePermission(PermissionName.Storage);
    print(res);
  }

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    await requestPermission();
    String dir = (await getExternalStorageDirectory()).path;
    return new File('$dir/Test/quiz.txt');
  }

  Future<Null> _write() async {
    print(textAff.length);
    var buffer = new StringBuffer();
    for(String s in textAff) {
      buffer.write(s);
      buffer.write('\n');
    }
    buffer.write('\n');
    for(String s in goodAnswers) {
      buffer.write(s);
      buffer.write('\n');
    }
    await (await _getLocalFile()).writeAsString(buffer.toString());
  }

}


