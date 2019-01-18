import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class NFCScanner {

  static NFCScanner _instance;
  static NFCScanner get instance => _instance; 

  static setInstanceOnce(NFCScanner obj){
    if(_instance == null)
      _instance = obj;
  }

  Future<String> read() async {
    return await FlutterNfcReader.read;
  }

  Future<bool> stop() async {
    return await FlutterNfcReader.stop;
  }

}