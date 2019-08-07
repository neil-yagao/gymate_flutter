import 'package:workout_helper/model/entities.dart';

/// QuestionService
///
/// currently only using constant questionnaire
class QuestionRepositoryService {
  List<Question> getQuestionOf(SupportedTrainingType type) {
    List<Question> questions = List();
    if (type == SupportedTrainingType.POWERLIFTING) {
      /**
       *
       */

      Question level = Question("请选择相应的训练经验",
          ["初级(从未接触过力量举)", "中级(有一定训练基础)", "高级(有过参加相应比赛)"], "level");
      questions.add(level);
      Question entryLevelPlan = Question("请选择下列计划其中之一",
          ["Stronglifts 5X5(每周训练三次，线性计划)", "Sheiko新手训练计划（6周）"], "entryLevel");
      entryLevelPlan.prev = level;
      Question middleLevelPlan = Question("请选择下列计划其中之一",
          ["Texas训练", "Jonnie Candito训练（6周）"], "intermediateLevel");
      middleLevelPlan.prev = level;
      Question advanceLevelPlan = Question(
          "请选择下列计划其中之一",
          [
            ""
                "RTS训练",
            "自定义训练"
          ],
          "advancedLevel");
      advanceLevelPlan.prev = level;
      questions.addAll([entryLevelPlan, middleLevelPlan, advanceLevelPlan]);
    } else if (type == SupportedTrainingType.BODYBUILDING) {
      Question target = Question("请选择训练目标", ["减脂", "增肌"], "goal");
      questions.add(target);
      Question frequency = Question(
          "预计每周训练次数", ["3次", "4次", "5次", "6次", "7次", "一天双练"], "frequency");
      frequency.prev = target;
      questions.add(frequency);
    } else if (type == SupportedTrainingType.CROSSFIT) {
      Question level = Question(
          "请选择相应的训练经验", ["初级(未接触过CF)", "中级(有一定训练基础)", "高级(有过参加相应比赛)"], "level");
      questions.add(level);
      Question frequency =
          Question("预计每周训练次数", ["3次", "4次", "5次", "6次", "7次"], "frequency");
      frequency.prev = level;
    }

    return questions;
  }

  List<Question> choosePlan() {
    List<Question> questions = List();
    Question target = Question("请选择你的目标", ["减脂", "增肌", "三大项", "协调性"], 'target');

    Question level = Question("请选择相应的训练经验",
        ["初级(从未接触过力量训练)", "中级(有一定训练经验)", "高级(有相当的训练知识与基础)"], "level");
    questions.add(level);
    return questions;
  }
}
