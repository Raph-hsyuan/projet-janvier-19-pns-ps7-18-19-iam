import 'package:barcode_scan/barcode_scan.dart';


/** Wrapper permettant d'être indépendant du plugin lisant les QRCode / code-barres */
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
