import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';

import 'entities.dart';

part 'db_models.g.dart';

class LocalUsers extends Table {
  TextColumn get id => text().withLength(min: 32, max: 64)();

  TextColumn get name => text().withLength(max: 32)();

  TextColumn get token => text().named('token').withLength(min: 32, max: 64)();
}

class LocalUserTrainings extends Table {
  TextColumn get userId => text().withLength(min: 32, max: 64)();

  TextColumn get planGoal => text().withLength(min: 32, max: 64)();

  TextColumn get planType => text().withLength(min: 32, max: 64)();

  IntColumn get totalTrainingWeeks => integer().nullable()();

  IntColumn get sessionPerWeek => integer().nullable()();

  TextColumn get extraNote => text().withLength(min: 32, max: 64)();

  TextColumn get createdBy => text().withLength(min: 32, max: 64)();
}

class LocalTrainingExercises extends Table {
  TextColumn get id => text().withLength(min: 32, max: 64)();

  TextColumn get matchingPlanId => text().withLength(min: 32, max: 64)();

  TextColumn get muscleTarget => text().withLength(min: 32, max: 64)();

  TextColumn get name => text().withLength(min: 32, max: 64)();

  TextColumn get description => text().withLength(min: 32, max: 64)();

  IntColumn get recommendRestingTimeBetweenMovement => integer().nullable()();

  DateTimeColumn get plannedDate => dateTime()();
}

class LocalExercisePlannedSets extends Table {
  TextColumn get id => text().withLength(min: 64, max: 256)();

  IntColumn get sequence => integer()();

  TextColumn get setType => text().withLength(min: 32, max: 64)();

  IntColumn get expectingRepeatsPerSet => integer()();

  RealColumn get expectingWeight => real()();

  RealColumn get reduceTo => real().nullable()();

  RealColumn get reduceWeight => real().nullable()();

  IntColumn get intervalTime => integer().nullable()();
}

class LocalPlannedSetsMovementMaps extends Table {
  TextColumn get plannedSetId => text().withLength(min: 32, max: 64)();

  TextColumn get movementId => text().withLength(min: 32, max: 64)();
}

class LocalMovements extends Table {
  TextColumn get name => text().withLength(min: 32, max: 64)();

  TextColumn get description => text().withLength(min: 32, max: 64)();

  TextColumn get picReference => text().withLength(min: 32, max: 64)();

  TextColumn get videoReference => text().withLength(min: 32, max: 64)();

  TextColumn get involvedMuscle => text().withLength(min: 32, max: 64)();

  //all time in seconds
  IntColumn get recommendRestingTimeBetweenSet => integer().nullable()();
}

class LocalCompletedSessions extends Table {
  TextColumn get id => text().withLength(min: 32, max: 64)();

  TextColumn get trainingExerciseId => text().withLength(min: 32, max: 64)();

  DateTimeColumn get completedDate =>
      dateTime().withDefault(currentDateAndTime)();
}

class LocalCompletedExerciseSets extends Table {
  TextColumn get id => text().withLength(min: 32, max: 64)();

  TextColumn get plannedExerciseSetId => text().withLength(min: 32, max: 64)();

  TextColumn get completedSessionsId => text().withLength(min: 32, max: 64)();

  DateTimeColumn get completedTime =>
      dateTime().withDefault(currentDateAndTime)();

  RealColumn get completedWeight => real()();

  IntColumn get completedReps => integer()();

  IntColumn get restInterval => integer()();
}

class LocalSessionMaterials extends Table {
  TextColumn get id => text().withLength(min: 32, max: 64)();

  TextColumn get filePath => text()();

  BoolColumn get isVideo => boolean()();

  TextColumn get sessionId => text().withLength(min: 32, max: 64)();
}

@UseMoor(tables: [
  LocalCompletedExerciseSets,
  LocalCompletedSessions,
  LocalMovements,
  LocalUserTrainings,
  LocalUsers,
  LocalPlannedSetsMovementMaps,
  LocalExercisePlannedSets,
  LocalTrainingExercises,
  LocalSessionMaterials
])
class ExerciseDatabase extends _$ExerciseDatabase {
  ExerciseDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;

  void addSessionMaterial(SessionMaterial sessionMaterial) {
    if (sessionMaterial.id == null) {}
    String jsonValue = jsonEncode(sessionMaterial);
    LocalSessionMaterial lsm =
        LocalSessionMaterial.fromJson(jsonDecode(jsonValue));
    into(localSessionMaterials).insert(lsm);
  }

  Future<List<SessionMaterial>> getSessionMaterialsBySessionId(String id) {
    return (select(localSessionMaterials)..where((t) => t.sessionId.equals(id)))
        .get()
        .then((List<LocalSessionMaterial> result) {
      List<SessionMaterial> sessionMaterials = List();
      result.forEach((LocalSessionMaterial lsm) {
        SessionMaterial sm = SessionMaterial();
        sm.id = lsm.id;
        sm.sessionId = lsm.sessionId;
        sm.filePath = lsm.filePath;
        sm.isVideo = lsm.isVideo;
        sessionMaterials.add(sm);
      });
      return sessionMaterials;
    });
  }
}