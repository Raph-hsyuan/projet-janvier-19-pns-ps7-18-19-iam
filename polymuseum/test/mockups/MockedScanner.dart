import 'package:polymuseum/sensors/Scanner.dart';

class MockedScanner extends Scanner {

  static create(){
    return MockedScanner();
  }

  String qr_code;

  //OVERRIDES

  @override
  Future<String> scan() async {
    return qr_code;
  }

}