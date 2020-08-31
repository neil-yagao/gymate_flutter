import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:workout_helper/model/movement.dart';

import 'basic_dio.dart';

class VideoAudioAnalysisService {
  Dio dio;

  final GlobalKey<ScaffoldState> scaffoldKey;

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  WebSocketChannel channel;

  final String host = "www.lifting.ren";
  final String _audioAPISecret = "059ebceb124b8ffb5a87d360ad26aaf2";
  final String _audioAPIKey = "7b804c17c906118b1911f7d5e7dbbb12";
  final String _audioAppId = "5dc1fd7e";

  VideoAudioAnalysisService(this.scaffoldKey) {
    dio = DioInstance.getInstance(scaffoldKey);
    _flutterFFmpeg.setLogLevel(16);
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
    try {
      channel = IOWebSocketChannel.connect(url);
    } catch (e) {
      debugPrint("error in connecting" + e.toString());
    }
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

  Future sendToRemoteAudioRecognizer(filePath) async {
    var param = Map<String, dynamic>();
    param['common'] = {
      'app_id': _audioAppId,
    };
    param['business'] = {
      'language': 'zh_cn',
      'domain': 'iat',
      'accent': 'mandarin'
    };
    Uint8List rawBytes = await _readFileByte(filePath);

    int buffSize = 1280; // 缓存大小
    int currPos = 1280; // 当前位置
    param['data'] = {
      'status': 0,
      'format': 'audio/L16;rate=16000',
      'encoding': 'raw',
      'audio': base64Encode(rawBytes.sublist(0, buffSize))
    };
    channel.sink.add(json.encode(param));
    while (true) {
      await Future.delayed(Duration(milliseconds: 40));
      int dataLen = rawBytes.length;
      List<int> buff;
      int status = 1;
      if (dataLen - 1 > currPos) {
        if (dataLen > currPos + 1 + buffSize) {
          buff = rawBytes.sublist(currPos, currPos + buffSize);
          currPos += buffSize;
        } else {
          buff = rawBytes.sublist(currPos, dataLen);
          currPos = dataLen - 1;
        }
      }
      if (currPos == dataLen - 1) {
        status = 2;
      }
      if (buff != null && buff.length > 0) {
        channel.sink.add(json.encode({
          "status": status,
          "format": "audio/L16;rate=16000",
          "audio": base64.encode(buff),
          "encoding": "raw",
        }));
      } else {
        break;
      }
    }
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    String toFile = filePath.replaceAll("wav", "pcm");
    String transformCommand =
        " -y -i $filePath -acodec pcm_s16le -f s16le -ac 1 -ar 16000 $toFile";
    final int returnCode = await _flutterFFmpeg.execute(transformCommand);
    if (returnCode != 0) {
      throw await _flutterFFmpeg.getLastCommandOutput();
    }
    Uint8List bytes;
    var audioFile = new File(toFile);
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
