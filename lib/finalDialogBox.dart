import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:flutter_demo/permissions.dart';

final data = GetStorage();

Future openDialog(context, controller, warning, bool barrier) => showDialog(
      barrierDismissible: barrier,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => WillPopScope(
          onWillPop: () async => barrier,
          child: AlertDialog(
            title: Text('Set New Passcode'),
            content: TextField(
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              controller: controller,
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
                  data.write('code', controller.text);
                  Navigator.of(context).pop(controller.text);
                  controller.clear();
                  successDialog(context);
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter New Password',
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
                    data.write('code', controller.text);
                    Navigator.of(context).pop(controller.text);
                    controller.clear();
                    successDialog(context);
                  }
                },
                child: Text('Set'),
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
          'New Password Set Succesfully',
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

Future warningDialog(context, permit) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Warning',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text(
          'To run this app this permission needs to be granted. Otherwise it will not function,Click Ok to run again permisson tab',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              permit = await askPermission();
              Navigator.of(context).pop(permit);
            },
            child: Text(
              'Ok',
            ),
          ),
        ],
      ),
    );

Future viewPasscodeDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Current Passcode'),
        content: Text(
          'Your Current Passcode is ' + data.read('code'),
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
