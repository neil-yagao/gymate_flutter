import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/general/alicloud_oss.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/movement.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/movement_service.dart';

class MovementNewMaterial extends StatefulWidget {
  final Movement movement;
  final GlobalKey<ScaffoldState> parentKey;

  const MovementNewMaterial({Key key, this.movement, this.parentKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MovementNewMaterialState();
  }
}

class MovementNewMaterialState extends State<MovementNewMaterial> {
  String _picPath;
  String _videoPath;

  AliCloudOSS _aliCloudOSS = AliCloudOSS();

  User _currentUser;

  MovementService _movementService;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _currentUser = Provider.of<CurrentUserStore>(context).currentUser;
    _movementService = MovementService(widget.parentKey);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: ListTile(
              leading: Icon(
                Icons.picture_in_picture,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "动作封面",
                style: Typography.dense2018.subhead,
              ),
              trailing: _picPath == null
                  ? IconButton(
                      icon: Icon(
                        Icons.cloud_upload,
                        color: Colors.grey,
                      ),
                      onPressed: () async {
                        File frontPic = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (frontPic == null) {
                          return;
                        }
                        _picPath = await _aliCloudOSS.doUpload(
                            _currentUser.id.toString(),
                            "movement/pic/" + widget.movement.id,
                            frontPic.path,
                            frontPic);
                        setState(() {});
                      })
                  : Image.network(_picPath),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.videocam,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              "动作视频",
              style: Typography.dense2018.subhead,
            ),
            trailing: _videoPath == null
                ? IconButton(
                    icon: Icon(
                      Icons.cloud_upload,
                      color: Colors.grey,
                    ),
                    onPressed: () async {
                      File frontPic = await ImagePicker.pickVideo(
                          source: ImageSource.gallery);
                      if (frontPic == null) {
                        return;
                      }
                      _videoPath = await _aliCloudOSS.doUpload(
                          _currentUser.id.toString(),
                          "movement/raw" + widget.movement.id,
                          frontPic.path,
                          frontPic);
                      setState(() {});
                    })
                : Icon(
                    Icons.check,
                    color: Colors.greenAccent,
                  ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () {
                  MovementMaterial material = MovementMaterial.empty();
                  material.frontPagePic = _picPath;
                  material.rawVideoPlace = _videoPath;
                  material.movement = widget.movement;
                  material.uploadBy = _currentUser;
                  _movementService
                      .uploadMovementMaterial(material)
                      .then((material) {
                    Navigator.of(context).maybePop(material);
                  });
                },
              )
            ],
          )
        ],
      ),
    ));
  }
}
