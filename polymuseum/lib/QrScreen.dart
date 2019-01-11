import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'DBHelper.dart';

import 'package:auto_size_text/auto_size_text.dart';

DBHelper dbHelper = new DBHelper();

class QrScreen extends StatefulWidget {
  @override
  QrScreenState createState() {
    return new QrScreenState();
  }
}

class QrScreenState extends State<QrScreen> {
  String result = "Appuyer sur le bouton pour en savoir plus sur un objet";
  String description =" ";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
        result = "Chargement en cours...";
      int intId = int.parse(qrResult);
      var o = await dbHelper.getObject(intId);
      setState(() {
        result = o.data["name"].toString();
        description = o.data["description"].toString();
      });
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
            ),),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: AutoSizeText(
              description,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20), 
              )
            ),
        Container(
        padding: EdgeInsets.only(top: 30.0),
        child : FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
        )
          ]
        )
      )
    );
  }
  } 