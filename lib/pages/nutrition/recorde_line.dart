import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/model/nutrition_preference.dart';
import 'package:workout_helper/pages/general/camera_page.dart';
import 'package:workout_helper/service/ai_service.dart';
import 'package:workout_helper/service/current_user_store.dart';
import 'package:workout_helper/service/nutrition_service.dart';

class RecordLine extends StatefulWidget {
  final NutritionRecord nutritionRecord;
  final GlobalKey<ScaffoldState> parentKey;

  const RecordLine({Key key, this.nutritionRecord, this.parentKey})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RecordLineState();
  }
}

class RecordLineState extends State<RecordLine> {
  NutritionService nutritionService;

  VideoAudioAnalysisService _aiService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aiService = VideoAudioAnalysisService(widget.parentKey);
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<CurrentUserStore>(context).currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("拍下你的" + widget.nutritionRecord.name),
              )
            ],
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CameraCapture(
                    remoteStoreLocation: "nutrition/" +
                        DateFormat("yyyy-MM-dd").format(DateTime.now()),
                    fileUploaded: (String uploadedFile) {
                      if (widget.nutritionRecord.materials == null) {
                        widget.nutritionRecord.materials = List();
                      }
                      widget.nutritionRecord.materials.add(uploadedFile);
                      nutritionService
                          .saveNutritionRecord(user.id, widget.nutritionRecord)
                          .then((_) {});
                    })));
          },
        ),
        FlatButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.record_voice_over,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("说出你吃了什么"))
            ],
          ),
          onPressed: () async {
            bool hasPermissions = await AudioRecorder.hasPermissions;
            // Get the state of the recorder
            bool isRecording = await AudioRecorder.isRecording;
            // Start recording
            debugPrint('hasPermissions' + hasPermissions.toString());
            debugPrint('isRecording' + isRecording.toString());
            final directory = await getApplicationDocumentsDirectory();


            if(hasPermissions && !isRecording) {
              await AudioRecorder.start(
                path: directory.path + '/' +
                    DateTime
                        .now()
                        .millisecondsSinceEpoch
                        .toString(),
                audioOutputFormat: AudioOutputFormat.WAV,
              );
              debugPrint('start recordting');
              showDialog(context: context,builder: (context){
                return Center(
                  child: Card(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Divider(),
                        FlatButton(
                          child: Text("完成"),
                          onPressed: () async {
                            _aiService.connectToRemoteAudioRecognizer((data){
                              debugPrint('data' + data);
                            });
                            Recording recording = await AudioRecorder.stop();
                            _aiService.sendToRemoteAudioRecognizer(recording.path);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )

                  ),
                );
              }).then((_){
                AudioRecorder.stop();
              });
            }
          },
        )
      ],
    );
  }
}
