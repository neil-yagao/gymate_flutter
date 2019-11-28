import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';


import 'package:dio/dio.dart';

class AliCloudOSS {
  final String _appSecret = 'jWxmlzBRGDRJMZBDZPVZ3EhGoSOBBY';
  final String _appId = 'txC5quMuFA14KNwO';

  static String _policyText =
      '{"expiration": "2069-05-22T03:15:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}'; //UTC时间+8=北京时间
  static List<int> _policyTextUtf8 = utf8.encode(_policyText);
  //进行base64编码
  static String policy= base64.encode(_policyTextUtf8);

  //再次进行utf8编码
  final List<int> _policyUtf8 = utf8.encode(policy);

  static const String BUCKET_NAME = "lifting-ren-user";

  final Dio dio = Dio(BaseOptions(
    connectTimeout: 15000,
    receiveTimeout: 15000,
    contentType: ContentType.parse("application/x-www-form-urlencoded"),
  ));

  Future<String> doUpload(String userId, String location, String filePath, File file) {
    String filename = getImageNameByPath(filePath);
    String fileLocation = userId + "/" +  location + "/" + filename;
    FormData data = new FormData.from({
      'Filename': fileLocation,//文件名，随意
      'key': fileLocation, //"可以填写文件夹名（对应于oss服务中的文件夹）/" + fileName
      'policy': policy,
      'OSSAccessKeyId':_appId,
      'success_action_status': '201',
      'signature': getSignature(_appSecret),
      'file': new UploadFileInfo(file, getImageNameByPath(filePath))//必须放在参数最后
    });
    return dio.post("https://" + BUCKET_NAME + ".oss-cn-hangzhou.aliyuncs.com",data: data).then((_){
      return "https://" + BUCKET_NAME + ".oss-cn-hangzhou.aliyuncs.com/" + fileLocation;
    });
  }

  String getSignature(String _accessKeySecret){
    //进行utf8 编码
    List<int> _accessKeySecretUtf8 = utf8.encode(_accessKeySecret);

    //通过hmac,使用sha1进行加密
    List<int> signaturePre = new Hmac(sha1, _accessKeySecretUtf8).convert(_policyUtf8).bytes;

    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);
    return signature;
  }


  /*
  * 根据图片本地路径获取图片名称
  * */
  String getImageNameByPath(String filePath) {
    return filePath?.substring(filePath?.lastIndexOf("/")+1,filePath?.length);
  }

  String getImageUploadName(String uploadPath,String filePath) {
    String imageMame = "";
    var timestamp = new DateTime.now().millisecondsSinceEpoch;
    imageMame =timestamp.toString()+"_"+getRandom(6);
    if(uploadPath!=null&&uploadPath.isNotEmpty){
      imageMame=uploadPath+"/"+imageMame;
    }
    String imageType=filePath?.substring(filePath?.lastIndexOf("."),filePath?.length);
    return imageMame+imageType;
  }

  /*
  * 生成固定长度的随机字符串
  * */
  String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }
}
