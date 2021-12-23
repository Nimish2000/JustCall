import 'package:get_storage/get_storage.dart';

class passwordValidation {
  final data = GetStorage();

  bool passwordChecker(String recievedMessage) {
    String checkPassword = '';
    for (int i = 0; i < 4; i++) {
      checkPassword += recievedMessage[i];
    }
    if (checkPassword == data.read('code')) {
      return true;
    }
    return false;
  }
}
