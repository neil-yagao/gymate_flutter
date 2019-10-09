import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'component/show_clip_result.dart';


class CameraCapture extends StatefulWidget {
  final String remoteStoreLocation;
  final Function(String) fileUploaded;
  CameraCapture(this.remoteStoreLocation, this.fileUploaded);

  @override
  _CameraCaptureState createState() {
    return _CameraCaptureState(this.remoteStoreLocation,this.fileUploaded);
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraCaptureState extends State<CameraCapture>
    with WidgetsBindingObserver {

  final Function(String) fileUploaded;

  CameraController controller;
  String imagePath;
  final String remoteStoreLocation;

  _CameraCaptureState(this.remoteStoreLocation, this.fileUploaded);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    availableCameras().then((List<CameraDescription> cameras) {
      setState(() {
        List<CameraLensDirection> addedCamera = List();
        if (cameras == null || cameras.isEmpty) {
          return;
        } else {
          for (CameraDescription cameraDescription in cameras) {
            if (addedCamera.contains(cameraDescription.lensDirection)) {
              continue;
            }
            addedCamera.add(cameraDescription.lensDirection);
            this.cameras.add(cameraDescription);
          }
        }
        if (this.cameras.length > 0) {
          onNewCameraSelected(this.cameras[0]);
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CameraDescription> cameras = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      _cameraPreviewWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).maybePop();
                            },
                            color: Colors.transparent,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: _cameraTogglesRowWidget(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Theme.of(context).primaryColor,
          onPressed: onTakePictureButtonPressed

        ),
        IconButton(
          icon: const Icon(Icons.image),
          color: Theme.of(context).primaryColor,
          onPressed: onGalleryButtonPressed
        )
      ],
    );
  }

  Widget _cameraTogglesRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return const Text('未能检测到摄像头，请检测您的权限是否打开。');
    }
    Widget switchCamera = IconButton(
        icon: Icon(
          Icons.switch_camera,
          color: Colors.white,
        ),
        onPressed: () {
          int index = this.cameras.indexOf(controller.description);
          if (index >= this.cameras.length - 1) {
            onNewCameraSelected(this.cameras[0]);
          } else {
            onNewCameraSelected(this.cameras[index + 1]);
          }
        });
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [switchCamera]);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          goToResult(filePath);
        }
      }
    });
  }

  void goToResult(String filePath) {
        Navigator.of(context).push(MaterialPageRoute<String>(
        builder: (context) => ShowClipResult(
              filePath: filePath,
              remoteStoreLocation:  remoteStoreLocation,
            ))).then((String filePath){
              if(filePath == null){
                return;
              }
              print('uploaded, stored @' + filePath);
              this.fileUploaded(filePath);
        });
  }

  //todo using image picker
  void onGalleryButtonPressed() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    goToResult(file.path);
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/TrainingRecord/Pictures';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

