import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';


class QrScreen extends StatefulWidget {
  @override
  QrScreenState createState() {
    return new QrScreenState();
  }
}

class QrScreenState extends State<QrScreen> {
  String result = "Appuyer sur le bouton pour en savoir plus sur un objet";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
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
    BindResultToDB(result);
  }

  void BindResultToDB(String id){
    //temporary solution before the DB is set up
    if(id == "1") {
      result = "La Coupe du monde de football de 1998 est la seizième édition de la Coupe du monde de football et se déroule en France du 10 juin au 12 juillet 1998. C'est la seconde fois que la France organise la coupe du monde après 1938. Il s'agit du premier Mondial à trente-deux équipes participantes. L'équipe hôte entraînée par Aimé Jacquet et emmenée par Didier Deschamps remporte son premier titre planétaire en battant le Brésil en finale 3 buts à 0, le 12 juillet 1998 au stade de France. ";
    }
    if(id == "2") {
      result = "La Coupe du monde de football de 1998 est la seizième édition de la Coupe du monde de football et se déroule en France du 10 juin au 12 juillet 1998. C'est la seconde fois que la France organise la coupe du monde après 1938. Il s'agit du premier Mondial à trente-deux équipes participantes. L'équipe hôte entraînée par Aimé Jacquet et emmenée par Didier Deschamps remporte son premier titre planétaire en battant le Brésil en finale 3 buts à 0, le 12 juillet 1998 au stade de France. ";
    }
    else{
      result = "Le qr code ne correspond pas à un objet du musée";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Center(
        child: Text(
          result,
          style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}