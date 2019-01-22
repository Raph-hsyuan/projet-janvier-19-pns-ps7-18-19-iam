// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:polymuseum/screens/GuideScreen.dart';
import 'package:polymuseum/global.dart' as global;
import 'package:polymuseum/sensors/BeaconScanner.dart';
import 'package:polymuseum/sensors/Scanner.dart';
import 'package:polymuseum/sensors/BeaconsTool.dart';
import 'mockups/MockedDBHelper.dart';
import 'package:polymuseum/DBHelper.dart';
import 'mockups/MockedBeaconsTool.dart';
import 'mockups/MockedScanner.dart';


void main() async {


  global.setInstanceOnce(global.DefaultGlobal());


  //MOCKUPS

  DBHelper.setInstanceOnce(MockedDBHelper(
    objects: [{
      "id" : 0,
      "name" : "Chaussure de Zizou",
      "description" : "description",
      "question" : {
        "text": "question",
        "good_answer" : "good_answer"
      }
    }]
  ));
  await DBHelper.instance.updateSettings();

  Scanner.setInstanceOnce(new MockedScanner());
  BeaconsTool.setInstanceOnce(new MockedBeaconsTool());

  setUp((){
    global.instance.clear();
  });

  testWidgets('Scan d\'un objet puis génération d\' une visite', (WidgetTester tester) async {
      

    await tester.pumpWidget(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: GuideScreen()
        );
      })
    );

    await tester.tap(find.text("Scan QR-code"));
    await tester.pumpAndSettle();

    //on mocke la lecture du QR Code sur l'item 0 et la proximité avec les beacons
    (Scanner.instance as MockedScanner).qr_code = "0";
    (BeaconsTool.instance as MockedBeaconsTool).is_position_ok = true;
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text("Générer une visite personnalisé"));
    await tester.pumpAndSettle();

    expect(find.text('Voici votre clé de visite :'), findsOneWidget);

    expect(find.byElementPredicate((element){
        if(!(element.widget is Text)) return false;

        try {
          int visit_seed = int.parse((element.widget as Text).data);
        }catch(e){
          return false;
        }

        return true;
    }), findsOneWidget);

  });


 testWidgets('génération d\' une visite sans scan préalable', (WidgetTester tester) async {
      

    await tester.pumpWidget(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: GuideScreen()
        );
      })
    );


    await tester.tap(find.text("Générer une visite personnalisé"));
    await tester.pumpAndSettle();

    expect(find.text('Scanner des objets pour pouvoir créer une visite'), findsOneWidget);

  });
}




