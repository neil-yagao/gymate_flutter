import 'package:json_annotation/json_annotation.dart';

import 'entities.dart';

part 'movement.g.dart';

@JsonSerializable()
class MovementMaterial {
  int id;

  User uploadBy;

  Movement movement;

  String analysedMovementPlace;

  double weeklyScore;

  int totalRecommendation;

  double rate;

  String rawVideoPlace;

  String frontPagePic;

  DateTime uploadAt;

  double aspectRatio;

  bool landscape;

  MovementMaterial(
      this.id,
      this.uploadBy,
      this.movement,
      this.analysedMovementPlace,
      this.weeklyScore,
      this.totalRecommendation,
      this.rate,
      this.rawVideoPlace,
      this.frontPagePic,
      this.uploadAt,
      this.aspectRatio,
      this.landscape);

  MovementMaterial.empty();

  factory MovementMaterial.fromJson(Map<String, dynamic> json) =>
      _$MovementMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$MovementMaterialToJson(this);
}

///训练动作
@JsonSerializable()
class Movement implements Cloneable<Movement> {
  String id;
  String name;
  String description;
  String picReference;
  String videoReference;

  ExerciseType exerciseType;

  List<MuscleGroup> involvedMuscle;

  //all time in seconds
  int recommendRestingTimeBetweenSet;

  int defaultMaterialId;

  Movement(
      this.id,
      this.name,
      this.description,
      this.picReference,
      this.videoReference,
      this.exerciseType,
      this.involvedMuscle,
      this.recommendRestingTimeBetweenSet,
      this.defaultMaterialId);

  Movement.empty();

  factory Movement.fromJson(Map<String, dynamic> json) =>
      _$MovementFromJson(json);

  Map<String, dynamic> toJson() => _$MovementToJson(this);

  @override
  String toString() {
    return name;
  }

  @override
  void clone(Movement movement) {
    this.id = movement.id;
    this.name = movement.name;
    this.description = movement.description;
    this.picReference = movement.picReference;
    this.involvedMuscle = movement.involvedMuscle;
    this.recommendRestingTimeBetweenSet =
        movement.recommendRestingTimeBetweenSet;
    this.videoReference = movement.videoReference;
  }

  int get hashCode {
    return this.id.hashCode;
  }

  bool operator ==(Object other) {
    if (other is Movement) {
      return this.id == other.id && this.name == other.name;
    }
    return false;
  }
}

@JsonSerializable()
class UserMovementMaterial {
  int id;

  String storeLocation;

  bool isVideo;

  String sessionId;

  Movement matchingMovement;

  String processedUrl;

  ProcessStatus status;

  double aspectRatio;

  bool landscape;

  UserMovementMaterial(
      this.id,
      this.storeLocation,
      this.isVideo,
      this.sessionId,
      this.matchingMovement,
      this.processedUrl,
      this.status,
      this.aspectRatio,
      this.landscape);

  UserMovementMaterial.empty();

  factory UserMovementMaterial.fromJson(Map<String, dynamic> json) =>
      _$UserMovementMaterialFromJson(json);

  Map<String, dynamic> toJson() => _$UserMovementMaterialToJson(this);
}

enum ProcessStatus { PROCESSING, PROCESS_SUCCESS, PROCESS_FAILURE }
