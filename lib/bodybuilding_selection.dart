import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/general/questions.dart';
import 'package:workout_helper/service/question_service.dart';

class BodybuildingSelection extends StatelessWidget {
  final QuestionRepositoryService _questionService =
   QuestionRepositoryService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final List<Question> bodybuilding =
    _questionService
        .getQuestionOf(SupportedTrainingType.BODYBUILDING);
    return Scaffold(
      appBar: AppBar(title: Text("健美计划选择")),
      body: SequenceQuestions(
        questions:bodybuilding,
        allAnswersHandle: (List<String> answers) {
          print(answers);
        },
        questionLength: 2,
        ///using default question handler,
      ),
    );
  }
}
