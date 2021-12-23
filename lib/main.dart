import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/getContactName.dart';
import 'package:telephony/telephony.dart';
import 'getContactNumberByName.dart';
import 'package:get_storage/get_storage.dart';
import 'passwordValidation.dart';
import 'sendMessage.dart';
import 'loginScreen.dart';
import 'permissions.dart';

_MyAppState backMessage = _MyAppState();

onBackgroundMessage(SmsMessage message) {
  backMessage.onMessage(message);
}

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final data = GetStorage();
  passwordValidation passwordValidator = passwordValidation();
  getContactNumber contactNumber = getContactNumber();
  getContactName messageName = getContactName();
  sendMessage send = sendMessage();
  final Telephony telephony = Telephony.instance;
  var _message = '';

  Future<void> initPlatformState() async {
    telephony.listenIncomingSms(
      onNewMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
    );
  }

  onMessage(SmsMessage message) async {
    var senderNumber;
    var recievedMessage = message.body;
    senderNumber = message.address;
    if (recievedMessage != null &&
        passwordValidator.passwordChecker(recievedMessage) &&
        recievedMessage.length > 5) {
      _message = messageName.getName(recievedMessage);
      var sendNumber = await contactNumber.getContactNumberByName(_message);
      if (sendNumber != null) {
        send.sendSMS(sendNumber, senderNumber);
      }
    }
  }

  @override
  void initState() {
    askPermission();
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JustCall',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loginScreen(),
    );
  }
}
