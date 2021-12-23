import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';

final data = GetStorage();

Future openDialog(context, bool warning, controller) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(
              'Set Password',
            ),
            content: TextField(
              obscureText: true,
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 4,
              onChanged: (v) {
                setState(() {
                  warning = false;
                });
              },
              onSubmitted: (_) {
                if (controller.text.length != 4) {
                  setState(() {
                    warning = true;
                    Timer(Duration(seconds: 1), () {
                      controller.clear();
                    });
                  });
                } else {
                  setState(() {
                    warning = false;
                  });
                  data.write('loginCode', controller.text);
                  Navigator.of(context).pop(controller.text);
                  controller.clear();
                  successDialog(context);
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter Your Password',
                errorText: warning ? 'Please enter password of 4 digits' : null,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (controller.text.length != 4) {
                    setState(() {
                      warning = true;
                      Timer(Duration(seconds: 1), () {
                        controller.clear();
                      });
                    });
                  } else {
                    setState(() {
                      warning = false;
                    });
                    data.write('loginCode', controller.text);
                    Navigator.of(context).pop(controller.text);
                    controller.clear();
                    successDialog(context);
                  }
                },
                child: Text(
                  'Set',
                ),
              ),
            ],
          ),
        ),
      ),
    );

Future successDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Successfull'),
        content: Text(
          'Login Password Set Successfully',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Ok',
            ),
          ),
        ],
      ),
    );

Future showLoginPin(context, bool warning, controller) => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Enter PassCode',
          ),
          content: TextField(
            obscureText: true,
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 4,
            onChanged: (v) {
              setState(() {
                warning = false;
              });
            },
            onSubmitted: (_) {
              if (controller.text.length != 4 || controller.text!=data.read('code')) {
                setState(() {
                  warning = true;
                  Timer(Duration(seconds: 1), () {
                    controller.clear();
                  });
                });
              } else if (controller.text == data.read('code')) {
                setState(() {
                  warning = false;
                });
                Navigator.of(context).pop(controller.text);
                controller.clear();
                viewLoginCodeDialog(context);
                //Here we will show loginCode dialog
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter Your Passcode',
              errorText: warning ? 'Please enter passcode of 4 digits' : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.length != 4 || controller.text!=data.read('code')) {
                  setState(() {
                    warning = true;
                    Timer(Duration(seconds: 1), () {
                      controller.clear();
                    });
                  });
                } else if (controller.text == data.read('code')) {
                  setState(() {
                    warning = false;
                  });
                  Navigator.of(context).pop(controller.text);
                  controller.clear();
                  viewLoginCodeDialog(context);
                  //Here we will show loginCode dialog
                }
              },
              child: Text(
                'Ok',
              ),
            ),
          ],
        ),
      ),
    );

Future viewLoginCodeDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Code'),
        content: Text(
          'Your Login Code is ' + data.read('loginCode'),
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Ok',
            ),
          ),
        ],
      ),
    );
