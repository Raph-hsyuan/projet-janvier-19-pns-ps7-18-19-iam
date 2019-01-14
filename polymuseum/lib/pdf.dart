import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';

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
