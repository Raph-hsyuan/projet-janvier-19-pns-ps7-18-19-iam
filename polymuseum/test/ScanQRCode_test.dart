// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:polymuseum/main.dart';
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

  testWidgets('Scan valide d\'un objet et réponse à sa question.', (WidgetTester tester) async {
      

    await tester.pumpWidget(
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: FirstScreen()
        );
      })
    );



    await tester.tap(find.text("Visiteur"));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Scan QR-code"));
    await tester.pumpAndSettle();

    //on mocke la lecture du QR Code sur l'item 0 et la proximité avec les beacons
    (Scanner.instance as MockedScanner).qr_code = "0";
    (BeaconsTool.instance as MockedBeaconsTool).is_position_ok = true;
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    //on vérifique que la description de l'objet est bien apparue
    expect(find.text("Chaussure de Zizou"), findsWidgets);


    //On vérifie que le bouton de scan est toujours là
    var scan_button_finder = find.byElementPredicate((element){
      return (element.widget is Text 
              && element.toString().contains("Scan")
              && element.ancestorWidgetOfExactType(FloatingActionButton) != null
              );
    });

    expect(scan_button_finder, findsOneWidget);

    //On vérifie que le bouton Question est apparu puisqu'on a scanné un objet
    var question_button_finder = find.byElementPredicate((element){
      return (element.widget is Text 
              && element.toString().contains("Question")
              && element.ancestorWidgetOfExactType(FloatingActionButton) != null
              );
    });

    expect(question_button_finder, findsOneWidget);


    //on vérifie qu'on peut répondre à la question et que la justesse de notre réponse s'affiche.
    await tester.tap(question_button_finder);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField),  "good_answer");
    await tester.tap(find.text("Valider"));
    await tester.pumpAndSettle();
    expect(find.text("BONNE REPONSE"), findsOneWidget);


  });


}




