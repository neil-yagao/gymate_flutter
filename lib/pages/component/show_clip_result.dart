import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/session_service.dart';
import 'package:video_player/video_player.dart';

class ShowClipResult extends StatelessWidget {
  final bool isVideo;
  final String filePath;
  final VideoPlayerController videoController;
  final String currentSessionId;
  final SessionRepositoryService srs = SessionRepositoryService();

  ShowClipResult(
      {Key key,
        this.isVideo,
        this.filePath,
        this.videoController,
        this.currentSessionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (isVideo && this.videoController != null) {
      this.videoController.play();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            isVideo
                ? AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              child: VideoPlayer(videoController),
            )
                : Image.file(File(filePath)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    "保存",
                    style: Typography.dense2018.title,
                  ),
                  onPressed: () {
                    SessionMaterial sessionMaterial = SessionMaterial();
                    sessionMaterial.isVideo = isVideo;
                    sessionMaterial.filePath = filePath;
                    sessionMaterial.sessionId = currentSessionId;
                    srs.addSessionMaterial(sessionMaterial);
                  },

                ),
                FlatButton(
                  textColor: Colors.redAccent,
                  child: Text(
                    "删除",
                    style: Typography.dense2018.title,
                  ),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


