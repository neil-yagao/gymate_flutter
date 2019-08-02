import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';
import 'package:workout_helper/general/questions.dart';
import 'package:workout_helper/service/question_service.dart';

class PowerliftingSelection extends StatelessWidget {
  final QuestionRepositoryService _questionService =
       QuestionRepositoryService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final List<Question> powerlifting =
    _questionService
        .getQuestionOf(SupportedTrainingType.POWERLIFTING);
    return Scaffold(
      appBar: AppBar(title: Text("力量举计划选择")),
      body: SequenceQuestions(
        questions:powerlifting,
        allAnswersHandle: (List<String> answers) {
          print(answers);
        },
          questionLength: 2,
        questionIterateHandler: (Question answeredQuestion) {
          int level = answeredQuestion.options.indexOf(answeredQuestion.selectedOption);
          if(level == 0){
            return powerlifting.firstWhere((Question q) => q.mark == "entryLevel");
          }else if(level == 1){
            return powerlifting.firstWhere((Question q) => q.mark == "intermediateLevel");
          }else if(level == 2){
            return powerlifting.firstWhere((Question q) => q.mark == "advancedLevel");
          }
          return null;
        },
      ),
    );
  }
}
