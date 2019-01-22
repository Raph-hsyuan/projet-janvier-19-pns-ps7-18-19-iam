import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

bool _isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

class NFCScanner {
  static NFCScanner _instance;
  static NFCScanner get instance => _instance;

  static setInstanceOnce(NFCScanner obj) {
    if (_instance == null) _instance = obj;
  }

  Future<String> read() async {
    String result = await FlutterNfcReader.read;
    var id = "";
    for (var i = 0; i < result.length; i++) {
      if (_isNumeric(result[i])) id += result[i];
    }
    return id;
  }

  Future<bool> stop() async {
    return await FlutterNfcReader.stop;
  }
}
