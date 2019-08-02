import 'package:flutter/material.dart';
import 'package:workout_helper/model/entities.dart';

class SequenceQuestions extends StatefulWidget {
  SequenceQuestions(
      {this.questions,
      this.allAnswersHandle,
      this.questionLength,
      this.questionIterateHandler});

  final List<Question> questions;
  final Function(List<String>) allAnswersHandle;
  final int questionLength;
  final Function(Question answeredQuestion) questionIterateHandler;

  @override
  State<StatefulWidget> createState() {
    return  SequenceQuestionsState(
        questions, allAnswersHandle, questionLength, questionIterateHandler);
  }
}

class SequenceQuestionsState extends State<SequenceQuestions> {
  SequenceQuestionsState(this.questions, this.allAnswersHandle,
      this.questionLength, this.questionIterateHandler) {
    _allAnswer =  List();
  }

  int _currentQuestion = 0;
  List<Question> questions;
  final Function(List<String>) allAnswersHandle;
  final int questionLength;
  List<String> _allAnswer;
  final Question Function(Question answeredQuestion) questionIterateHandler;

  void defaultNextQuestionHandler(Question q) {
    setState(() {
      this._currentQuestion += 1;
      if (_currentQuestion <= questionLength) {
        this._allAnswer.add(q.selectedOption);
      }
      if (_currentQuestion == questionLength) {
        this.allAnswersHandle(this._allAnswer);
      }
    });
  }

  void customNextQuestionHandler(Question q) {
    setState(() {
      this._allAnswer.add(q.selectedOption);
      var nextQuestion = this.questionIterateHandler(q);
      if (nextQuestion == null) {
        this.allAnswersHandle(this._allAnswer);
      } else {
        this._currentQuestion = this.questions.indexOf(nextQuestion);
      }
    });
  }

  void toQuestion(Question q) {
    setState(() {
      this._currentQuestion = this.questions.indexOf(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: IndexedStack(
        children: <Widget>[
          ...questions.map((Question q) =>  QuestionPanel(
                question: q,
                callback: this.questionIterateHandler == null
                    ? defaultNextQuestionHandler
                    : customNextQuestionHandler,
                jumpTo: toQuestion,
              ))
        ],
        index: _currentQuestion,
      ),
    );
  }
}

class QuestionPanel extends StatelessWidget {
  final Question question;
  final Function(Question) callback;
  final Function(Question) jumpTo;

  QuestionPanel(
      {this.question, @required this.callback, @required this.jumpTo});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.question_answer,
                color: Theme.of(context).primaryColor),
            title: Text(
              question.question,
              style: Typography.dense2018.headline,
            ),
          ),
          Divider(),
          ...question.options.map((String option) => ListTile(
                title: Text(
                  option,
                  style: Typography.dense2018.body1,
                ),
                onTap: () {
                  this.question.selectedOption = option;
                  this.callback(question);
                },
              )),
          Divider(),
          Row(
            children: <Widget>[
              SizedBox(width: 10),
              if (question.prev != null)
                RaisedButton(
                  child: Text("上一个"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    this.jumpTo(question.prev);
                  },
                )
            ],
          )
        ],
      ),
    );
  }
}
