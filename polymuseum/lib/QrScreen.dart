import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'DBHelper.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/BeaconsTool.dart';


import 'package:auto_size_text/auto_size_text.dart';

DBHelper dbHelper = DBHelper.instance;
BeaconsTool beaconsTool = new BeaconsTool();

class QrScreen extends StatefulWidget {
  @override
  QrScreenState createState() {
    return new QrScreenState();
  }
}

class QrScreenState extends State<QrScreen> {
  String result = "Appuyer sur le bouton pour en savoir plus sur un objet";
  String description =" ";
  String question = " ";
  String answer = " ";
  bool _question = false;
  bool _show = false;

  final questionController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    questionController.dispose();
    super.dispose();
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
        result = "Chargement en cours...";
      int intId = int.parse(qrResult);
      var o = await dbHelper.getObject(intId);

      bool check = await beaconsTool.checkPosition(intId);
      if(!check){
          setState(() {
          result = "Vous devez aller plus proche !";
        });
        return;
      }

      setState(() {
        result = o.data["name"].toString();
        description = o.data["description"].toString();
        question = o.data["question"]["text"];
        answer = o.data["question"]["good_answer"];
        _question = true;
      });

      global.instance.addScannedObject(o.data);

    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "L'application n'a pas la permission d'utiliser la caméra du téléphone";
        });
      } else {
        setState(() {
          result = "Une erreur est survenue $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "Vous n'avez rien scanné";
      });
    } catch (ex) {
      setState(() {
          result = "Une erreur est survenue $ex";
      });
    }
  }

  void _showQuestion(){
    setState(() {
      if (_show) {
        _show = false;
        _question = true;
      } else {
        _show = true;
       _question = false;

      }
  });
  }

   Widget _validateQuestion(){
     if(Text(questionController.text).data==answer){
        showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("BONNE REPONSE"),
          content: new Text("BRAVO"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      );
     }else {
       showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("MAUVAISE REPONSE"),
          content: new Text("réessayer"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      );
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child:ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: <Widget>[
              Container( 
                padding: EdgeInsets.only(top: 0.0),
                child : AutoSizeText(
                  result,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: AutoSizeText(
              description,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20), 
              )
            ),
        
           _show ? Container(
            child : Text(question),
          ) : new Container(),
          _show ? Container(
            child : TextField(
              controller: questionController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Votre Réponse'
              ),
            ),
          ) : new Container(),
          _question ? Container(
        padding: EdgeInsets.only(top: 30.0),
        child : FloatingActionButton.extended(
        heroTag: "btn1",
        icon: Icon(Icons.help_outline),
        label: Text("Question"),
        onPressed: _showQuestion,
      ),
        ) : new Container(),
!_question ? Container(
        padding: EdgeInsets.only(top: 30.0),
        child : FloatingActionButton.extended(
        heroTag: "btn3",
        icon: Icon(Icons.help_outline),
        label: Text("Valider"),
        onPressed:_validateQuestion,
      ),
        ) : new Container(),

        Container(
        padding: EdgeInsets.only(top: 30.0),
        child : FloatingActionButton.extended(
                        heroTag: "btn2",

        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
        ),
        
            ]
        )
      )
    );
  }
  } 