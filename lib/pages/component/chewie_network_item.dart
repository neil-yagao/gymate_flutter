import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieNetworkItem extends StatefulWidget {

  final String url;

  const ChewieNetworkItem({Key key, @required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChewieNetworkItemState(this.url);
  }
}

class ChewieNetworkItemState extends State<ChewieNetworkItem> {

  final String url;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  ChewieNetworkItemState(this.url);

  @override
  void initState(){
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControlsOnInitialize: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose(){
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _chewieController?.dispose();
    _chewieController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );;
  }
}
