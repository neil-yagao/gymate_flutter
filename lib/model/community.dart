import 'package:json_annotation/json_annotation.dart';
import 'package:workout_helper/model/user_event.dart';

import 'entities.dart';

part 'community.g.dart';

abstract class AbstractCommunityText {
  int id;
}

@JsonSerializable()
class Post extends AbstractCommunityText {
  String title;

  String content;

  User postBy;

  DateTime postAt;

  int recommendedCount;

  List<Comment> replies;

  List<PostMaterial> relatedPics;

  String topic;

  Post(id, this.title, this.content, this.postBy, this.postAt,
      this.recommendedCount, this.replies, this.relatedPics, this.topic) {
    super.id = id;
  }

  Post.empty();

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class Comment extends AbstractCommunityText {
  String content;

  User postBy;

  DateTime postAt;

  int recommendedCount;

  List<Comment> replies;

  Post belongTo;

  Comment replyTo;

  Comment(id, this.content, this.postBy, this.postAt, this.recommendedCount,
      this.replies, this.belongTo, this.replyTo) {
    super.id = id;
  }

  Comment.empty();

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class PostMaterial {
  String storedAt;

  DateTime uploadedAt;

  PostMaterial(this.storedAt, this.uploadedAt);

  PostMaterial.empty();

  factory PostMaterial.fromJson(Map<String, dynamic> json) =>
      _$PostMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$PostMaterialToJson(this);
}

@JsonSerializable()
class Recommend {
  User recommendBy;

  int recommendTargetId;

  UserEventType target;

  User targetOwner;

  double recommendScore;

  Recommend.empty();

  factory Recommend.fromJson(Map<String, dynamic> json) =>
      _$RecommendFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendToJson(this);

  Recommend(this.recommendBy, this.recommendTargetId, this.target,
      this.targetOwner, this.recommendScore);


}
