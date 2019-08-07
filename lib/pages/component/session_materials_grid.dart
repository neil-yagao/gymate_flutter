import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/service/session_service.dart';

class SessionMaterialsGrid extends StatefulWidget {
  final String sessionId ;

  const SessionMaterialsGrid({Key key, this.sessionId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SessionMaterialsGridState(sessionId);
  }
}

class SessionMaterialsGridState extends State<SessionMaterialsGrid> {
  final SessionRepositoryService srs = SessionRepositoryService();
  final String sessionId;

  List<SessionMaterial> _materials = List();

  SessionMaterialsGridState(this.sessionId);

  @override
  void initState() {
    super.initState();
    srs
        .getSessionMaterialsBySessionId(sessionId)
        .then((sms) {
      setState(() {
        _materials = sms;
        print(_materials);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: Text('训练速览'),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 4,
        children: buildMaterials(_materials),
      ),
    );
  }

  List<Widget> buildMaterials(List<SessionMaterial> _materials) {
    return _materials.map((SessionMaterial sm) {
      if (sm.isVideo) {
        VideoPlayerController videoController =
        VideoPlayerController.file(File(sm.filePath));
        return AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController));
      } else {
        return Image.file(File(sm.filePath));
      }
    }).toList();
  }
}
