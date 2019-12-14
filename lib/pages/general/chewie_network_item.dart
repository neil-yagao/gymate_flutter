import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieNetworkItem extends StatefulWidget {
  final String url;
  final double aspectRatio;
  final bool landscape;

  ChewieNetworkItem(
      {Key key, @required this.url, this.aspectRatio, this.landscape})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChewieNetworkItemState();
  }


}

class ChewieNetworkItemState extends State<ChewieNetworkItem> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  double slowMotion = 1;
  double aspectRatio;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    initClips();

  }

  void initClips() {
    _videoPlayerController = VideoPlayerController.network(widget.url);
    if (widget.aspectRatio != null && widget.landscape) {
      aspectRatio = 1 / widget.aspectRatio;
    }
    debugPrint(aspectRatio.toString());
    debugPrint(_videoPlayerController.value.aspectRatio.toString());
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: aspectRatio,
      showControlsOnInitialize: false,
      errorBuilder: (context, errorMessage) {
        print(errorMessage);
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        );
      },
    );
    aspectRatio = widget.aspectRatio == null
        ? _videoPlayerController.value.aspectRatio
        : widget.aspectRatio;
  }

  @override
  void didUpdateWidget(ChewieNetworkItem oldWidget) {
    // TODO: implement didUpdateWidget
    if(oldWidget.url != widget.url){
      initClips();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _chewieController?.dispose();
    _chewieController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: <Widget>[
            Chewie(
              controller: _chewieController,
            ),
            Positioned(
              top: 24,
              left: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (slowMotion == 1) {
                        slowMotion = 0.5;
                      } else if (slowMotion == 0.5) {
                        slowMotion = 0.25;
                      } else {
                        slowMotion = 1;
                      }
                      _videoPlayerController.setSpeed(slowMotion);
                      setState(() {});
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.slow_motion_video,
                          color: slowMotion != 1
                              ? Colors.redAccent
                              : Theme.of(context).primaryColor,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              slowMotion.toString() + "X",
                              style: TextStyle(
                                color: slowMotion != 1
                                    ? Colors.redAccent
                                    : Theme.of(context).primaryColor,
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
