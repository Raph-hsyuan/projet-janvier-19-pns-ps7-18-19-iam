import 'package:cloud_firestore/cloud_firestore.dart';

class DBHelper {

  static DBHelper _instance;
  static DBHelper get instance => _instance;

  static setInstanceOnce(obj){
    if(_instance == null)
      _instance = obj;
  }

  updateSettings() async {
    await Firestore.instance.settings(
      timestampsInSnapshotsEnabled: true
    );
  }


  ///  PRIVATE METHODS ///

  Future<Map<String, dynamic>> getDocumentInCollectionById(String collectionName, int id) async {
    QuerySnapshot snapshot = await Firestore.instance.collection(collectionName).where("id", isEqualTo: id)
                             .getDocuments().asStream().first;
    if(snapshot.documents.isEmpty) return null;
    return snapshot.documents.first.data;
  }


  /// PUBLIC METHODS ///

  /*

    Pour avoir acccès aux champs des objets renvoyés par DBHelper
    il faut importer le package cloud_firestore. 
    Il ne faut pas utiliser le résultalt d'une fonction async 
    dans un build ça ne marche pas.

    uneFonction() async {
      var doc = await DBHelper.instance.getObject(0);
      doc //map document's key -> value
      var object_name = doc["name"];

      setState((){
        name = object_name;
      });
    }

  */

  Future<Map<String, dynamic>> getObject(int id) async {
    return getDocumentInCollectionById("objects", id);
  }

  Future<Map<String,dynamic>> getExhibition(int id){
    return getDocumentInCollectionById("exhibitions", id);
  }
  
  Future<Map<String, dynamic>> getExhibitionByUUID(String UUID) async {
    var obj = await Firestore.instance.collection("exhibitions").where("UUID", isEqualTo: UUID)
                             .getDocuments().asStream().first;
    return obj.documents.first.data;
  }

  Future<Map<String, dynamic>> getVisit(int id){
    return getDocumentInCollectionById("visits", id);
  }

  
  int addVisit(Set<String> objectsIds) {
    int seed = objectsIds.toString().hashCode;
    Firestore.instance.collection("visits").add({
      "id": seed.toString().hashCode,
      "objects" : objectsIds.toList()
    });
    return seed;
  }  
}
