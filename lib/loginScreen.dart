import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:get_storage/get_storage.dart';
import 'loginDialogBox.dart';
import 'finalScreen.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final data = GetStorage();
  TextEditingController loginController = TextEditingController();
  TextEditingController controller = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  bool incorrectPassword = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    loginController = TextEditingController();
    controller = TextEditingController();
    incorrectPassword = false;
    hasError = false;
    if (data.read('loginCode') == null) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => openDialog(context, false, controller));
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    errorController!.close();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset("assets/image/OTP.gif"),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Pin Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the Login code ",
                      children: [
                        TextSpan(
                            text: " ****",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: true,
                      enablePinAutofill: false,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveColor: Colors.red,
                        inactiveFillColor: Colors.purple,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 500),
                      errorAnimationController: errorController,
                      controller: loginController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onSubmitted: (v) {
                        if (v.length < 4) {
                          setState(() {
                            hasError = true;
                          });
                          errorController?.add(ErrorAnimationType.shake);
                        }
                      },
                      onCompleted: (v) {
                        if (loginController.text == data.read('loginCode')) {
                          //Here we will Navigate to Main Screen.
                          loginController.clear();
                          snackBar('Login Successfull');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      finalScreen(title: 'hi')));
                        } else {
                          setState(() {
                            incorrectPassword = true;
                            Timer(Duration(seconds: 1), () {
                              loginController.clear();
                            });
                          });
                          errorController?.add(ErrorAnimationType.shake);
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                          hasError = false;
                          incorrectPassword = false;
                        });
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: Text(
                  incorrectPassword ? "*Invalid Pin" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't remember the Pin? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      if (data.read('code') != null) {
                        showLoginPin(context, false, controller);
                      }
                    },
                    child: Text(
                      "Click Here",
                      style: TextStyle(
                          color: Color(0xFF91D3B3),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
