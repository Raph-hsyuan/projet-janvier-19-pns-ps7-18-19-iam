import 'package:barcode_scan/barcode_scan.dart';

class Scanner {
  static Scanner _instance;
  static Scanner get instance => _instance;

  static setInstanceOnce(Scanner obj) {
    if (_instance == null) _instance = obj;
  }

  Future<String> scan() {
    return BarcodeScanner.scan();
  }

  String CameraAccessDenied() {
    return BarcodeScanner.CameraAccessDenied;
  }
}
