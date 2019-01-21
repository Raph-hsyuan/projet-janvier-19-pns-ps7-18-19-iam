import 'package:polymuseum/sensors/Scanner.dart';

class MockedScanner extends Scanner {

  static create(){
    return MockedScanner();
  }

  String _val;

  set val (String val){
    _val = val;
  }

  //OVERRIDES

  @override
  Future<String> scan() async {
    return _val;
  }

}