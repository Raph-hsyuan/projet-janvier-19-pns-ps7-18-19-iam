import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:polymuseum/DBHelper.dart';

class Pdf extends StatefulWidget {

  List<String> objectsIds;

  Pdf({Key key, @required this.objectsIds}) : super(key: key);

  @override
  _PdfState createState() => _PdfState(objectsIds : objectsIds);
}

class _PdfState extends State<Pdf> {

  List<String> textAff = [];
  final List<String> objectsIds;
  bool enter = false;
  List<String> goodAnswers =[];

  _PdfState({@required this.objectsIds}) : super();

  @override
  Widget build(BuildContext context) {
    if(!enter) {
      getQuestions(objectsIds);
      enter = !enter;
    }
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
                  print(objectsIds.length);
                  print(textAff.length);
                  print(goodAnswers.length);
                  if (textAff.length == objectsIds.length && goodAnswers.length == objectsIds.length) {
                    print("Yolo1");
                    pdf();
                  }
                },
                child: Text('Generer un pdf'),
              ),
            ],
        ),
      ),
    );
  }

  void getQuestions(List<String> id) async {
    for(String i in id) {
      print("Id :$i");
      var text = await DBHelper.instance.getObject(int.parse(i));
      setState(() {
        try {
          textAff.add(text.data["question"]["text"]);
          goodAnswers.add(text.data["question"]["good_answer"]);
        }catch(e){
          print("Dommage");
        }
      });
    }
  }
}


void pdf() {
  final pdf = new PDFDocument();
  final page = new PDFPage(pdf, pageFormat: PDFPageFormat.letter);
  final g = page.getGraphics();
  final font = new PDFFont(pdf);

  g.setColor(new PDFColor(0.0, 1.0, 1.0));
  g.drawRect(50.0, 30.0, 100.0, 50.0);
  g.fillPath();

  g.setColor(new PDFColor(0.3, 0.3, 0.3));
  g.drawString(font, 12.0, "Hello World!", 5.0 * PDFPageFormat.mm, 300.0);

  var file = new File('file.pdf');
  file.writeAsBytesSync(pdf.save());

  print("Yolo2");
}
