import 'package:cloud_firestore/cloud_firestore.dart';

class DBHelper {

  static DBHelper _instance;
  static DBHelper get instance => _instance;

  static setInstanceOnce(obj){
    if(_instance == null)
      _instance = obj;
  }

  static updateSettings() async {
    await Firestore.instance.settings(
      timestampsInSnapshotsEnabled: true
    );
  }


  ///  PRIVATE METHODS ///

  Future<DocumentSnapshot> _getDocumentInCollectionById(String collectionName, int id) async {
    QuerySnapshot snapshot = await Firestore.instance.collection(collectionName).where("id", isEqualTo: id)
                             .getDocuments().asStream().first;
    if(snapshot.documents.isEmpty) return null;
    return snapshot.documents.first;
  }

  Future<bool> _isDocumentInCollection(String collectionName, int id) async {
    var querySnapshot = await Firestore.instance.collection(collectionName).where("id", isEqualTo: id)
                            .getDocuments();
    return querySnapshot.documents.isNotEmpty;
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
    return _getDocumentInCollectionById("objects", id);
  }

  Future<DocumentSnapshot> getExhibition(int id){
    return _getDocumentInCollectionById("exhibitions", id);
  }
  
  Future<DocumentSnapshot> getExhibitionByUUID(String UUID) async {
    var obj = await Firestore.instance.collection("exhibitions").where("UUID", isEqualTo: UUID)
                             .getDocuments().asStream().first;
    return obj.documents.first;
  }

  Future<DocumentSnapshot> getVisit(int id){
    return _getDocumentInCollectionById("visits", id);
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
