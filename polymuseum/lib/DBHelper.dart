import 'package:cloud_firestore/cloud_firestore.dart';

class DBHelper {

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
