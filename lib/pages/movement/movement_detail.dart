import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/movement.dart';
import 'package:workout_helper/pages/general/chewie_network_item.dart';
import 'package:workout_helper/pages/general/default_app_bar.dart';
import 'package:workout_helper/pages/general/video_page.dart';
import 'package:workout_helper/service/ai_service.dart';
import 'package:workout_helper/service/community_service.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/movement_service.dart';

import 'movement_material_list.dart';
import 'movement_new_material.dart';

class MovementDetail extends StatefulWidget {
  final Movement movement;
  final MovementMaterial designateMaterial;

  const MovementDetail({Key key, this.movement, this.designateMaterial})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MovementDetailState();
  }
}

class MovementDetailState extends State<MovementDetail> {
  MovementMaterial _currentMovementMaterial;

  List<MovementMaterial> materials = List();

  MovementService _movementService;

  CommunityService _communityService;

  String _currentVideoUrl = "";

  User _user;

  VideoAudioAnalysisService _videoAnalysisService;
  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _movementService = MovementService(_key);
    _communityService = CommunityService(_key);
    _videoAnalysisService = VideoAudioAnalysisService(_key);
    _movementService.getMovementMaterials(widget.movement.id).then((materials) {
      setState(() {
        this.materials = materials;
        if (widget.designateMaterial != null) {
          _currentMovementMaterial = widget.designateMaterial;
        } else {
          _currentMovementMaterial = materials
              .firstWhere((m) => m.id == widget.movement.defaultMaterialId);
        }
        _currentVideoUrl = _currentMovementMaterial.rawVideoPlace;
      });
    });
    _user = Provider.of<CurrentUserStore>(context).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentMovementMaterial == null) {
      return Scaffold(
        key: _key,
        appBar: DefaultAppBar.build(context, title: widget.movement.name),
      );
    }
    return Scaffold(
      key: _key,
      appBar: DefaultAppBar.build(context,
        title: widget.movement.name,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "由" + _currentMovementMaterial.uploadBy.name + "上传",
                  style: Typography.dense2018.subhead,
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChewieNetworkItem(
                  url: _currentVideoUrl,
                  aspectRatio: _currentMovementMaterial.aspectRatio,
                  landscape: _currentMovementMaterial.landscape,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _currentMovementMaterial.analysedMovementPlace != null
                    ? InkWell(
                        onTap: () async {
                          _currentVideoUrl =
                              _currentMovementMaterial.analysedMovementPlace;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.android,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Icon(
                        Icons.android,
                        color: Colors.grey,
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: InkWell(
                    child: Icon(
                      Icons.thumb_up,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () {
                      _communityService
                          .recommend(_currentMovementMaterial.id,
                              "movementMaterial", _user)
                          .then((_) {
                        setState(() {
                          _currentMovementMaterial.totalRecommendation += 1;
                        });
                        _key.currentState.showSnackBar(SnackBar(
                          content: Text("推荐成功"),
                          duration: Duration(seconds: 2),
                        ));
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Text(
                    _currentMovementMaterial.totalRecommendation.toString(),
                    style: TextStyle(color: Colors.grey)
                        .merge(Typography.dense2018.subtitle),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "动作简介:",
                    style: Typography.dense2018.subhead,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.movement.description),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "用户示例：",
                    style: Typography.dense2018.subhead,
                  ),
                ),
              ],
            ),
            MovementMaterialList(
              materials: materials
                  .where((m) => m.id != widget.movement.defaultMaterialId)
                  .toList(),
              onSelected: (MovementMaterial material) {
                _currentMovementMaterial = material;
                _currentVideoUrl = material.rawVideoPlace;
                setState(() {});
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showDialog<MovementMaterial>(
              context: context,
              builder: (context) => MovementNewMaterial(
                    movement: widget.movement,
                    parentKey: _key,
                  )).then((material) {
            if (material != null) {
              setState(() {
                this.materials.add(material);
              });
            }
          });
        },
        child: Icon(
          Icons.cloud_upload,
          color: Theme.of(context).primaryColor,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                Icon(Icons.videocam),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("智能分析"),
                )
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoRecorder(
                      currentSessionId: "",
                      uploadCompleted: (uploadedAt) async {
                        UserMovementMaterial material =
                        UserMovementMaterial.empty();
                        material.isVideo = true;
                        material.sessionId = "";
                        material.storeLocation =
//                                "https://lifting-ren-user.oss-cn-hangzhou.aliyuncs.com/115093490613878784/raw_material/1574040282432918.mp4";
                        uploadedAt;
                        material.matchingMovement = widget.movement;
                        material.aspectRatio =
                            MediaQuery.of(context).size.width /
                                MediaQuery.of(context).size.height;
                        material.landscape =
                            MediaQuery.of(context).orientation ==
                                Orientation.landscape;
                        _videoAnalysisService.processUploadedVideo(
                            material, _user.id);
                      })));
            },
          )],
        ),
      ),
    );
  }
}
