import 'package:telephony/telephony.dart';

class sendMessage {
  final Telephony telephony = Telephony.instance;

  void sendSMS(String number, String senderNumber) {
    try {
      telephony.sendSms(
        to: senderNumber,
        message: number,
      );
    } catch (e) {
     //Here Message Failed due to some reason
    }
  }
}
