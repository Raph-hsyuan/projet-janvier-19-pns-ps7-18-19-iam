var instance = new Global();

class Global {

  Global();

  int _seed = -1;
  Map<String, Map<String, dynamic>> _scannedObjects = new Map();
  Map<String, Map<String, dynamic>> _checkListObjects = new Map();

  get seed => _seed;
  get checkListObjects => _checkListObjects.values.toList();
  get checkListObjectsCount => _checkListObjects.length;

  addScannedObject(Map<String, dynamic> obj){
    _scannedObjects[obj["id"].toString()] = obj;

    _checkListObjects.remove(obj["id"]);
    if(_checkListObjects.isEmpty) _seed = -1;
  }

  List<Map<String, dynamic>> getScannedObjects({List<String> ids}){
    if(ids == null) return _scannedObjects.values.toList();

    return _scannedObjects.values.where((obj){
      return ids.contains(obj["id"]);
    }).toList();
  }

  addCheckListObject(Map<String, dynamic> obj){
    _checkListObjects[obj["id"].toString()] = obj;
  }

  removeCheckListObject(Map<String, dynamic> obj){
    return _checkListObjects.remove(obj["id"]);
  }

  initCheckList(){
    _seed = 0;
    _checkListObjects.clear();
  }

}
enum Permission {
  // Microphone
  RecordAudio,

  // Camera
  Camera,

  // Read External Storage (Android)
  ReadExternalStorage,

  // Write External Storage (Android)
  WriteExternalStorage,

  // Access Coarse Location (Android) / When In Use iOS
  AccessCoarseLocation,

  // Access Fine Location (Android) / When In Use iOS
  AccessFineLocation,

  // Access Fine Location (Android) / When In Use iOS
  WhenInUseLocation,

  // Access Fine Location (Android) / Always Location iOS
  AlwaysLocation,

  // Write contacts (Android) / Contacts iOS
  WriteContacts,

  // Read contacts (Android) / Contacts iOS
  ReadContacts,
}
