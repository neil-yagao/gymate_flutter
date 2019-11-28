import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:workout_helper/model/movement.dart';

import 'basic_dio.dart';


class VideoAudioAnalysisService {
  Dio dio;

  final GlobalKey<ScaffoldState> scaffoldKey;
  WebSocketChannel channel;

  final String host = "www.lifting.ren";
  final String _audioAPISecret = "059ebceb124b8ffb5a87d360ad26aaf2";
  final String _audioAPIKey = "7b804c17c906118b1911f7d5e7dbbb12";
  final String _audioAppId = "5dc1fd7e";

  VideoAudioAnalysisService(this.scaffoldKey) {
    dio = DioInstance.getInstance(scaffoldKey);
  }

  Future processUploadedVideo(
      UserMovementMaterial userMovementMaterial, int userId) async {
    dio.post('/video_process/user/' + userId.toString(),
        data: userMovementMaterial.toJson());
  }

  Future connectToRemoteAudioRecognizer(Function onMessageReceive) {
    String dateString = HttpDate.format(DateTime.now());
    String authorization = getAuthorization(dateString);
    String url =
        "wss://iat-api.xfyun.cn/v2/iat?date=$dateString&host=$host&authorization=$authorization";
    channel = IOWebSocketChannel.connect(url);
    channel.stream.listen((data) {
      onMessageReceive(data);
    }, onError: (error) {
      debugPrint('error in websocket:');
      debugPrint(error);
    }, onDone: () {
      debugPrint('channel ends');
    });
  }

  String getAuthorization(String dateString) {
    String signature = getSignature(dateString);
    String authorizationOrigin =
        "api_key=\"$_audioAPIKey\", algorithm=\"hmac-sha256\", "
        "headers=\"host date request-line\",signature=\"$signature\"";
    return base64.encode(utf8.encode(authorizationOrigin));
  }

  String getSignature(String date) {
    String requestLine = "GET /v2/iat HTTP/1.1";
    String signatureOrigin = "host: $host\ndate: $date\n$requestLine";
    var hmacSha256 =
        new Hmac(sha256, utf8.encode(_audioAPISecret)); // HMAC-SHA256
    var digest = hmacSha256.convert(utf8.encode(signatureOrigin));
    return base64.encode(digest.bytes);
  }

  Future sendToRemoteAudioRecognizer(filePath) async{
    var param = Map<String,dynamic>();
    param['common'] = {
      'app_id':_audioAppId,
    };
    param['business'] = {
      'language':'zh_cn',
      'domain':'iat',
      'accent':'mandarin'
    };
    Uint8List rawBytes = await _readFileByte(filePath);
    String audioData =  base64Encode(rawBytes);
    param['data'] = {
      'status': 2,
      'format':'audio/L16;rate=16000',
      'encoding': 'raw',
      'audio':audioData
    };
    channel.sink.add(param);
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      debugPrint('reading of bytes is completed');
    }).catchError((onError) {
      debugPrint('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }
}
