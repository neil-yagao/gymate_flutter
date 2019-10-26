import 'entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_event.g.dart';

@JsonSerializable()
class UserEvent {

  int id;
  User user;
  int relatedRecordId;
  UserEventType type;
  double extraScore;
  DateTime happenedAt;

  dynamic relatedRecord;


  UserEvent(this.id, this.user, this.relatedRecordId, this.type,
      this.extraScore, this.happenedAt);

  UserEvent.empty();
  factory UserEvent.fromJson(Map<String, dynamic> json) => _$UserEventFromJson(json);

  Map<String, dynamic> toJson() => _$UserEventToJson(this);
}

@JsonSerializable()
class Membership{
  double currentScore;

  String memberLevel;

  String paidUser;

  DateTime validateUntil;

  Membership(this.currentScore, this.memberLevel, this.paidUser,
      this.validateUntil);

  Membership.empty();
  factory Membership.fromJson(Map<String, dynamic> json) => _$MembershipFromJson(json);

  Map<String, dynamic> toJson() => _$MembershipToJson(this);


}


// ignore: slash_for_doc_comments
enum UserEventType{
  Session,

  /**
   * gain 1 point for each nutrition
   */
  NutritionRecord,

  /**
   * no point
   */
  OneRepMax,
  /**
   * no point
   */
  Post,

  /**
   * no point,
   */
  Reply,

  /**
   * consume 20 + extra points
   */
  Question,

  /**
   * if the reply is accepted, then replier get 50% of the score
   * and resting replies gets remained 50% based on the reply recommendation
   */
  QuestionReply,
  /**
   * will get the 50% score of the question points
   * once the question have been accepted,
   * it still can be recommended score will still sending out.
   */
  QuestionApplyAccepted,

  /**
   * target user gain 1 points
   * target gain 2 points
   */
  Recommended,

  /**
   * 10 points for create new template
   */
  Exercise,

  /**
   * 5 points for upload new movement
   * 2 points for upload new movement material
   */
  Movement,

  Movement_Material,
  /**
   * 20 points for create new training plan
   */
  TrainingPlan,

}