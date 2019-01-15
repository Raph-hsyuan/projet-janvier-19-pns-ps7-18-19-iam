import 'package:polymuseum/DBHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockedDBHelper {

  @override
  static void updateSettings() async {}

  Map<String, List<Map<String, dynamic>>>  _description;
  
  MockedDBHelper({
    List<Map<String, dynamic>> visits,
    List<Map<String, dynamic>> exhibitions,
    List<Map<String, dynamic>> objects
  }){
    _description = {
      "visits": visits,
      "objects": objects,
      "exhibitions": exhibitions
    };
  }

  @override
  Future<Map<String, dynamic>> _getDocumentInCollectionById(String collectionName, int id) {
    var coll = _description[collectionName];
    var docs = coll.where((o) => o["id"] == id);
    if(docs.isEmpty) return null;
    return Future.value(docs.first);
  }
  
  @override
  Future<Map<String, dynamic>> getExhibitionByUUID(String UUID) {
    var docs = _description["exhibitions"];
    List<Map<String, dynamic>> lst = docs.where((o) => o["UUID"] == UUID).toList();
    return Future.value(lst.first);
  }

}