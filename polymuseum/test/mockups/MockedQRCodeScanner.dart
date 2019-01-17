import 'package:polymuseum/sensors/Scanner.dart';

class MockedQRCodeScanner extends Scanner {

  static String code = "0";

  @override
  Future<String> scan() {
    return Future.value(MockedQRCodeScanner.code);
  }

}