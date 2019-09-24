import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:workout_helper/model/entities.dart';

class MovementDetail extends StatefulWidget {
  final Movement movement;

  const MovementDetail({Key key, this.movement}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MovementDetailState(movement);
  }
}

class MovementDetailState extends State<MovementDetail> {
  VideoPlayerController _videoPlayerController;

  ChewieController _chewieController;

  final Movement movement;

  MovementDetailState(this.movement);

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(movement.videoReference);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  movement.name,
                  style: Typography.dense2018.headline,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chewie(
                controller: _chewieController,
              ),
            ),
            Divider(),
            Text(
              "动作简介:",
              style: Typography.dense2018.title,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movement.description),
            )
          ],
        ),
      ),
    );
  }
}
