// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:screen_capture_utils/screen_capture_utils.dart';

class BlockScreen extends StatefulWidget {
  @override
  _BlockScreenState createState() => _BlockScreenState();
}

class _BlockScreenState extends State<BlockScreen> {
  String path = 'Unknown';
  bool guarding = true;
  late ScreenCaptureUtils screenCaptureUtils;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      screenCaptureUtils = ScreenCaptureUtils(
        onScreenCaptured: (_) {
          print('Captured: $_');
        },
        isGuarding: (val) {
          setState(() {
            guarding = val;
          });
        },
        onScreenCapturedWithDeniedPermission: () {
          var msg = 'onScreenCapturedWithDeniedPermission';
          print('$msg');
          setState(() {
            path = msg;
          });
        },
      )..intialize();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(path),
              SizedBox(
                height: 40,
              ),
              guarding == false
                  ? CupertinoButton.filled(
                      onPressed: () {
                        /// Guard Screen
                        screenCaptureUtils.guard();
                      },
                      child: Text('Guard'),
                    )
                  : CupertinoButton.filled(
                      onPressed: () {
                        /// Unguard Screen
                        screenCaptureUtils.unGuard();
                      },
                      child: Text('UnGuard'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
