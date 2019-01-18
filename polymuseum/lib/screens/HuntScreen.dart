import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:polymuseum/DBHelper.dart';
import 'package:polymuseum/screens/QrScreen.dart';
import 'package:polymuseum/sensors/Scanner.dart';

class HuntScreen extends StatefulWidget {


  HuntScreen({Key key}) : super(key: key);

  @override
  _HuntScreen createState() => _HuntScreen();
}
class _HuntScreen extends State<HuntScreen> {

 String textAff = "Chargement";
 String textAff2 = "Chargement";
 bool check = false;
 bool show = false;
 String result = "Chargement";

  _HuntScreen() : super() {
    getExhibDescription();
    getObjectDescription();
  }

  @override
  Widget build(BuildContext context) {
    print(textAff);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chasse aux trésors"),
      ),
      body: Center(
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: <Widget>[
              !check ? Container(
                child: AutoSizeText(
                  "Chercher l'exposition correspondant a la description suivante :",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ): new Container(),
              !check ? Container(
                padding: EdgeInsets.all(30.0),
                child: AutoSizeText(
                textAff,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ): new Container(),
              !check ? RaisedButton(
                child: Text('Verifier'),
                onPressed: () {
                  checkPresence();
                },
              ): new Container(),
              check ? Container(
                child: AutoSizeText(
                  "Maintenant trouver l'objet correspondant a la description suivante :",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ): new Container(),
              check ? Container(
                padding: EdgeInsets.all(30.0),
                child: AutoSizeText(
                  textAff2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ): new Container(),
              check ? Container(
                padding: EdgeInsets.only(top: 30.0),
                child : FloatingActionButton.extended(
                heroTag: "btn2",

                icon: Icon(Icons.camera_alt),
                label: Text("Scan"),
                onPressed: _scanQR,
                ),
                ): new Container(),
              show ? Container(
                padding: EdgeInsets.all(30.0),
                child: AutoSizeText(
                  result,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ): new Container(),
              show ? RaisedButton(
                child: Text('Retour'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ): new Container(),
            ]
        ),
      ),
    );
  }

  Future getExhibDescription() async {
    try {
      var desc = await DBHelper.instance.getExhibition(3);
      setState(() {
        if(desc!=null){
          textAff = desc["beacons"][0]["description"];
        }});
    }catch(e){
        print(e);
    }
  }
 Future getObjectDescription() async {
   try {
     var desc = await DBHelper.instance.getObject(1);
     setState(() {
       if(desc!=null){
         textAff2 = desc["description"];
       }});
   }catch(e){
     print(e);
   }
 }

  void checkPresence() async{
    print("enter");
    try {
      bool b = false;
      for(int i=0; i<100; i++){
        if(!b)
          b = await beaconsTool.checkPosition(1);
        else
          break;
      }
      setState(() {
        check = b;
        print(check);
      });
    }catch (e){
      print(e);
    }
  }

 Future _scanQR() async {
   try {
     String qrResult = await Scanner.instance.scan();

     int intId = int.parse(qrResult);

     bool checking = false;
     for(int i=0; i<100; i++){
       if(!checking)
         checking = await beaconsTool.checkPosition(1);
       else
         break;
     }
     if(!checking){
       setState(() {
         result = "Vous devez aller plus proche !";
       });
       return;
     }

     setState(() {
       if(intId == 1){
         result = "Bravo";
         check = false;
         show = true;
       }});

   } catch (ex) {
    print(ex);
   }
 }

}