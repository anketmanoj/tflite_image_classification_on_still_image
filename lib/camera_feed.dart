// ignore_for_file: prefer_const_constructors

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_picker/block_screenshot.dart';
import 'package:flutter_image_picker/main.dart';

class CameraFeedPage extends StatefulWidget {
  const CameraFeedPage({Key? key}) : super(key: key);

  @override
  State<CameraFeedPage> createState() => _CameraFeedPageState();
}

class _CameraFeedPageState extends State<CameraFeedPage> {
  CameraController? controller;

  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;

  double _scale = 1.0;
  double _initialScale = 1.0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller!.startImageStream(
        (CameraImage image) {},
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlockScreen(),
                  ),
                );
              },
            ),
          ],
          title: const Text('AR Viewer'),
        ),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CameraPreview(
                controller!,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onScaleStart: (details) {
                  _initialFocalPoint = details.focalPoint;
                  _initialScale = _scale;
                },
                onScaleUpdate: (details) {
                  setState(() {
                    _sessionOffset = details.focalPoint - _initialFocalPoint;
                    _scale = _initialScale * details.scale;
                  });
                },
                onScaleEnd: (details) {
                  setState(() {
                    _offset += _sessionOffset;
                    _sessionOffset = Offset.zero;
                  });
                },
                child: Transform.translate(
                  offset: _offset + _sessionOffset,
                  child: Transform.scale(
                    scale: _scale,
                    child: Container(
                      child: Image.asset('assets/WME8.gif'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Camera Feed'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
