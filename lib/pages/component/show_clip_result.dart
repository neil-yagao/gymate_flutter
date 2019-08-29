import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/general/alicloud_oss.dart';
import 'package:workout_helper/service/current_user_store.dart';

class ShowClipResult extends StatelessWidget {
  final String filePath;
  final String remoteStoreLocation;

  ShowClipResult({Key key, this.filePath, this.remoteStoreLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AliCloudOSS _aliCloudOSS = AliCloudOSS();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              Image.file(File(filePath)),
              Positioned(
                bottom: 10,
                width: MediaQuery.of(context).size.width * 0.98,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        "保存",
                        style: Typography.dense2018.title,
                      ),
                      onPressed: () async {
                        showDialog(

                            context: context,
                            barrierDismissible:false,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        _aliCloudOSS
                            .doUpload(
                                Provider.of<CurrentUserStore>(context)
                                    .currentUser
                                    .id
                                    .toString(),
                                remoteStoreLocation,
                                filePath,
                                File(filePath))
                            .then((String filePath) {
                          //first pop dialog
                          Navigator.of(context).maybePop().then((_) {
                            Navigator.of(context).maybePop(filePath);
                          });
                        });
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
