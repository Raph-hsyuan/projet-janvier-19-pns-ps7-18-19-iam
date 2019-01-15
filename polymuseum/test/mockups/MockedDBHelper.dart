import 'package:polymuseum/DBHelper.dart';

class MockedDBHelper extends DBHelper {

  @override
  static void updateSettings() async {}

  dynamic _description;
  
  MockedDBHelper(dynamic description){
    _description = description;
  }

  @override
  Future<DocumentSnapshot> getObject(int id) {
      // TODO: implement getObject
      return super.getObject(id);
    }


}