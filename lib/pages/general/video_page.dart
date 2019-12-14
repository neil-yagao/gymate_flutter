import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:workout_helper/general/alicloud_oss.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/util/navigation_util.dart';

/// modify from example
class VideoRecorder extends StatefulWidget {
  final Function(String) uploadCompleted;
  final String currentSessionId;

  const VideoRecorder({Key key, this.uploadCompleted, this.currentSessionId})
      : super(key: key);

  @override
  _VideoRecorderState createState() {
    return _VideoRecorderState();
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
    debugPrint('Error: $code\nError Message: $message');

class _VideoRecorderState extends State<VideoRecorder>
    with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  String videoPath;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  bool enableAudio = true;

  List<CameraDescription> cameras;

  User _user;

  AliCloudOSS _aliCloudOSS = AliCloudOSS();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    availableCameras().then((cams) async {
      if (cams.length > 2) {
        this.cameras = cams.sublist(0, 2);
      } else {
        this.cameras = cams;
      }
      onNewCameraSelected(cams[0]);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<CurrentUserStore>(context).currentUser;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Center(
                      child: _cameraPreviewWidget(),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: controller != null &&
                              controller.value.isRecordingVideo
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
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.04,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  _cameraTogglesRowWidget(),
                ]),
          ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        '点击唤醒相机',
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
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: controller != null && controller.value.isRecordingPaused
              ? Icon(Icons.play_arrow)
              : Icon(Icons.pause),
          color: Colors.blue,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? (controller != null && controller.value.isRecordingPaused
                  ? onResumeButtonPressed
                  : onPauseButtonPressed)
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
        IconButton(
            icon: Icon(
              Icons.video_library,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              File file =
                  await ImagePicker.pickVideo(source: ImageSource.gallery);
              await fixRotationProblem(file);
              this.doUploadFile();
            }),
      ],
    );
  }

  Future fixRotationProblem(File file) async {
    const int AV_LOG_ERROR = 16;

    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    _flutterFFmpeg.setLogLevel(AV_LOG_ERROR);

    String videoPath = file.path;
    final directory = await getTemporaryDirectory();
    String toVideoPath = directory.path +
        file.path.substring(file.path.lastIndexOf("/"), file.path.length);
//              String scale = MediaQuery
//                  .of(context)
//                  .size
//                  .width
//                  .toString() + ":" + MediaQuery
//                  .of(context)
//                  .size
//                  .height
//                  .toString();
    //since open cv remove all the
    final String looselessConversion =
        '-y -i $videoPath -vf scale=1080:1920 $toVideoPath';
    try {
      NavigationUtil.showLoading(context,
          content: "正在预处理视频", dismissible: false);

      final int returnCode = await _flutterFFmpeg.execute(looselessConversion);

      if (returnCode != 0) {
        throw await _flutterFFmpeg.getLastCommandOutput();
      }
    } catch (e) {
      print('video processing error: $e');
      return;
    }
    Navigator.of(context).pop();
    this.videoPath = toVideoPath;
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
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
    return switchCamera;
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
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('error: ${controller.value.errorDescription}');
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

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) async {
      if (mounted) setState(() {});
    });
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((result) async {
      if (mounted) setState(() {});
      await fixRotationProblem(File(videoPath));
      await doUploadFile();
      //showInSnackBar('Video recorded to: $videoPath');
    }).catchError((error) {
      debugPrint("error:" + error.toString());
    });
  }

  Future doUploadFile() async {
    NavigationUtil.showLoading(context, content: "正在上传", dismissible: false);
    if (videoPath != null) {
      debugPrint(videoPath);
      String uploadedPath = await _aliCloudOSS.doUpload(
          _user.id.toString(), 'raw_material', videoPath, File(videoPath));
      Navigator.maybePop(context);
      showInSnackBar(
          "上传成功,正在为您进行智能AI分析。\n分析过程通常为2~3分钟，在完成后，您可以在您的消息列表中找到分析结果！");
      widget.uploadCompleted(uploadedPath);
    }
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('暂停');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) setState(() {});
      showInSnackBar('恢复');
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getTemporaryDirectory();
    print('extDir' + extDir.path);
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);

    final String filePath =
        '$dirPath/${timestamp()}.mp4';
    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }
    print('filepath' + filePath);

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imagePath = null;
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

class VideoPreview extends StatelessWidget {
  final File video;
  final Function uploadClicked;
  final Function cancelClicked;

  const VideoPreview(
      {Key key, this.video, this.uploadClicked, this.cancelClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    VideoPlayerController _videoPlayerController;

    ChewieController _chewieController;
    _videoPlayerController = VideoPlayerController.file(video);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 9 / 16,
      autoPlay: true,
      looping: false,
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Chewie(
            controller: _chewieController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "上传",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () async {
                  _chewieController.dispose();
                  _videoPlayerController.dispose();
                  uploadClicked();
                },
              ),
              FlatButton(
                child: Text(
                  "重新选择",
                  style: TextStyle(color: Colors.amberAccent),
                ),
                onPressed: () async {
                  cancelClicked();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
