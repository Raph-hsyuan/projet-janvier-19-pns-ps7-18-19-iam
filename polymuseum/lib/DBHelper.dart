import 'package:cloud_firestore/cloud_firestore.dart';

class DBHelper {

  static DBHelper instance = new DBHelper();

  static updateSettings() async {
    await Firestore.instance.settings(
      timestampsInSnapshotsEnabled: true
    );
  }


  ///  PRIVATE METHODS ///

  Future<DocumentSnapshot> _getDocumentInCollection(String collectionName, int id) async {
    var obj = await Firestore.instance.collection(collectionName).where("id", isEqualTo: id)
                             .getDocuments().asStream().first;
    return obj.documents.first;
  }


  /// PUBLIC METHODS ///

  /*

    Pour avoir acccès aux champs des objets renvoyés par DBHelper
    il faut importer le package cloud_firestore. 
    Il ne faut pas utiliser le résultalt d'une fonction async 
    dans un build ça ne marche pas.

    uneFonction() async {
      var doc = await DBHelper.instance.getObject(0);
      doc.data //map document's key -> value
      var object_name = doc.data["name"]);

      setState((){
        name = object_name;
      });
    }

  */

  Future<DocumentSnapshot> getObject(int id){
    return _getDocumentInCollection("objects", id);
  }

  Future<DocumentSnapshot> getExhibition(int id){
    return _getDocumentInCollection("exhibitions", id);
  }

  Future<DocumentSnapshot> getVisit(int id){
    return _getDocumentInCollection("visits", id);
  }

  Future<DocumentReference> addVisit(int seed, List<int> objectsIds) async {
    return Firestore.instance.collection("visits").add({
      "seed": seed,
      "objects": objectsIds
    });
  }

}
