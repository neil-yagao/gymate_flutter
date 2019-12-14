import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workout_helper/general/alicloud_oss.dart';
import 'package:workout_helper/model/community.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/util/navigation_util.dart';
import 'package:zefyr/zefyr.dart';

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  final AliCloudOSS _aliCloudOSS;
  final User user;
  final Post currentPost;
  final BuildContext context;

  MyAppZefyrImageDelegate(this._aliCloudOSS, this.user, this.currentPost,
      this.context);

  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    if (file == null) return null;
    NavigationUtil.showLoading(context,content: "正在为您上传图片");
    String filePath = await _aliCloudOSS.doUpload(
        user.id.toString(),
        "post/" + DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        file.path,
        file);
    Navigator.of(context).maybePop();
    PostMaterial postMaterial = PostMaterial.empty();
    postMaterial.storedAt = filePath;
    postMaterial.uploadedAt = DateTime.now();
    currentPost.relatedPics.add(postMaterial);
    return filePath;
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    return Image.network(key,
               loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                 if (loadingProgress == null)
                   return child;
                 return Center(
                   child: CircularProgressIndicator(
                     value: loadingProgress.expectedTotalBytes != null
                         ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                         : null,
                   ),
                 );
               },); // TODO: implement buildImage
  }

  // TODO: implement cameraSource
  get cameraSource => ImageSource.camera;

  @override
  // TODO: implement gallerySource
  get gallerySource => ImageSource.gallery;
}