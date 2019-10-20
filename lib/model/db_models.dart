import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:moor_flutter/moor_flutter.dart';

import 'entities.dart';

part 'db_models.g.dart';

class LocalUsers extends Table {
  TextColumn get id => text().withLength(min: 32, max: 64)();

  TextColumn get name => text().withLength(max: 32)();

  TextColumn get token => text().named('token').withLength(min: 32, max: 64)();

  TextColumn get avatar => text()();
}

class LocalPlannedExercise extends Table {
  TextColumn get id => text().withLength(max: 64)();

  TextColumn get executeDate => text().withLength(max: 32)();

  IntColumn get exerciseTemplateId => integer()();

  IntColumn get userId => integer()();

  IntColumn get hasBeenExecuted => integer()();
}
//
//class LocalUserTrainings extends Table {
//  TextColumn get userId => text().withLength(min: 32, max: 64)();
//
//  TextColumn get planGoal => text().withLength(min: 32, max: 64)();
//
//  TextColumn get planType => text().withLength(min: 32, max: 64)();
//
//  IntColumn get totalTrainingWeeks => integer().nullable()();
//
//  IntColumn get sessionPerWeek => integer().nullable()();
//
//  TextColumn get extraNote => text().withLength(min: 32, max: 64)();
//
//  TextColumn get createdBy => text().withLength(min: 32, max: 64)();
//}
//
//class LocalTrainingExercises extends Table {
//  TextColumn get id => text().withLength(min: 32, max: 64)();
//
//  TextColumn get matchingPlanId => text().withLength(min: 32, max: 64)();
//
//  TextColumn get muscleTarget => text().withLength(min: 32, max: 64)();
//
//  TextColumn get name => text().withLength(min: 32, max: 64)();
//
//  TextColumn get description => text().withLength(min: 32, max: 64)();
//
//  IntColumn get recommendRestingTimeBetweenMovement => integer().nullable()();
//
//  DateTimeColumn get plannedDate => dateTime()();
//}
//
//class LocalExercisePlannedSets extends Table {
//  TextColumn get id => text().withLength(min: 64, max: 256)();
//
//  IntColumn get sequence => integer()();
//
//  TextColumn get setType => text().withLength(min: 32, max: 64)();
//
//  IntColumn get expectingRepeatsPerSet => integer()();
//
//  RealColumn get expectingWeight => real()();
//
//  RealColumn get reduceTo => real().nullable()();
//
//  RealColumn get reduceWeight => real().nullable()();
//
//  IntColumn get intervalTime => integer().nullable()();
//}
//
//class LocalPlannedSetsMovementMaps extends Table {
//  TextColumn get plannedSetId => text().withLength(min: 32, max: 64)();
//
//  TextColumn get movementId => text().withLength(min: 32, max: 64)();
//}
//
//class LocalMovements extends Table {
//  TextColumn get name => text().withLength(min: 32, max: 64)();
//
//  TextColumn get description => text().withLength(min: 32, max: 64)();
//
//  TextColumn get picReference => text().withLength(min: 32, max: 64)();
//
//  TextColumn get videoReference => text().withLength(min: 32, max: 64)();
//
//  TextColumn get involvedMuscle => text().withLength(min: 32, max: 64)();
//
//  //all time in seconds
//  IntColumn get recommendRestingTimeBetweenSet => integer().nullable()();
//}
//

class LocalCompletedSessions extends Table {
  IntColumn get sessionId => integer()();

  IntColumn get userId => integer()();

  IntColumn get exerciseId => integer()();

  IntColumn get plannedExerciseId => integer()();

  TextColumn get completedDate => text().withLength(max: 24)();
}
//
//class LocalCompletedExerciseSets extends Table {
//  TextColumn get id => text().withLength(min: 32, max: 64)();
//
//  TextColumn get plannedExerciseSetId => text().withLength(min: 32, max: 64)();
//
//  TextColumn get completedSessionsId => text().withLength(min: 32, max: 64)();
//
//  DateTimeColumn get completedTime =>
//      dateTime().withDefault(currentDateAndTime)();
//
//  RealColumn get completedWeight => real()();
//
//  IntColumn get completedReps => integer()();
//
//  IntColumn get restInterval => integer()();
//}

class LocalSessionMaterials extends Table {
  TextColumn get id => text().withLength(min: 32, max: 64)();

  TextColumn get filePath => text()();

  BoolColumn get isVideo => boolean()();

  TextColumn get sessionId => text().withLength(min: 32, max: 64)();
}

class LocalUserBodyIndex extends Table {
  TextColumn get id => text().withLength(max: 64)();

  TextColumn get bodyIndex => text()();

  RealColumn get value => real()();

  TextColumn get unit => text()();

  IntColumn get recordTime => integer()();

  TextColumn get userId => text()();
}

@UseMoor(tables: [
//  LocalCompletedExerciseSets,
//  LocalCompletedSessions,
//  LocalMovements,
//  LocalUserTrainings,
  LocalUsers,
//  LocalPlannedSetsMovementMaps,
//  LocalExercisePlannedSets,
//  LocalTrainingExercises,
  LocalSessionMaterials,
  LocalUserBodyIndex,
  LocalPlannedExercise,
  LocalCompletedSessions
])
class ExerciseDatabase extends _$ExerciseDatabase {
  ExerciseDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 3; // bump because the tables have changed

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAllTables();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // we added the dueDate property in the change from version 1
          await m.createTable(localPlannedExercise);
          await m.createTable(localCompletedSessions);
        }else if(from == 2){
          await m.createTable(localCompletedSessions);
        }
      });

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
        SessionMaterial sm = SessionMaterial.empty();
        sm.id = int.parse(lsm.id);
        sm.sessionId = lsm.sessionId;
        sm.storeLocation = lsm.filePath;
        sm.isVideo = lsm.isVideo;
        sessionMaterials.add(sm);
      });
      return sessionMaterials;
    });
  }

  Future<List<UserBodyIndex>> getUserBodyIndexes(String userId) {
//    return (select(localUserBodyIndex)..where((t) => t.userId.equals(userId)))
//        .get()
//        .then((List<LocalUserBodyIndexData> indexes) {
//      List<UserBodyIndex> result = List();
//      indexes.forEach((LocalUserBodyIndexData lubi) {
//        BodyIndex index = EnumToString.fromString(BodyIndex.values, lubi.index);
//        UserBodyIndex userBodyIndex =
//            UserBodyIndex(index, lubi.value, lubi.unit, lubi.recordTime);
//        result.add(userBodyIndex);
//      });
//      return result;
//    });
    return customSelect(
        "select l.* from local_user_body_index l "
        "left outer join local_user_body_index lm "
        "on l.body_index = lm.body_index and l.user_id = lm.user_id and l.record_time < lm.record_time "
        "where l.user_id = ? and lm.record_time is NULL order by l.record_time desc",
        variables: [Variable.withString(userId)]).then((List<QueryRow> rows) {
      List<UserBodyIndex> indexes = List();
      rows.forEach((QueryRow r) {
        indexes.add(UserBodyIndex.fromJson(r.data));
      });
      return indexes;
    });
  }

  Future<UserBodyIndex> insertBodyIndex(
      UserBodyIndex userIndex, String userId) async {
    LocalUserBodyIndexData index = LocalUserBodyIndexData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        value: userIndex.value,
        bodyIndex: userIndex.bodyIndex.toString(),
        recordTime: userIndex.recordTime == null
            ? DateTime.now().millisecondsSinceEpoch
            : userIndex.recordTime.millisecondsSinceEpoch,
        unit: userIndex.unit,
        userId: userId);
    into(localUserBodyIndex).insert(index);
    return userIndex;
  }

  Future<List<LocalPlannedExerciseData>> savePlannedExercise(
      Map<DateTime, UserPlannedExercise> exercises, int userId) async {
    List<LocalPlannedExerciseData> plannedExercise = List();
    (delete(localPlannedExercise)..where(
        //(t) => and(t.userId.equals(userId), t.hasBeenExecuted.equals(0))))
        (t) => t.userId.equals(userId))).go();
    for (DateTime key in exercises.keys) {
      LocalPlannedExerciseData row = LocalPlannedExerciseData(
          id: exercises[key].id.toString(),
          executeDate: DateFormat("yyyy-MM-dd").format(
            key,
          ),
          exerciseTemplateId: int.parse(exercises[key].exercise.id),
          hasBeenExecuted: exercises[key].hasBeenExecuted ? 1 : 0,
          userId: userId);
      into(localPlannedExercise).insert(row);
      plannedExercise.add(row);
    }
    return plannedExercise;
  }

  Future<List<UserPlannedExercise>> queryForPlannedExercise(int userId) {
    return (select(localPlannedExercise)..where((t) => t.userId.equals(userId)))
        .get()
        .then((List<LocalPlannedExerciseData> value) {
      List<UserPlannedExercise> plannedExercises = List();
      value.forEach((LocalPlannedExerciseData localPlannedExercise) {
        plannedExercises
            .add(parseToUserPlannedExercise(localPlannedExercise, userId));
      });
      return plannedExercises;
    });
  }

  UserPlannedExercise parseToUserPlannedExercise(
      LocalPlannedExerciseData localPlannedExercise, int userId) {
    UserPlannedExercise planned = UserPlannedExercise();
    if (localPlannedExercise == null) {
      return planned;
    }
    planned.id = int.parse(localPlannedExercise.id);
    planned.exercise = Exercise.empty();
    planned.exercise.id = localPlannedExercise.exerciseTemplateId.toString();
    planned.hasBeenExecuted = localPlannedExercise.hasBeenExecuted == 1;
    planned.userId = userId;
    planned.executeDate =
        DateFormat('yyyy-MM-dd').parse(localPlannedExercise.executeDate);
    return planned;
  }

  Future<UserPlannedExercise> queryForPlannedExerciseByUserAndDate(
      int userId, String date) {
    return (select(localPlannedExercise)
          ..where(
              (e) => and(e.userId.equals(userId), e.executeDate.equals(date))))
        .getSingle()
        .then((LocalPlannedExerciseData data) {
      return parseToUserPlannedExercise(data, -1);
    });
  }

  Future updateUserPlannedExercise(int plannedExerciseId) {
    return (update(localPlannedExercise)
          ..where((p) => p.id.equals(plannedExerciseId.toString())))
        .write(LocalPlannedExerciseCompanion(hasBeenExecuted: Value(1)));
  }

  Future switchUserPlannedExerciseExecutionDate(
      UserPlannedExercise from, UserPlannedExercise to) {
    String fromDate = DateFormat('yyyy-MM-dd').format(from.executeDate);
    String toDate = DateFormat('yyyy-MM-dd').format(to.executeDate);

    return Future.wait([
      (update(localPlannedExercise)
            ..where((p) => p.id.equals(from.id.toString())))
          .write(LocalPlannedExerciseCompanion(executeDate: Value(toDate))),
      (update(localPlannedExercise)
            ..where((p) => p.id.equals(to.id.toString())))
          .write(LocalPlannedExerciseCompanion(executeDate: Value(fromDate)))
    ]);
  }

  Future insertSessionCompleted(Session completed, int userId) {
    LocalCompletedSession completedSession = LocalCompletedSession(
        sessionId: int.parse(completed.id),
        exerciseId: int.parse(completed.matchingExercise.id),
        userId: userId,
        completedDate:
            DateFormat('yyyy-MM-dd').format(completed.accomplishedTime),
        plannedExerciseId: completed.matchingPlannedExerciseId);
    return into(localCompletedSessions).insert(completedSession);
  }

  Future<LocalCompletedSession> getCompletedInfo(String date, int userId) {
    return (select(localCompletedSessions)
          ..where((e) =>
              and(e.completedDate.equals(date), e.userId.equals(userId))))
        .getSingle();
  }

  Future<List<LocalCompletedSession>> getUserCompletedInfo(int userId) {
    return (select(localCompletedSessions)
          ..where((e) => e.userId.equals(userId)))
        .get();
  }
}
