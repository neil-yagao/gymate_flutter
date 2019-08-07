// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_models.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class LocalCompletedExerciseSet extends DataClass
    implements Insertable<LocalCompletedExerciseSet> {
  final String id;
  final String plannedExerciseSetId;
  final String completedSessionsId;
  final DateTime completedTime;
  final double completedWeight;
  final int completedReps;
  final int restInterval;
  LocalCompletedExerciseSet(
      {@required this.id,
      @required this.plannedExerciseSetId,
      @required this.completedSessionsId,
      @required this.completedTime,
      @required this.completedWeight,
      @required this.completedReps,
      @required this.restInterval});
  factory LocalCompletedExerciseSet.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    final intType = db.typeSystem.forDartType<int>();
    return LocalCompletedExerciseSet(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      plannedExerciseSetId: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}planned_exercise_set_id']),
      completedSessionsId: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}completed_sessions_id']),
      completedTime: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}completed_time']),
      completedWeight: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}completed_weight']),
      completedReps: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}completed_reps']),
      restInterval: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}rest_interval']),
    );
  }
  factory LocalCompletedExerciseSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalCompletedExerciseSet(
      id: serializer.fromJson<String>(json['id']),
      plannedExerciseSetId:
          serializer.fromJson<String>(json['plannedExerciseSetId']),
      completedSessionsId:
          serializer.fromJson<String>(json['completedSessionsId']),
      completedTime: serializer.fromJson<DateTime>(json['completedTime']),
      completedWeight: serializer.fromJson<double>(json['completedWeight']),
      completedReps: serializer.fromJson<int>(json['completedReps']),
      restInterval: serializer.fromJson<int>(json['restInterval']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'plannedExerciseSetId': serializer.toJson<String>(plannedExerciseSetId),
      'completedSessionsId': serializer.toJson<String>(completedSessionsId),
      'completedTime': serializer.toJson<DateTime>(completedTime),
      'completedWeight': serializer.toJson<double>(completedWeight),
      'completedReps': serializer.toJson<int>(completedReps),
      'restInterval': serializer.toJson<int>(restInterval),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalCompletedExerciseSet>>(
      bool nullToAbsent) {
    return LocalCompletedExerciseSetsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      plannedExerciseSetId: plannedExerciseSetId == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedExerciseSetId),
      completedSessionsId: completedSessionsId == null && nullToAbsent
          ? const Value.absent()
          : Value(completedSessionsId),
      completedTime: completedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(completedTime),
      completedWeight: completedWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(completedWeight),
      completedReps: completedReps == null && nullToAbsent
          ? const Value.absent()
          : Value(completedReps),
      restInterval: restInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(restInterval),
    ) as T;
  }

  LocalCompletedExerciseSet copyWith(
          {String id,
          String plannedExerciseSetId,
          String completedSessionsId,
          DateTime completedTime,
          double completedWeight,
          int completedReps,
          int restInterval}) =>
      LocalCompletedExerciseSet(
        id: id ?? this.id,
        plannedExerciseSetId: plannedExerciseSetId ?? this.plannedExerciseSetId,
        completedSessionsId: completedSessionsId ?? this.completedSessionsId,
        completedTime: completedTime ?? this.completedTime,
        completedWeight: completedWeight ?? this.completedWeight,
        completedReps: completedReps ?? this.completedReps,
        restInterval: restInterval ?? this.restInterval,
      );
  @override
  String toString() {
    return (StringBuffer('LocalCompletedExerciseSet(')
          ..write('id: $id, ')
          ..write('plannedExerciseSetId: $plannedExerciseSetId, ')
          ..write('completedSessionsId: $completedSessionsId, ')
          ..write('completedTime: $completedTime, ')
          ..write('completedWeight: $completedWeight, ')
          ..write('completedReps: $completedReps, ')
          ..write('restInterval: $restInterval')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc(
                      $mrjc(
                          $mrjc(0, id.hashCode), plannedExerciseSetId.hashCode),
                      completedSessionsId.hashCode),
                  completedTime.hashCode),
              completedWeight.hashCode),
          completedReps.hashCode),
      restInterval.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalCompletedExerciseSet &&
          other.id == id &&
          other.plannedExerciseSetId == plannedExerciseSetId &&
          other.completedSessionsId == completedSessionsId &&
          other.completedTime == completedTime &&
          other.completedWeight == completedWeight &&
          other.completedReps == completedReps &&
          other.restInterval == restInterval);
}

class LocalCompletedExerciseSetsCompanion
    extends UpdateCompanion<LocalCompletedExerciseSet> {
  final Value<String> id;
  final Value<String> plannedExerciseSetId;
  final Value<String> completedSessionsId;
  final Value<DateTime> completedTime;
  final Value<double> completedWeight;
  final Value<int> completedReps;
  final Value<int> restInterval;
  const LocalCompletedExerciseSetsCompanion({
    this.id = const Value.absent(),
    this.plannedExerciseSetId = const Value.absent(),
    this.completedSessionsId = const Value.absent(),
    this.completedTime = const Value.absent(),
    this.completedWeight = const Value.absent(),
    this.completedReps = const Value.absent(),
    this.restInterval = const Value.absent(),
  });
}

class $LocalCompletedExerciseSetsTable extends LocalCompletedExerciseSets
    with
        TableInfo<$LocalCompletedExerciseSetsTable, LocalCompletedExerciseSet> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalCompletedExerciseSetsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _plannedExerciseSetIdMeta =
      const VerificationMeta('plannedExerciseSetId');
  GeneratedTextColumn _plannedExerciseSetId;
  @override
  GeneratedTextColumn get plannedExerciseSetId =>
      _plannedExerciseSetId ??= _constructPlannedExerciseSetId();
  GeneratedTextColumn _constructPlannedExerciseSetId() {
    return GeneratedTextColumn('planned_exercise_set_id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _completedSessionsIdMeta =
      const VerificationMeta('completedSessionsId');
  GeneratedTextColumn _completedSessionsId;
  @override
  GeneratedTextColumn get completedSessionsId =>
      _completedSessionsId ??= _constructCompletedSessionsId();
  GeneratedTextColumn _constructCompletedSessionsId() {
    return GeneratedTextColumn('completed_sessions_id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _completedTimeMeta =
      const VerificationMeta('completedTime');
  GeneratedDateTimeColumn _completedTime;
  @override
  GeneratedDateTimeColumn get completedTime =>
      _completedTime ??= _constructCompletedTime();
  GeneratedDateTimeColumn _constructCompletedTime() {
    return GeneratedDateTimeColumn('completed_time', $tableName, false,
        defaultValue: currentDateAndTime);
  }

  final VerificationMeta _completedWeightMeta =
      const VerificationMeta('completedWeight');
  GeneratedRealColumn _completedWeight;
  @override
  GeneratedRealColumn get completedWeight =>
      _completedWeight ??= _constructCompletedWeight();
  GeneratedRealColumn _constructCompletedWeight() {
    return GeneratedRealColumn(
      'completed_weight',
      $tableName,
      false,
    );
  }

  final VerificationMeta _completedRepsMeta =
      const VerificationMeta('completedReps');
  GeneratedIntColumn _completedReps;
  @override
  GeneratedIntColumn get completedReps =>
      _completedReps ??= _constructCompletedReps();
  GeneratedIntColumn _constructCompletedReps() {
    return GeneratedIntColumn(
      'completed_reps',
      $tableName,
      false,
    );
  }

  final VerificationMeta _restIntervalMeta =
      const VerificationMeta('restInterval');
  GeneratedIntColumn _restInterval;
  @override
  GeneratedIntColumn get restInterval =>
      _restInterval ??= _constructRestInterval();
  GeneratedIntColumn _constructRestInterval() {
    return GeneratedIntColumn(
      'rest_interval',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        plannedExerciseSetId,
        completedSessionsId,
        completedTime,
        completedWeight,
        completedReps,
        restInterval
      ];
  @override
  $LocalCompletedExerciseSetsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_completed_exercise_sets';
  @override
  final String actualTableName = 'local_completed_exercise_sets';
  @override
  VerificationContext validateIntegrity(LocalCompletedExerciseSetsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.plannedExerciseSetId.present) {
      context.handle(
          _plannedExerciseSetIdMeta,
          plannedExerciseSetId.isAcceptableValue(
              d.plannedExerciseSetId.value, _plannedExerciseSetIdMeta));
    } else if (plannedExerciseSetId.isRequired && isInserting) {
      context.missing(_plannedExerciseSetIdMeta);
    }
    if (d.completedSessionsId.present) {
      context.handle(
          _completedSessionsIdMeta,
          completedSessionsId.isAcceptableValue(
              d.completedSessionsId.value, _completedSessionsIdMeta));
    } else if (completedSessionsId.isRequired && isInserting) {
      context.missing(_completedSessionsIdMeta);
    }
    if (d.completedTime.present) {
      context.handle(
          _completedTimeMeta,
          completedTime.isAcceptableValue(
              d.completedTime.value, _completedTimeMeta));
    } else if (completedTime.isRequired && isInserting) {
      context.missing(_completedTimeMeta);
    }
    if (d.completedWeight.present) {
      context.handle(
          _completedWeightMeta,
          completedWeight.isAcceptableValue(
              d.completedWeight.value, _completedWeightMeta));
    } else if (completedWeight.isRequired && isInserting) {
      context.missing(_completedWeightMeta);
    }
    if (d.completedReps.present) {
      context.handle(
          _completedRepsMeta,
          completedReps.isAcceptableValue(
              d.completedReps.value, _completedRepsMeta));
    } else if (completedReps.isRequired && isInserting) {
      context.missing(_completedRepsMeta);
    }
    if (d.restInterval.present) {
      context.handle(
          _restIntervalMeta,
          restInterval.isAcceptableValue(
              d.restInterval.value, _restIntervalMeta));
    } else if (restInterval.isRequired && isInserting) {
      context.missing(_restIntervalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalCompletedExerciseSet map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalCompletedExerciseSet.fromData(data, _db,
        prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalCompletedExerciseSetsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.plannedExerciseSetId.present) {
      map['planned_exercise_set_id'] =
          Variable<String, StringType>(d.plannedExerciseSetId.value);
    }
    if (d.completedSessionsId.present) {
      map['completed_sessions_id'] =
          Variable<String, StringType>(d.completedSessionsId.value);
    }
    if (d.completedTime.present) {
      map['completed_time'] =
          Variable<DateTime, DateTimeType>(d.completedTime.value);
    }
    if (d.completedWeight.present) {
      map['completed_weight'] =
          Variable<double, RealType>(d.completedWeight.value);
    }
    if (d.completedReps.present) {
      map['completed_reps'] = Variable<int, IntType>(d.completedReps.value);
    }
    if (d.restInterval.present) {
      map['rest_interval'] = Variable<int, IntType>(d.restInterval.value);
    }
    return map;
  }

  @override
  $LocalCompletedExerciseSetsTable createAlias(String alias) {
    return $LocalCompletedExerciseSetsTable(_db, alias);
  }
}

class LocalCompletedSession extends DataClass
    implements Insertable<LocalCompletedSession> {
  final String id;
  final String trainingExerciseId;
  final DateTime completedDate;
  LocalCompletedSession(
      {@required this.id,
      @required this.trainingExerciseId,
      @required this.completedDate});
  factory LocalCompletedSession.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return LocalCompletedSession(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      trainingExerciseId: stringType.mapFromDatabaseResponse(
          data['${effectivePrefix}training_exercise_id']),
      completedDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}completed_date']),
    );
  }
  factory LocalCompletedSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalCompletedSession(
      id: serializer.fromJson<String>(json['id']),
      trainingExerciseId:
          serializer.fromJson<String>(json['trainingExerciseId']),
      completedDate: serializer.fromJson<DateTime>(json['completedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'trainingExerciseId': serializer.toJson<String>(trainingExerciseId),
      'completedDate': serializer.toJson<DateTime>(completedDate),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalCompletedSession>>(
      bool nullToAbsent) {
    return LocalCompletedSessionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      trainingExerciseId: trainingExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingExerciseId),
      completedDate: completedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDate),
    ) as T;
  }

  LocalCompletedSession copyWith(
          {String id, String trainingExerciseId, DateTime completedDate}) =>
      LocalCompletedSession(
        id: id ?? this.id,
        trainingExerciseId: trainingExerciseId ?? this.trainingExerciseId,
        completedDate: completedDate ?? this.completedDate,
      );
  @override
  String toString() {
    return (StringBuffer('LocalCompletedSession(')
          ..write('id: $id, ')
          ..write('trainingExerciseId: $trainingExerciseId, ')
          ..write('completedDate: $completedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc($mrjc(0, id.hashCode), trainingExerciseId.hashCode),
      completedDate.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalCompletedSession &&
          other.id == id &&
          other.trainingExerciseId == trainingExerciseId &&
          other.completedDate == completedDate);
}

class LocalCompletedSessionsCompanion
    extends UpdateCompanion<LocalCompletedSession> {
  final Value<String> id;
  final Value<String> trainingExerciseId;
  final Value<DateTime> completedDate;
  const LocalCompletedSessionsCompanion({
    this.id = const Value.absent(),
    this.trainingExerciseId = const Value.absent(),
    this.completedDate = const Value.absent(),
  });
}

class $LocalCompletedSessionsTable extends LocalCompletedSessions
    with TableInfo<$LocalCompletedSessionsTable, LocalCompletedSession> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalCompletedSessionsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _trainingExerciseIdMeta =
      const VerificationMeta('trainingExerciseId');
  GeneratedTextColumn _trainingExerciseId;
  @override
  GeneratedTextColumn get trainingExerciseId =>
      _trainingExerciseId ??= _constructTrainingExerciseId();
  GeneratedTextColumn _constructTrainingExerciseId() {
    return GeneratedTextColumn('training_exercise_id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _completedDateMeta =
      const VerificationMeta('completedDate');
  GeneratedDateTimeColumn _completedDate;
  @override
  GeneratedDateTimeColumn get completedDate =>
      _completedDate ??= _constructCompletedDate();
  GeneratedDateTimeColumn _constructCompletedDate() {
    return GeneratedDateTimeColumn('completed_date', $tableName, false,
        defaultValue: currentDateAndTime);
  }

  @override
  List<GeneratedColumn> get $columns => [id, trainingExerciseId, completedDate];
  @override
  $LocalCompletedSessionsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_completed_sessions';
  @override
  final String actualTableName = 'local_completed_sessions';
  @override
  VerificationContext validateIntegrity(LocalCompletedSessionsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.trainingExerciseId.present) {
      context.handle(
          _trainingExerciseIdMeta,
          trainingExerciseId.isAcceptableValue(
              d.trainingExerciseId.value, _trainingExerciseIdMeta));
    } else if (trainingExerciseId.isRequired && isInserting) {
      context.missing(_trainingExerciseIdMeta);
    }
    if (d.completedDate.present) {
      context.handle(
          _completedDateMeta,
          completedDate.isAcceptableValue(
              d.completedDate.value, _completedDateMeta));
    } else if (completedDate.isRequired && isInserting) {
      context.missing(_completedDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalCompletedSession map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalCompletedSession.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalCompletedSessionsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.trainingExerciseId.present) {
      map['training_exercise_id'] =
          Variable<String, StringType>(d.trainingExerciseId.value);
    }
    if (d.completedDate.present) {
      map['completed_date'] =
          Variable<DateTime, DateTimeType>(d.completedDate.value);
    }
    return map;
  }

  @override
  $LocalCompletedSessionsTable createAlias(String alias) {
    return $LocalCompletedSessionsTable(_db, alias);
  }
}

class LocalMovement extends DataClass implements Insertable<LocalMovement> {
  final String name;
  final String description;
  final String picReference;
  final String videoReference;
  final String involvedMuscle;
  final int recommendRestingTimeBetweenSet;
  LocalMovement(
      {@required this.name,
      @required this.description,
      @required this.picReference,
      @required this.videoReference,
      @required this.involvedMuscle,
      this.recommendRestingTimeBetweenSet});
  factory LocalMovement.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return LocalMovement(
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      picReference: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}pic_reference']),
      videoReference: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}video_reference']),
      involvedMuscle: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}involved_muscle']),
      recommendRestingTimeBetweenSet: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}recommend_resting_time_between_set']),
    );
  }
  factory LocalMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalMovement(
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      picReference: serializer.fromJson<String>(json['picReference']),
      videoReference: serializer.fromJson<String>(json['videoReference']),
      involvedMuscle: serializer.fromJson<String>(json['involvedMuscle']),
      recommendRestingTimeBetweenSet:
          serializer.fromJson<int>(json['recommendRestingTimeBetweenSet']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'picReference': serializer.toJson<String>(picReference),
      'videoReference': serializer.toJson<String>(videoReference),
      'involvedMuscle': serializer.toJson<String>(involvedMuscle),
      'recommendRestingTimeBetweenSet':
          serializer.toJson<int>(recommendRestingTimeBetweenSet),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalMovement>>(
      bool nullToAbsent) {
    return LocalMovementsCompanion(
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      picReference: picReference == null && nullToAbsent
          ? const Value.absent()
          : Value(picReference),
      videoReference: videoReference == null && nullToAbsent
          ? const Value.absent()
          : Value(videoReference),
      involvedMuscle: involvedMuscle == null && nullToAbsent
          ? const Value.absent()
          : Value(involvedMuscle),
      recommendRestingTimeBetweenSet:
          recommendRestingTimeBetweenSet == null && nullToAbsent
              ? const Value.absent()
              : Value(recommendRestingTimeBetweenSet),
    ) as T;
  }

  LocalMovement copyWith(
          {String name,
          String description,
          String picReference,
          String videoReference,
          String involvedMuscle,
          int recommendRestingTimeBetweenSet}) =>
      LocalMovement(
        name: name ?? this.name,
        description: description ?? this.description,
        picReference: picReference ?? this.picReference,
        videoReference: videoReference ?? this.videoReference,
        involvedMuscle: involvedMuscle ?? this.involvedMuscle,
        recommendRestingTimeBetweenSet: recommendRestingTimeBetweenSet ??
            this.recommendRestingTimeBetweenSet,
      );
  @override
  String toString() {
    return (StringBuffer('LocalMovement(')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('picReference: $picReference, ')
          ..write('videoReference: $videoReference, ')
          ..write('involvedMuscle: $involvedMuscle, ')
          ..write(
              'recommendRestingTimeBetweenSet: $recommendRestingTimeBetweenSet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc($mrjc($mrjc(0, name.hashCode), description.hashCode),
                  picReference.hashCode),
              videoReference.hashCode),
          involvedMuscle.hashCode),
      recommendRestingTimeBetweenSet.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalMovement &&
          other.name == name &&
          other.description == description &&
          other.picReference == picReference &&
          other.videoReference == videoReference &&
          other.involvedMuscle == involvedMuscle &&
          other.recommendRestingTimeBetweenSet ==
              recommendRestingTimeBetweenSet);
}

class LocalMovementsCompanion extends UpdateCompanion<LocalMovement> {
  final Value<String> name;
  final Value<String> description;
  final Value<String> picReference;
  final Value<String> videoReference;
  final Value<String> involvedMuscle;
  final Value<int> recommendRestingTimeBetweenSet;
  const LocalMovementsCompanion({
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.picReference = const Value.absent(),
    this.videoReference = const Value.absent(),
    this.involvedMuscle = const Value.absent(),
    this.recommendRestingTimeBetweenSet = const Value.absent(),
  });
}

class $LocalMovementsTable extends LocalMovements
    with TableInfo<$LocalMovementsTable, LocalMovement> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalMovementsTable(this._db, [this._alias]);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn('description', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _picReferenceMeta =
      const VerificationMeta('picReference');
  GeneratedTextColumn _picReference;
  @override
  GeneratedTextColumn get picReference =>
      _picReference ??= _constructPicReference();
  GeneratedTextColumn _constructPicReference() {
    return GeneratedTextColumn('pic_reference', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _videoReferenceMeta =
      const VerificationMeta('videoReference');
  GeneratedTextColumn _videoReference;
  @override
  GeneratedTextColumn get videoReference =>
      _videoReference ??= _constructVideoReference();
  GeneratedTextColumn _constructVideoReference() {
    return GeneratedTextColumn('video_reference', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _involvedMuscleMeta =
      const VerificationMeta('involvedMuscle');
  GeneratedTextColumn _involvedMuscle;
  @override
  GeneratedTextColumn get involvedMuscle =>
      _involvedMuscle ??= _constructInvolvedMuscle();
  GeneratedTextColumn _constructInvolvedMuscle() {
    return GeneratedTextColumn('involved_muscle', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _recommendRestingTimeBetweenSetMeta =
      const VerificationMeta('recommendRestingTimeBetweenSet');
  GeneratedIntColumn _recommendRestingTimeBetweenSet;
  @override
  GeneratedIntColumn get recommendRestingTimeBetweenSet =>
      _recommendRestingTimeBetweenSet ??=
          _constructRecommendRestingTimeBetweenSet();
  GeneratedIntColumn _constructRecommendRestingTimeBetweenSet() {
    return GeneratedIntColumn(
      'recommend_resting_time_between_set',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        name,
        description,
        picReference,
        videoReference,
        involvedMuscle,
        recommendRestingTimeBetweenSet
      ];
  @override
  $LocalMovementsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_movements';
  @override
  final String actualTableName = 'local_movements';
  @override
  VerificationContext validateIntegrity(LocalMovementsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.description.present) {
      context.handle(_descriptionMeta,
          description.isAcceptableValue(d.description.value, _descriptionMeta));
    } else if (description.isRequired && isInserting) {
      context.missing(_descriptionMeta);
    }
    if (d.picReference.present) {
      context.handle(
          _picReferenceMeta,
          picReference.isAcceptableValue(
              d.picReference.value, _picReferenceMeta));
    } else if (picReference.isRequired && isInserting) {
      context.missing(_picReferenceMeta);
    }
    if (d.videoReference.present) {
      context.handle(
          _videoReferenceMeta,
          videoReference.isAcceptableValue(
              d.videoReference.value, _videoReferenceMeta));
    } else if (videoReference.isRequired && isInserting) {
      context.missing(_videoReferenceMeta);
    }
    if (d.involvedMuscle.present) {
      context.handle(
          _involvedMuscleMeta,
          involvedMuscle.isAcceptableValue(
              d.involvedMuscle.value, _involvedMuscleMeta));
    } else if (involvedMuscle.isRequired && isInserting) {
      context.missing(_involvedMuscleMeta);
    }
    if (d.recommendRestingTimeBetweenSet.present) {
      context.handle(
          _recommendRestingTimeBetweenSetMeta,
          recommendRestingTimeBetweenSet.isAcceptableValue(
              d.recommendRestingTimeBetweenSet.value,
              _recommendRestingTimeBetweenSetMeta));
    } else if (recommendRestingTimeBetweenSet.isRequired && isInserting) {
      context.missing(_recommendRestingTimeBetweenSetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalMovement map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalMovement.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalMovementsCompanion d) {
    final map = <String, Variable>{};
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.description.present) {
      map['description'] = Variable<String, StringType>(d.description.value);
    }
    if (d.picReference.present) {
      map['pic_reference'] = Variable<String, StringType>(d.picReference.value);
    }
    if (d.videoReference.present) {
      map['video_reference'] =
          Variable<String, StringType>(d.videoReference.value);
    }
    if (d.involvedMuscle.present) {
      map['involved_muscle'] =
          Variable<String, StringType>(d.involvedMuscle.value);
    }
    if (d.recommendRestingTimeBetweenSet.present) {
      map['recommend_resting_time_between_set'] =
          Variable<int, IntType>(d.recommendRestingTimeBetweenSet.value);
    }
    return map;
  }

  @override
  $LocalMovementsTable createAlias(String alias) {
    return $LocalMovementsTable(_db, alias);
  }
}

class LocalUserTraining extends DataClass
    implements Insertable<LocalUserTraining> {
  final String userId;
  final String planGoal;
  final String planType;
  final int totalTrainingWeeks;
  final int sessionPerWeek;
  final String extraNote;
  final String createdBy;
  LocalUserTraining(
      {@required this.userId,
      @required this.planGoal,
      @required this.planType,
      this.totalTrainingWeeks,
      this.sessionPerWeek,
      @required this.extraNote,
      @required this.createdBy});
  factory LocalUserTraining.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return LocalUserTraining(
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      planGoal: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}plan_goal']),
      planType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}plan_type']),
      totalTrainingWeeks: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}total_training_weeks']),
      sessionPerWeek: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}session_per_week']),
      extraNote: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_note']),
      createdBy: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_by']),
    );
  }
  factory LocalUserTraining.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalUserTraining(
      userId: serializer.fromJson<String>(json['userId']),
      planGoal: serializer.fromJson<String>(json['planGoal']),
      planType: serializer.fromJson<String>(json['planType']),
      totalTrainingWeeks: serializer.fromJson<int>(json['totalTrainingWeeks']),
      sessionPerWeek: serializer.fromJson<int>(json['sessionPerWeek']),
      extraNote: serializer.fromJson<String>(json['extraNote']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'userId': serializer.toJson<String>(userId),
      'planGoal': serializer.toJson<String>(planGoal),
      'planType': serializer.toJson<String>(planType),
      'totalTrainingWeeks': serializer.toJson<int>(totalTrainingWeeks),
      'sessionPerWeek': serializer.toJson<int>(sessionPerWeek),
      'extraNote': serializer.toJson<String>(extraNote),
      'createdBy': serializer.toJson<String>(createdBy),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalUserTraining>>(
      bool nullToAbsent) {
    return LocalUserTrainingsCompanion(
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      planGoal: planGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(planGoal),
      planType: planType == null && nullToAbsent
          ? const Value.absent()
          : Value(planType),
      totalTrainingWeeks: totalTrainingWeeks == null && nullToAbsent
          ? const Value.absent()
          : Value(totalTrainingWeeks),
      sessionPerWeek: sessionPerWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionPerWeek),
      extraNote: extraNote == null && nullToAbsent
          ? const Value.absent()
          : Value(extraNote),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    ) as T;
  }

  LocalUserTraining copyWith(
          {String userId,
          String planGoal,
          String planType,
          int totalTrainingWeeks,
          int sessionPerWeek,
          String extraNote,
          String createdBy}) =>
      LocalUserTraining(
        userId: userId ?? this.userId,
        planGoal: planGoal ?? this.planGoal,
        planType: planType ?? this.planType,
        totalTrainingWeeks: totalTrainingWeeks ?? this.totalTrainingWeeks,
        sessionPerWeek: sessionPerWeek ?? this.sessionPerWeek,
        extraNote: extraNote ?? this.extraNote,
        createdBy: createdBy ?? this.createdBy,
      );
  @override
  String toString() {
    return (StringBuffer('LocalUserTraining(')
          ..write('userId: $userId, ')
          ..write('planGoal: $planGoal, ')
          ..write('planType: $planType, ')
          ..write('totalTrainingWeeks: $totalTrainingWeeks, ')
          ..write('sessionPerWeek: $sessionPerWeek, ')
          ..write('extraNote: $extraNote, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc($mrjc($mrjc(0, userId.hashCode), planGoal.hashCode),
                      planType.hashCode),
                  totalTrainingWeeks.hashCode),
              sessionPerWeek.hashCode),
          extraNote.hashCode),
      createdBy.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalUserTraining &&
          other.userId == userId &&
          other.planGoal == planGoal &&
          other.planType == planType &&
          other.totalTrainingWeeks == totalTrainingWeeks &&
          other.sessionPerWeek == sessionPerWeek &&
          other.extraNote == extraNote &&
          other.createdBy == createdBy);
}

class LocalUserTrainingsCompanion extends UpdateCompanion<LocalUserTraining> {
  final Value<String> userId;
  final Value<String> planGoal;
  final Value<String> planType;
  final Value<int> totalTrainingWeeks;
  final Value<int> sessionPerWeek;
  final Value<String> extraNote;
  final Value<String> createdBy;
  const LocalUserTrainingsCompanion({
    this.userId = const Value.absent(),
    this.planGoal = const Value.absent(),
    this.planType = const Value.absent(),
    this.totalTrainingWeeks = const Value.absent(),
    this.sessionPerWeek = const Value.absent(),
    this.extraNote = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
}

class $LocalUserTrainingsTable extends LocalUserTrainings
    with TableInfo<$LocalUserTrainingsTable, LocalUserTraining> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalUserTrainingsTable(this._db, [this._alias]);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn('user_id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _planGoalMeta = const VerificationMeta('planGoal');
  GeneratedTextColumn _planGoal;
  @override
  GeneratedTextColumn get planGoal => _planGoal ??= _constructPlanGoal();
  GeneratedTextColumn _constructPlanGoal() {
    return GeneratedTextColumn('plan_goal', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _planTypeMeta = const VerificationMeta('planType');
  GeneratedTextColumn _planType;
  @override
  GeneratedTextColumn get planType => _planType ??= _constructPlanType();
  GeneratedTextColumn _constructPlanType() {
    return GeneratedTextColumn('plan_type', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _totalTrainingWeeksMeta =
      const VerificationMeta('totalTrainingWeeks');
  GeneratedIntColumn _totalTrainingWeeks;
  @override
  GeneratedIntColumn get totalTrainingWeeks =>
      _totalTrainingWeeks ??= _constructTotalTrainingWeeks();
  GeneratedIntColumn _constructTotalTrainingWeeks() {
    return GeneratedIntColumn(
      'total_training_weeks',
      $tableName,
      true,
    );
  }

  final VerificationMeta _sessionPerWeekMeta =
      const VerificationMeta('sessionPerWeek');
  GeneratedIntColumn _sessionPerWeek;
  @override
  GeneratedIntColumn get sessionPerWeek =>
      _sessionPerWeek ??= _constructSessionPerWeek();
  GeneratedIntColumn _constructSessionPerWeek() {
    return GeneratedIntColumn(
      'session_per_week',
      $tableName,
      true,
    );
  }

  final VerificationMeta _extraNoteMeta = const VerificationMeta('extraNote');
  GeneratedTextColumn _extraNote;
  @override
  GeneratedTextColumn get extraNote => _extraNote ??= _constructExtraNote();
  GeneratedTextColumn _constructExtraNote() {
    return GeneratedTextColumn('extra_note', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
  GeneratedTextColumn _createdBy;
  @override
  GeneratedTextColumn get createdBy => _createdBy ??= _constructCreatedBy();
  GeneratedTextColumn _constructCreatedBy() {
    return GeneratedTextColumn('created_by', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  @override
  List<GeneratedColumn> get $columns => [
        userId,
        planGoal,
        planType,
        totalTrainingWeeks,
        sessionPerWeek,
        extraNote,
        createdBy
      ];
  @override
  $LocalUserTrainingsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_user_trainings';
  @override
  final String actualTableName = 'local_user_trainings';
  @override
  VerificationContext validateIntegrity(LocalUserTrainingsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (userId.isRequired && isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.planGoal.present) {
      context.handle(_planGoalMeta,
          planGoal.isAcceptableValue(d.planGoal.value, _planGoalMeta));
    } else if (planGoal.isRequired && isInserting) {
      context.missing(_planGoalMeta);
    }
    if (d.planType.present) {
      context.handle(_planTypeMeta,
          planType.isAcceptableValue(d.planType.value, _planTypeMeta));
    } else if (planType.isRequired && isInserting) {
      context.missing(_planTypeMeta);
    }
    if (d.totalTrainingWeeks.present) {
      context.handle(
          _totalTrainingWeeksMeta,
          totalTrainingWeeks.isAcceptableValue(
              d.totalTrainingWeeks.value, _totalTrainingWeeksMeta));
    } else if (totalTrainingWeeks.isRequired && isInserting) {
      context.missing(_totalTrainingWeeksMeta);
    }
    if (d.sessionPerWeek.present) {
      context.handle(
          _sessionPerWeekMeta,
          sessionPerWeek.isAcceptableValue(
              d.sessionPerWeek.value, _sessionPerWeekMeta));
    } else if (sessionPerWeek.isRequired && isInserting) {
      context.missing(_sessionPerWeekMeta);
    }
    if (d.extraNote.present) {
      context.handle(_extraNoteMeta,
          extraNote.isAcceptableValue(d.extraNote.value, _extraNoteMeta));
    } else if (extraNote.isRequired && isInserting) {
      context.missing(_extraNoteMeta);
    }
    if (d.createdBy.present) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableValue(d.createdBy.value, _createdByMeta));
    } else if (createdBy.isRequired && isInserting) {
      context.missing(_createdByMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalUserTraining map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalUserTraining.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalUserTrainingsCompanion d) {
    final map = <String, Variable>{};
    if (d.userId.present) {
      map['user_id'] = Variable<String, StringType>(d.userId.value);
    }
    if (d.planGoal.present) {
      map['plan_goal'] = Variable<String, StringType>(d.planGoal.value);
    }
    if (d.planType.present) {
      map['plan_type'] = Variable<String, StringType>(d.planType.value);
    }
    if (d.totalTrainingWeeks.present) {
      map['total_training_weeks'] =
          Variable<int, IntType>(d.totalTrainingWeeks.value);
    }
    if (d.sessionPerWeek.present) {
      map['session_per_week'] = Variable<int, IntType>(d.sessionPerWeek.value);
    }
    if (d.extraNote.present) {
      map['extra_note'] = Variable<String, StringType>(d.extraNote.value);
    }
    if (d.createdBy.present) {
      map['created_by'] = Variable<String, StringType>(d.createdBy.value);
    }
    return map;
  }

  @override
  $LocalUserTrainingsTable createAlias(String alias) {
    return $LocalUserTrainingsTable(_db, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String id;
  final String name;
  final String token;
  LocalUser({@required this.id, @required this.name, @required this.token});
  factory LocalUser.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return LocalUser(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      token:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}token']),
    );
  }
  factory LocalUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalUser(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      token: serializer.fromJson<String>(json['token']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'token': serializer.toJson<String>(token),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalUser>>(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
    ) as T;
  }

  LocalUser copyWith({String id, String name, String token}) => LocalUser(
        id: id ?? this.id,
        name: name ?? this.name,
        token: token ?? this.token,
      );
  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('token: $token')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc($mrjc($mrjc(0, id.hashCode), name.hashCode), token.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.id == id &&
          other.name == name &&
          other.token == token);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> token;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.token = const Value.absent(),
  });
}

class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUser> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalUsersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false, maxTextLength: 32);
  }

  final VerificationMeta _tokenMeta = const VerificationMeta('token');
  GeneratedTextColumn _token;
  @override
  GeneratedTextColumn get token => _token ??= _constructToken();
  GeneratedTextColumn _constructToken() {
    return GeneratedTextColumn('token', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, token];
  @override
  $LocalUsersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_users';
  @override
  final String actualTableName = 'local_users';
  @override
  VerificationContext validateIntegrity(LocalUsersCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.token.present) {
      context.handle(
          _tokenMeta, token.isAcceptableValue(d.token.value, _tokenMeta));
    } else if (token.isRequired && isInserting) {
      context.missing(_tokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalUser map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalUser.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalUsersCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.token.present) {
      map['token'] = Variable<String, StringType>(d.token.value);
    }
    return map;
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(_db, alias);
  }
}

class LocalPlannedSetsMovementMap extends DataClass
    implements Insertable<LocalPlannedSetsMovementMap> {
  final String plannedSetId;
  final String movementId;
  LocalPlannedSetsMovementMap(
      {@required this.plannedSetId, @required this.movementId});
  factory LocalPlannedSetsMovementMap.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return LocalPlannedSetsMovementMap(
      plannedSetId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}planned_set_id']),
      movementId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}movement_id']),
    );
  }
  factory LocalPlannedSetsMovementMap.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalPlannedSetsMovementMap(
      plannedSetId: serializer.fromJson<String>(json['plannedSetId']),
      movementId: serializer.fromJson<String>(json['movementId']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'plannedSetId': serializer.toJson<String>(plannedSetId),
      'movementId': serializer.toJson<String>(movementId),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalPlannedSetsMovementMap>>(
      bool nullToAbsent) {
    return LocalPlannedSetsMovementMapsCompanion(
      plannedSetId: plannedSetId == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedSetId),
      movementId: movementId == null && nullToAbsent
          ? const Value.absent()
          : Value(movementId),
    ) as T;
  }

  LocalPlannedSetsMovementMap copyWith(
          {String plannedSetId, String movementId}) =>
      LocalPlannedSetsMovementMap(
        plannedSetId: plannedSetId ?? this.plannedSetId,
        movementId: movementId ?? this.movementId,
      );
  @override
  String toString() {
    return (StringBuffer('LocalPlannedSetsMovementMap(')
          ..write('plannedSetId: $plannedSetId, ')
          ..write('movementId: $movementId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc($mrjc(0, plannedSetId.hashCode), movementId.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalPlannedSetsMovementMap &&
          other.plannedSetId == plannedSetId &&
          other.movementId == movementId);
}

class LocalPlannedSetsMovementMapsCompanion
    extends UpdateCompanion<LocalPlannedSetsMovementMap> {
  final Value<String> plannedSetId;
  final Value<String> movementId;
  const LocalPlannedSetsMovementMapsCompanion({
    this.plannedSetId = const Value.absent(),
    this.movementId = const Value.absent(),
  });
}

class $LocalPlannedSetsMovementMapsTable extends LocalPlannedSetsMovementMaps
    with
        TableInfo<$LocalPlannedSetsMovementMapsTable,
            LocalPlannedSetsMovementMap> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalPlannedSetsMovementMapsTable(this._db, [this._alias]);
  final VerificationMeta _plannedSetIdMeta =
      const VerificationMeta('plannedSetId');
  GeneratedTextColumn _plannedSetId;
  @override
  GeneratedTextColumn get plannedSetId =>
      _plannedSetId ??= _constructPlannedSetId();
  GeneratedTextColumn _constructPlannedSetId() {
    return GeneratedTextColumn('planned_set_id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _movementIdMeta = const VerificationMeta('movementId');
  GeneratedTextColumn _movementId;
  @override
  GeneratedTextColumn get movementId => _movementId ??= _constructMovementId();
  GeneratedTextColumn _constructMovementId() {
    return GeneratedTextColumn('movement_id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  @override
  List<GeneratedColumn> get $columns => [plannedSetId, movementId];
  @override
  $LocalPlannedSetsMovementMapsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_planned_sets_movement_maps';
  @override
  final String actualTableName = 'local_planned_sets_movement_maps';
  @override
  VerificationContext validateIntegrity(LocalPlannedSetsMovementMapsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.plannedSetId.present) {
      context.handle(
          _plannedSetIdMeta,
          plannedSetId.isAcceptableValue(
              d.plannedSetId.value, _plannedSetIdMeta));
    } else if (plannedSetId.isRequired && isInserting) {
      context.missing(_plannedSetIdMeta);
    }
    if (d.movementId.present) {
      context.handle(_movementIdMeta,
          movementId.isAcceptableValue(d.movementId.value, _movementIdMeta));
    } else if (movementId.isRequired && isInserting) {
      context.missing(_movementIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalPlannedSetsMovementMap map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalPlannedSetsMovementMap.fromData(data, _db,
        prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalPlannedSetsMovementMapsCompanion d) {
    final map = <String, Variable>{};
    if (d.plannedSetId.present) {
      map['planned_set_id'] =
          Variable<String, StringType>(d.plannedSetId.value);
    }
    if (d.movementId.present) {
      map['movement_id'] = Variable<String, StringType>(d.movementId.value);
    }
    return map;
  }

  @override
  $LocalPlannedSetsMovementMapsTable createAlias(String alias) {
    return $LocalPlannedSetsMovementMapsTable(_db, alias);
  }
}

class LocalExercisePlannedSet extends DataClass
    implements Insertable<LocalExercisePlannedSet> {
  final String id;
  final int sequence;
  final String setType;
  final int expectingRepeatsPerSet;
  final double expectingWeight;
  final double reduceTo;
  final double reduceWeight;
  final int intervalTime;
  LocalExercisePlannedSet(
      {@required this.id,
      @required this.sequence,
      @required this.setType,
      @required this.expectingRepeatsPerSet,
      @required this.expectingWeight,
      this.reduceTo,
      this.reduceWeight,
      this.intervalTime});
  factory LocalExercisePlannedSet.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    return LocalExercisePlannedSet(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      sequence:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}sequence']),
      setType: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}set_type']),
      expectingRepeatsPerSet: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}expecting_repeats_per_set']),
      expectingWeight: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}expecting_weight']),
      reduceTo: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}reduce_to']),
      reduceWeight: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}reduce_weight']),
      intervalTime: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}interval_time']),
    );
  }
  factory LocalExercisePlannedSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalExercisePlannedSet(
      id: serializer.fromJson<String>(json['id']),
      sequence: serializer.fromJson<int>(json['sequence']),
      setType: serializer.fromJson<String>(json['setType']),
      expectingRepeatsPerSet:
          serializer.fromJson<int>(json['expectingRepeatsPerSet']),
      expectingWeight: serializer.fromJson<double>(json['expectingWeight']),
      reduceTo: serializer.fromJson<double>(json['reduceTo']),
      reduceWeight: serializer.fromJson<double>(json['reduceWeight']),
      intervalTime: serializer.fromJson<int>(json['intervalTime']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'sequence': serializer.toJson<int>(sequence),
      'setType': serializer.toJson<String>(setType),
      'expectingRepeatsPerSet': serializer.toJson<int>(expectingRepeatsPerSet),
      'expectingWeight': serializer.toJson<double>(expectingWeight),
      'reduceTo': serializer.toJson<double>(reduceTo),
      'reduceWeight': serializer.toJson<double>(reduceWeight),
      'intervalTime': serializer.toJson<int>(intervalTime),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalExercisePlannedSet>>(
      bool nullToAbsent) {
    return LocalExercisePlannedSetsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      sequence: sequence == null && nullToAbsent
          ? const Value.absent()
          : Value(sequence),
      setType: setType == null && nullToAbsent
          ? const Value.absent()
          : Value(setType),
      expectingRepeatsPerSet: expectingRepeatsPerSet == null && nullToAbsent
          ? const Value.absent()
          : Value(expectingRepeatsPerSet),
      expectingWeight: expectingWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(expectingWeight),
      reduceTo: reduceTo == null && nullToAbsent
          ? const Value.absent()
          : Value(reduceTo),
      reduceWeight: reduceWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(reduceWeight),
      intervalTime: intervalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalTime),
    ) as T;
  }

  LocalExercisePlannedSet copyWith(
          {String id,
          int sequence,
          String setType,
          int expectingRepeatsPerSet,
          double expectingWeight,
          double reduceTo,
          double reduceWeight,
          int intervalTime}) =>
      LocalExercisePlannedSet(
        id: id ?? this.id,
        sequence: sequence ?? this.sequence,
        setType: setType ?? this.setType,
        expectingRepeatsPerSet:
            expectingRepeatsPerSet ?? this.expectingRepeatsPerSet,
        expectingWeight: expectingWeight ?? this.expectingWeight,
        reduceTo: reduceTo ?? this.reduceTo,
        reduceWeight: reduceWeight ?? this.reduceWeight,
        intervalTime: intervalTime ?? this.intervalTime,
      );
  @override
  String toString() {
    return (StringBuffer('LocalExercisePlannedSet(')
          ..write('id: $id, ')
          ..write('sequence: $sequence, ')
          ..write('setType: $setType, ')
          ..write('expectingRepeatsPerSet: $expectingRepeatsPerSet, ')
          ..write('expectingWeight: $expectingWeight, ')
          ..write('reduceTo: $reduceTo, ')
          ..write('reduceWeight: $reduceWeight, ')
          ..write('intervalTime: $intervalTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc(
                      $mrjc($mrjc($mrjc(0, id.hashCode), sequence.hashCode),
                          setType.hashCode),
                      expectingRepeatsPerSet.hashCode),
                  expectingWeight.hashCode),
              reduceTo.hashCode),
          reduceWeight.hashCode),
      intervalTime.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalExercisePlannedSet &&
          other.id == id &&
          other.sequence == sequence &&
          other.setType == setType &&
          other.expectingRepeatsPerSet == expectingRepeatsPerSet &&
          other.expectingWeight == expectingWeight &&
          other.reduceTo == reduceTo &&
          other.reduceWeight == reduceWeight &&
          other.intervalTime == intervalTime);
}

class LocalExercisePlannedSetsCompanion
    extends UpdateCompanion<LocalExercisePlannedSet> {
  final Value<String> id;
  final Value<int> sequence;
  final Value<String> setType;
  final Value<int> expectingRepeatsPerSet;
  final Value<double> expectingWeight;
  final Value<double> reduceTo;
  final Value<double> reduceWeight;
  final Value<int> intervalTime;
  const LocalExercisePlannedSetsCompanion({
    this.id = const Value.absent(),
    this.sequence = const Value.absent(),
    this.setType = const Value.absent(),
    this.expectingRepeatsPerSet = const Value.absent(),
    this.expectingWeight = const Value.absent(),
    this.reduceTo = const Value.absent(),
    this.reduceWeight = const Value.absent(),
    this.intervalTime = const Value.absent(),
  });
}

class $LocalExercisePlannedSetsTable extends LocalExercisePlannedSets
    with TableInfo<$LocalExercisePlannedSetsTable, LocalExercisePlannedSet> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalExercisePlannedSetsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false,
        minTextLength: 64, maxTextLength: 256);
  }

  final VerificationMeta _sequenceMeta = const VerificationMeta('sequence');
  GeneratedIntColumn _sequence;
  @override
  GeneratedIntColumn get sequence => _sequence ??= _constructSequence();
  GeneratedIntColumn _constructSequence() {
    return GeneratedIntColumn(
      'sequence',
      $tableName,
      false,
    );
  }

  final VerificationMeta _setTypeMeta = const VerificationMeta('setType');
  GeneratedTextColumn _setType;
  @override
  GeneratedTextColumn get setType => _setType ??= _constructSetType();
  GeneratedTextColumn _constructSetType() {
    return GeneratedTextColumn('set_type', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _expectingRepeatsPerSetMeta =
      const VerificationMeta('expectingRepeatsPerSet');
  GeneratedIntColumn _expectingRepeatsPerSet;
  @override
  GeneratedIntColumn get expectingRepeatsPerSet =>
      _expectingRepeatsPerSet ??= _constructExpectingRepeatsPerSet();
  GeneratedIntColumn _constructExpectingRepeatsPerSet() {
    return GeneratedIntColumn(
      'expecting_repeats_per_set',
      $tableName,
      false,
    );
  }

  final VerificationMeta _expectingWeightMeta =
      const VerificationMeta('expectingWeight');
  GeneratedRealColumn _expectingWeight;
  @override
  GeneratedRealColumn get expectingWeight =>
      _expectingWeight ??= _constructExpectingWeight();
  GeneratedRealColumn _constructExpectingWeight() {
    return GeneratedRealColumn(
      'expecting_weight',
      $tableName,
      false,
    );
  }

  final VerificationMeta _reduceToMeta = const VerificationMeta('reduceTo');
  GeneratedRealColumn _reduceTo;
  @override
  GeneratedRealColumn get reduceTo => _reduceTo ??= _constructReduceTo();
  GeneratedRealColumn _constructReduceTo() {
    return GeneratedRealColumn(
      'reduce_to',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reduceWeightMeta =
      const VerificationMeta('reduceWeight');
  GeneratedRealColumn _reduceWeight;
  @override
  GeneratedRealColumn get reduceWeight =>
      _reduceWeight ??= _constructReduceWeight();
  GeneratedRealColumn _constructReduceWeight() {
    return GeneratedRealColumn(
      'reduce_weight',
      $tableName,
      true,
    );
  }

  final VerificationMeta _intervalTimeMeta =
      const VerificationMeta('intervalTime');
  GeneratedIntColumn _intervalTime;
  @override
  GeneratedIntColumn get intervalTime =>
      _intervalTime ??= _constructIntervalTime();
  GeneratedIntColumn _constructIntervalTime() {
    return GeneratedIntColumn(
      'interval_time',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        sequence,
        setType,
        expectingRepeatsPerSet,
        expectingWeight,
        reduceTo,
        reduceWeight,
        intervalTime
      ];
  @override
  $LocalExercisePlannedSetsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_exercise_planned_sets';
  @override
  final String actualTableName = 'local_exercise_planned_sets';
  @override
  VerificationContext validateIntegrity(LocalExercisePlannedSetsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.sequence.present) {
      context.handle(_sequenceMeta,
          sequence.isAcceptableValue(d.sequence.value, _sequenceMeta));
    } else if (sequence.isRequired && isInserting) {
      context.missing(_sequenceMeta);
    }
    if (d.setType.present) {
      context.handle(_setTypeMeta,
          setType.isAcceptableValue(d.setType.value, _setTypeMeta));
    } else if (setType.isRequired && isInserting) {
      context.missing(_setTypeMeta);
    }
    if (d.expectingRepeatsPerSet.present) {
      context.handle(
          _expectingRepeatsPerSetMeta,
          expectingRepeatsPerSet.isAcceptableValue(
              d.expectingRepeatsPerSet.value, _expectingRepeatsPerSetMeta));
    } else if (expectingRepeatsPerSet.isRequired && isInserting) {
      context.missing(_expectingRepeatsPerSetMeta);
    }
    if (d.expectingWeight.present) {
      context.handle(
          _expectingWeightMeta,
          expectingWeight.isAcceptableValue(
              d.expectingWeight.value, _expectingWeightMeta));
    } else if (expectingWeight.isRequired && isInserting) {
      context.missing(_expectingWeightMeta);
    }
    if (d.reduceTo.present) {
      context.handle(_reduceToMeta,
          reduceTo.isAcceptableValue(d.reduceTo.value, _reduceToMeta));
    } else if (reduceTo.isRequired && isInserting) {
      context.missing(_reduceToMeta);
    }
    if (d.reduceWeight.present) {
      context.handle(
          _reduceWeightMeta,
          reduceWeight.isAcceptableValue(
              d.reduceWeight.value, _reduceWeightMeta));
    } else if (reduceWeight.isRequired && isInserting) {
      context.missing(_reduceWeightMeta);
    }
    if (d.intervalTime.present) {
      context.handle(
          _intervalTimeMeta,
          intervalTime.isAcceptableValue(
              d.intervalTime.value, _intervalTimeMeta));
    } else if (intervalTime.isRequired && isInserting) {
      context.missing(_intervalTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalExercisePlannedSet map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalExercisePlannedSet.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalExercisePlannedSetsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.sequence.present) {
      map['sequence'] = Variable<int, IntType>(d.sequence.value);
    }
    if (d.setType.present) {
      map['set_type'] = Variable<String, StringType>(d.setType.value);
    }
    if (d.expectingRepeatsPerSet.present) {
      map['expecting_repeats_per_set'] =
          Variable<int, IntType>(d.expectingRepeatsPerSet.value);
    }
    if (d.expectingWeight.present) {
      map['expecting_weight'] =
          Variable<double, RealType>(d.expectingWeight.value);
    }
    if (d.reduceTo.present) {
      map['reduce_to'] = Variable<double, RealType>(d.reduceTo.value);
    }
    if (d.reduceWeight.present) {
      map['reduce_weight'] = Variable<double, RealType>(d.reduceWeight.value);
    }
    if (d.intervalTime.present) {
      map['interval_time'] = Variable<int, IntType>(d.intervalTime.value);
    }
    return map;
  }

  @override
  $LocalExercisePlannedSetsTable createAlias(String alias) {
    return $LocalExercisePlannedSetsTable(_db, alias);
  }
}

class LocalTrainingExercise extends DataClass
    implements Insertable<LocalTrainingExercise> {
  final String id;
  final String matchingPlanId;
  final String muscleTarget;
  final String name;
  final String description;
  final int recommendRestingTimeBetweenMovement;
  final DateTime plannedDate;
  LocalTrainingExercise(
      {@required this.id,
      @required this.matchingPlanId,
      @required this.muscleTarget,
      @required this.name,
      @required this.description,
      this.recommendRestingTimeBetweenMovement,
      @required this.plannedDate});
  factory LocalTrainingExercise.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return LocalTrainingExercise(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      matchingPlanId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}matching_plan_id']),
      muscleTarget: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}muscle_target']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      recommendRestingTimeBetweenMovement: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}recommend_resting_time_between_movement']),
      plannedDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}planned_date']),
    );
  }
  factory LocalTrainingExercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalTrainingExercise(
      id: serializer.fromJson<String>(json['id']),
      matchingPlanId: serializer.fromJson<String>(json['matchingPlanId']),
      muscleTarget: serializer.fromJson<String>(json['muscleTarget']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      recommendRestingTimeBetweenMovement:
          serializer.fromJson<int>(json['recommendRestingTimeBetweenMovement']),
      plannedDate: serializer.fromJson<DateTime>(json['plannedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'matchingPlanId': serializer.toJson<String>(matchingPlanId),
      'muscleTarget': serializer.toJson<String>(muscleTarget),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'recommendRestingTimeBetweenMovement':
          serializer.toJson<int>(recommendRestingTimeBetweenMovement),
      'plannedDate': serializer.toJson<DateTime>(plannedDate),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalTrainingExercise>>(
      bool nullToAbsent) {
    return LocalTrainingExercisesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      matchingPlanId: matchingPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(matchingPlanId),
      muscleTarget: muscleTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleTarget),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      recommendRestingTimeBetweenMovement:
          recommendRestingTimeBetweenMovement == null && nullToAbsent
              ? const Value.absent()
              : Value(recommendRestingTimeBetweenMovement),
      plannedDate: plannedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedDate),
    ) as T;
  }

  LocalTrainingExercise copyWith(
          {String id,
          String matchingPlanId,
          String muscleTarget,
          String name,
          String description,
          int recommendRestingTimeBetweenMovement,
          DateTime plannedDate}) =>
      LocalTrainingExercise(
        id: id ?? this.id,
        matchingPlanId: matchingPlanId ?? this.matchingPlanId,
        muscleTarget: muscleTarget ?? this.muscleTarget,
        name: name ?? this.name,
        description: description ?? this.description,
        recommendRestingTimeBetweenMovement:
            recommendRestingTimeBetweenMovement ??
                this.recommendRestingTimeBetweenMovement,
        plannedDate: plannedDate ?? this.plannedDate,
      );
  @override
  String toString() {
    return (StringBuffer('LocalTrainingExercise(')
          ..write('id: $id, ')
          ..write('matchingPlanId: $matchingPlanId, ')
          ..write('muscleTarget: $muscleTarget, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write(
              'recommendRestingTimeBetweenMovement: $recommendRestingTimeBetweenMovement, ')
          ..write('plannedDate: $plannedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc(
          $mrjc(
              $mrjc(
                  $mrjc($mrjc($mrjc(0, id.hashCode), matchingPlanId.hashCode),
                      muscleTarget.hashCode),
                  name.hashCode),
              description.hashCode),
          recommendRestingTimeBetweenMovement.hashCode),
      plannedDate.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalTrainingExercise &&
          other.id == id &&
          other.matchingPlanId == matchingPlanId &&
          other.muscleTarget == muscleTarget &&
          other.name == name &&
          other.description == description &&
          other.recommendRestingTimeBetweenMovement ==
              recommendRestingTimeBetweenMovement &&
          other.plannedDate == plannedDate);
}

class LocalTrainingExercisesCompanion
    extends UpdateCompanion<LocalTrainingExercise> {
  final Value<String> id;
  final Value<String> matchingPlanId;
  final Value<String> muscleTarget;
  final Value<String> name;
  final Value<String> description;
  final Value<int> recommendRestingTimeBetweenMovement;
  final Value<DateTime> plannedDate;
  const LocalTrainingExercisesCompanion({
    this.id = const Value.absent(),
    this.matchingPlanId = const Value.absent(),
    this.muscleTarget = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.recommendRestingTimeBetweenMovement = const Value.absent(),
    this.plannedDate = const Value.absent(),
  });
}

class $LocalTrainingExercisesTable extends LocalTrainingExercises
    with TableInfo<$LocalTrainingExercisesTable, LocalTrainingExercise> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalTrainingExercisesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _matchingPlanIdMeta =
      const VerificationMeta('matchingPlanId');
  GeneratedTextColumn _matchingPlanId;
  @override
  GeneratedTextColumn get matchingPlanId =>
      _matchingPlanId ??= _constructMatchingPlanId();
  GeneratedTextColumn _constructMatchingPlanId() {
    return GeneratedTextColumn('matching_plan_id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _muscleTargetMeta =
      const VerificationMeta('muscleTarget');
  GeneratedTextColumn _muscleTarget;
  @override
  GeneratedTextColumn get muscleTarget =>
      _muscleTarget ??= _constructMuscleTarget();
  GeneratedTextColumn _constructMuscleTarget() {
    return GeneratedTextColumn('muscle_target', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn('description', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _recommendRestingTimeBetweenMovementMeta =
      const VerificationMeta('recommendRestingTimeBetweenMovement');
  GeneratedIntColumn _recommendRestingTimeBetweenMovement;
  @override
  GeneratedIntColumn get recommendRestingTimeBetweenMovement =>
      _recommendRestingTimeBetweenMovement ??=
          _constructRecommendRestingTimeBetweenMovement();
  GeneratedIntColumn _constructRecommendRestingTimeBetweenMovement() {
    return GeneratedIntColumn(
      'recommend_resting_time_between_movement',
      $tableName,
      true,
    );
  }

  final VerificationMeta _plannedDateMeta =
      const VerificationMeta('plannedDate');
  GeneratedDateTimeColumn _plannedDate;
  @override
  GeneratedDateTimeColumn get plannedDate =>
      _plannedDate ??= _constructPlannedDate();
  GeneratedDateTimeColumn _constructPlannedDate() {
    return GeneratedDateTimeColumn(
      'planned_date',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        matchingPlanId,
        muscleTarget,
        name,
        description,
        recommendRestingTimeBetweenMovement,
        plannedDate
      ];
  @override
  $LocalTrainingExercisesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_training_exercises';
  @override
  final String actualTableName = 'local_training_exercises';
  @override
  VerificationContext validateIntegrity(LocalTrainingExercisesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.matchingPlanId.present) {
      context.handle(
          _matchingPlanIdMeta,
          matchingPlanId.isAcceptableValue(
              d.matchingPlanId.value, _matchingPlanIdMeta));
    } else if (matchingPlanId.isRequired && isInserting) {
      context.missing(_matchingPlanIdMeta);
    }
    if (d.muscleTarget.present) {
      context.handle(
          _muscleTargetMeta,
          muscleTarget.isAcceptableValue(
              d.muscleTarget.value, _muscleTargetMeta));
    } else if (muscleTarget.isRequired && isInserting) {
      context.missing(_muscleTargetMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.description.present) {
      context.handle(_descriptionMeta,
          description.isAcceptableValue(d.description.value, _descriptionMeta));
    } else if (description.isRequired && isInserting) {
      context.missing(_descriptionMeta);
    }
    if (d.recommendRestingTimeBetweenMovement.present) {
      context.handle(
          _recommendRestingTimeBetweenMovementMeta,
          recommendRestingTimeBetweenMovement.isAcceptableValue(
              d.recommendRestingTimeBetweenMovement.value,
              _recommendRestingTimeBetweenMovementMeta));
    } else if (recommendRestingTimeBetweenMovement.isRequired && isInserting) {
      context.missing(_recommendRestingTimeBetweenMovementMeta);
    }
    if (d.plannedDate.present) {
      context.handle(_plannedDateMeta,
          plannedDate.isAcceptableValue(d.plannedDate.value, _plannedDateMeta));
    } else if (plannedDate.isRequired && isInserting) {
      context.missing(_plannedDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalTrainingExercise map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalTrainingExercise.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalTrainingExercisesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.matchingPlanId.present) {
      map['matching_plan_id'] =
          Variable<String, StringType>(d.matchingPlanId.value);
    }
    if (d.muscleTarget.present) {
      map['muscle_target'] = Variable<String, StringType>(d.muscleTarget.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.description.present) {
      map['description'] = Variable<String, StringType>(d.description.value);
    }
    if (d.recommendRestingTimeBetweenMovement.present) {
      map['recommend_resting_time_between_movement'] =
          Variable<int, IntType>(d.recommendRestingTimeBetweenMovement.value);
    }
    if (d.plannedDate.present) {
      map['planned_date'] =
          Variable<DateTime, DateTimeType>(d.plannedDate.value);
    }
    return map;
  }

  @override
  $LocalTrainingExercisesTable createAlias(String alias) {
    return $LocalTrainingExercisesTable(_db, alias);
  }
}

class LocalSessionMaterial extends DataClass
    implements Insertable<LocalSessionMaterial> {
  final String id;
  final String filePath;
  final bool isVideo;
  final String sessionId;
  LocalSessionMaterial(
      {@required this.id,
      @required this.filePath,
      @required this.isVideo,
      @required this.sessionId});
  factory LocalSessionMaterial.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return LocalSessionMaterial(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      filePath: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}file_path']),
      isVideo:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}is_video']),
      sessionId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}session_id']),
    );
  }
  factory LocalSessionMaterial.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalSessionMaterial(
      id: serializer.fromJson<String>(json['id']),
      filePath: serializer.fromJson<String>(json['filePath']),
      isVideo: serializer.fromJson<bool>(json['isVideo']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'filePath': serializer.toJson<String>(filePath),
      'isVideo': serializer.toJson<bool>(isVideo),
      'sessionId': serializer.toJson<String>(sessionId),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalSessionMaterial>>(
      bool nullToAbsent) {
    return LocalSessionMaterialsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      isVideo: isVideo == null && nullToAbsent
          ? const Value.absent()
          : Value(isVideo),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
    ) as T;
  }

  LocalSessionMaterial copyWith(
          {String id, String filePath, bool isVideo, String sessionId}) =>
      LocalSessionMaterial(
        id: id ?? this.id,
        filePath: filePath ?? this.filePath,
        isVideo: isVideo ?? this.isVideo,
        sessionId: sessionId ?? this.sessionId,
      );
  @override
  String toString() {
    return (StringBuffer('LocalSessionMaterial(')
          ..write('id: $id, ')
          ..write('filePath: $filePath, ')
          ..write('isVideo: $isVideo, ')
          ..write('sessionId: $sessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      $mrjc($mrjc($mrjc(0, id.hashCode), filePath.hashCode), isVideo.hashCode),
      sessionId.hashCode));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalSessionMaterial &&
          other.id == id &&
          other.filePath == filePath &&
          other.isVideo == isVideo &&
          other.sessionId == sessionId);
}

class LocalSessionMaterialsCompanion
    extends UpdateCompanion<LocalSessionMaterial> {
  final Value<String> id;
  final Value<String> filePath;
  final Value<bool> isVideo;
  final Value<String> sessionId;
  const LocalSessionMaterialsCompanion({
    this.id = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.sessionId = const Value.absent(),
  });
}

class $LocalSessionMaterialsTable extends LocalSessionMaterials
    with TableInfo<$LocalSessionMaterialsTable, LocalSessionMaterial> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalSessionMaterialsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  final VerificationMeta _filePathMeta = const VerificationMeta('filePath');
  GeneratedTextColumn _filePath;
  @override
  GeneratedTextColumn get filePath => _filePath ??= _constructFilePath();
  GeneratedTextColumn _constructFilePath() {
    return GeneratedTextColumn(
      'file_path',
      $tableName,
      false,
    );
  }

  final VerificationMeta _isVideoMeta = const VerificationMeta('isVideo');
  GeneratedBoolColumn _isVideo;
  @override
  GeneratedBoolColumn get isVideo => _isVideo ??= _constructIsVideo();
  GeneratedBoolColumn _constructIsVideo() {
    return GeneratedBoolColumn(
      'is_video',
      $tableName,
      false,
    );
  }

  final VerificationMeta _sessionIdMeta = const VerificationMeta('sessionId');
  GeneratedTextColumn _sessionId;
  @override
  GeneratedTextColumn get sessionId => _sessionId ??= _constructSessionId();
  GeneratedTextColumn _constructSessionId() {
    return GeneratedTextColumn('session_id', $tableName, false,
        minTextLength: 32, maxTextLength: 64);
  }

  @override
  List<GeneratedColumn> get $columns => [id, filePath, isVideo, sessionId];
  @override
  $LocalSessionMaterialsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_session_materials';
  @override
  final String actualTableName = 'local_session_materials';
  @override
  VerificationContext validateIntegrity(LocalSessionMaterialsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.filePath.present) {
      context.handle(_filePathMeta,
          filePath.isAcceptableValue(d.filePath.value, _filePathMeta));
    } else if (filePath.isRequired && isInserting) {
      context.missing(_filePathMeta);
    }
    if (d.isVideo.present) {
      context.handle(_isVideoMeta,
          isVideo.isAcceptableValue(d.isVideo.value, _isVideoMeta));
    } else if (isVideo.isRequired && isInserting) {
      context.missing(_isVideoMeta);
    }
    if (d.sessionId.present) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableValue(d.sessionId.value, _sessionIdMeta));
    } else if (sessionId.isRequired && isInserting) {
      context.missing(_sessionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalSessionMaterial map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalSessionMaterial.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalSessionMaterialsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.filePath.present) {
      map['file_path'] = Variable<String, StringType>(d.filePath.value);
    }
    if (d.isVideo.present) {
      map['is_video'] = Variable<bool, BoolType>(d.isVideo.value);
    }
    if (d.sessionId.present) {
      map['session_id'] = Variable<String, StringType>(d.sessionId.value);
    }
    return map;
  }

  @override
  $LocalSessionMaterialsTable createAlias(String alias) {
    return $LocalSessionMaterialsTable(_db, alias);
  }
}

abstract class _$ExerciseDatabase extends GeneratedDatabase {
  _$ExerciseDatabase(QueryExecutor e)
      : super(const SqlTypeSystem.withDefaults(), e);
  $LocalCompletedExerciseSetsTable _localCompletedExerciseSets;
  $LocalCompletedExerciseSetsTable get localCompletedExerciseSets =>
      _localCompletedExerciseSets ??= $LocalCompletedExerciseSetsTable(this);
  $LocalCompletedSessionsTable _localCompletedSessions;
  $LocalCompletedSessionsTable get localCompletedSessions =>
      _localCompletedSessions ??= $LocalCompletedSessionsTable(this);
  $LocalMovementsTable _localMovements;
  $LocalMovementsTable get localMovements =>
      _localMovements ??= $LocalMovementsTable(this);
  $LocalUserTrainingsTable _localUserTrainings;
  $LocalUserTrainingsTable get localUserTrainings =>
      _localUserTrainings ??= $LocalUserTrainingsTable(this);
  $LocalUsersTable _localUsers;
  $LocalUsersTable get localUsers => _localUsers ??= $LocalUsersTable(this);
  $LocalPlannedSetsMovementMapsTable _localPlannedSetsMovementMaps;
  $LocalPlannedSetsMovementMapsTable get localPlannedSetsMovementMaps =>
      _localPlannedSetsMovementMaps ??=
          $LocalPlannedSetsMovementMapsTable(this);
  $LocalExercisePlannedSetsTable _localExercisePlannedSets;
  $LocalExercisePlannedSetsTable get localExercisePlannedSets =>
      _localExercisePlannedSets ??= $LocalExercisePlannedSetsTable(this);
  $LocalTrainingExercisesTable _localTrainingExercises;
  $LocalTrainingExercisesTable get localTrainingExercises =>
      _localTrainingExercises ??= $LocalTrainingExercisesTable(this);
  $LocalSessionMaterialsTable _localSessionMaterials;
  $LocalSessionMaterialsTable get localSessionMaterials =>
      _localSessionMaterials ??= $LocalSessionMaterialsTable(this);
  @override
  List<TableInfo> get allTables => [
        localCompletedExerciseSets,
        localCompletedSessions,
        localMovements,
        localUserTrainings,
        localUsers,
        localPlannedSetsMovementMaps,
        localExercisePlannedSets,
        localTrainingExercises,
        localSessionMaterials
      ];
}
