// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_models.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps
class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String id;
  final String name;
  final String token;
  final String avatar;
  LocalUser(
      {@required this.id,
      @required this.name,
      @required this.token,
      @required this.avatar});
  factory LocalUser.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return LocalUser(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      token:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}token']),
      avatar:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}avatar']),
    );
  }
  factory LocalUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalUser(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      token: serializer.fromJson<String>(json['token']),
      avatar: serializer.fromJson<String>(json['avatar']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'token': serializer.toJson<String>(token),
      'avatar': serializer.toJson<String>(avatar),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalUser>>(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
    ) as T;
  }

  LocalUser copyWith({String id, String name, String token, String avatar}) =>
      LocalUser(
        id: id ?? this.id,
        name: name ?? this.name,
        token: token ?? this.token,
        avatar: avatar ?? this.avatar,
      );
  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('token: $token, ')
          ..write('avatar: $avatar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(token.hashCode, avatar.hashCode))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.id == id &&
          other.name == name &&
          other.token == token &&
          other.avatar == avatar);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> token;
  final Value<String> avatar;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.token = const Value.absent(),
    this.avatar = const Value.absent(),
  });
  LocalUsersCompanion copyWith(
      {Value<String> id,
      Value<String> name,
      Value<String> token,
      Value<String> avatar}) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      token: token ?? this.token,
      avatar: avatar ?? this.avatar,
    );
  }
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

  final VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  GeneratedTextColumn _avatar;
  @override
  GeneratedTextColumn get avatar => _avatar ??= _constructAvatar();
  GeneratedTextColumn _constructAvatar() {
    return GeneratedTextColumn(
      'avatar',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, token, avatar];
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
    if (d.avatar.present) {
      context.handle(
          _avatarMeta, avatar.isAcceptableValue(d.avatar.value, _avatarMeta));
    } else if (avatar.isRequired && isInserting) {
      context.missing(_avatarMeta);
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
    if (d.avatar.present) {
      map['avatar'] = Variable<String, StringType>(d.avatar.value);
    }
    return map;
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(_db, alias);
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
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(filePath.hashCode, $mrjc(isVideo.hashCode, sessionId.hashCode))));
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
  LocalSessionMaterialsCompanion copyWith(
      {Value<String> id,
      Value<String> filePath,
      Value<bool> isVideo,
      Value<String> sessionId}) {
    return LocalSessionMaterialsCompanion(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      isVideo: isVideo ?? this.isVideo,
      sessionId: sessionId ?? this.sessionId,
    );
  }
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

class LocalUserBodyIndexData extends DataClass
    implements Insertable<LocalUserBodyIndexData> {
  final String id;
  final String bodyIndex;
  final double value;
  final String unit;
  final int recordTime;
  final String userId;
  LocalUserBodyIndexData(
      {@required this.id,
      @required this.bodyIndex,
      @required this.value,
      @required this.unit,
      @required this.recordTime,
      @required this.userId});
  factory LocalUserBodyIndexData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    final intType = db.typeSystem.forDartType<int>();
    return LocalUserBodyIndexData(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      bodyIndex: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}body_index']),
      value:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}value']),
      unit: stringType.mapFromDatabaseResponse(data['${effectivePrefix}unit']),
      recordTime: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}record_time']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
    );
  }
  factory LocalUserBodyIndexData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalUserBodyIndexData(
      id: serializer.fromJson<String>(json['id']),
      bodyIndex: serializer.fromJson<String>(json['bodyIndex']),
      value: serializer.fromJson<double>(json['value']),
      unit: serializer.fromJson<String>(json['unit']),
      recordTime: serializer.fromJson<int>(json['recordTime']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'bodyIndex': serializer.toJson<String>(bodyIndex),
      'value': serializer.toJson<double>(value),
      'unit': serializer.toJson<String>(unit),
      'recordTime': serializer.toJson<int>(recordTime),
      'userId': serializer.toJson<String>(userId),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalUserBodyIndexData>>(
      bool nullToAbsent) {
    return LocalUserBodyIndexCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      bodyIndex: bodyIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyIndex),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      recordTime: recordTime == null && nullToAbsent
          ? const Value.absent()
          : Value(recordTime),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    ) as T;
  }

  LocalUserBodyIndexData copyWith(
          {String id,
          String bodyIndex,
          double value,
          String unit,
          int recordTime,
          String userId}) =>
      LocalUserBodyIndexData(
        id: id ?? this.id,
        bodyIndex: bodyIndex ?? this.bodyIndex,
        value: value ?? this.value,
        unit: unit ?? this.unit,
        recordTime: recordTime ?? this.recordTime,
        userId: userId ?? this.userId,
      );
  @override
  String toString() {
    return (StringBuffer('LocalUserBodyIndexData(')
          ..write('id: $id, ')
          ..write('bodyIndex: $bodyIndex, ')
          ..write('value: $value, ')
          ..write('unit: $unit, ')
          ..write('recordTime: $recordTime, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          bodyIndex.hashCode,
          $mrjc(
              value.hashCode,
              $mrjc(unit.hashCode,
                  $mrjc(recordTime.hashCode, userId.hashCode))))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalUserBodyIndexData &&
          other.id == id &&
          other.bodyIndex == bodyIndex &&
          other.value == value &&
          other.unit == unit &&
          other.recordTime == recordTime &&
          other.userId == userId);
}

class LocalUserBodyIndexCompanion
    extends UpdateCompanion<LocalUserBodyIndexData> {
  final Value<String> id;
  final Value<String> bodyIndex;
  final Value<double> value;
  final Value<String> unit;
  final Value<int> recordTime;
  final Value<String> userId;
  const LocalUserBodyIndexCompanion({
    this.id = const Value.absent(),
    this.bodyIndex = const Value.absent(),
    this.value = const Value.absent(),
    this.unit = const Value.absent(),
    this.recordTime = const Value.absent(),
    this.userId = const Value.absent(),
  });
  LocalUserBodyIndexCompanion copyWith(
      {Value<String> id,
      Value<String> bodyIndex,
      Value<double> value,
      Value<String> unit,
      Value<int> recordTime,
      Value<String> userId}) {
    return LocalUserBodyIndexCompanion(
      id: id ?? this.id,
      bodyIndex: bodyIndex ?? this.bodyIndex,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      recordTime: recordTime ?? this.recordTime,
      userId: userId ?? this.userId,
    );
  }
}

class $LocalUserBodyIndexTable extends LocalUserBodyIndex
    with TableInfo<$LocalUserBodyIndexTable, LocalUserBodyIndexData> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalUserBodyIndexTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false, maxTextLength: 64);
  }

  final VerificationMeta _bodyIndexMeta = const VerificationMeta('bodyIndex');
  GeneratedTextColumn _bodyIndex;
  @override
  GeneratedTextColumn get bodyIndex => _bodyIndex ??= _constructBodyIndex();
  GeneratedTextColumn _constructBodyIndex() {
    return GeneratedTextColumn(
      'body_index',
      $tableName,
      false,
    );
  }

  final VerificationMeta _valueMeta = const VerificationMeta('value');
  GeneratedRealColumn _value;
  @override
  GeneratedRealColumn get value => _value ??= _constructValue();
  GeneratedRealColumn _constructValue() {
    return GeneratedRealColumn(
      'value',
      $tableName,
      false,
    );
  }

  final VerificationMeta _unitMeta = const VerificationMeta('unit');
  GeneratedTextColumn _unit;
  @override
  GeneratedTextColumn get unit => _unit ??= _constructUnit();
  GeneratedTextColumn _constructUnit() {
    return GeneratedTextColumn(
      'unit',
      $tableName,
      false,
    );
  }

  final VerificationMeta _recordTimeMeta = const VerificationMeta('recordTime');
  GeneratedIntColumn _recordTime;
  @override
  GeneratedIntColumn get recordTime => _recordTime ??= _constructRecordTime();
  GeneratedIntColumn _constructRecordTime() {
    return GeneratedIntColumn(
      'record_time',
      $tableName,
      false,
    );
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, bodyIndex, value, unit, recordTime, userId];
  @override
  $LocalUserBodyIndexTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_user_body_index';
  @override
  final String actualTableName = 'local_user_body_index';
  @override
  VerificationContext validateIntegrity(LocalUserBodyIndexCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.bodyIndex.present) {
      context.handle(_bodyIndexMeta,
          bodyIndex.isAcceptableValue(d.bodyIndex.value, _bodyIndexMeta));
    } else if (bodyIndex.isRequired && isInserting) {
      context.missing(_bodyIndexMeta);
    }
    if (d.value.present) {
      context.handle(
          _valueMeta, value.isAcceptableValue(d.value.value, _valueMeta));
    } else if (value.isRequired && isInserting) {
      context.missing(_valueMeta);
    }
    if (d.unit.present) {
      context.handle(
          _unitMeta, unit.isAcceptableValue(d.unit.value, _unitMeta));
    } else if (unit.isRequired && isInserting) {
      context.missing(_unitMeta);
    }
    if (d.recordTime.present) {
      context.handle(_recordTimeMeta,
          recordTime.isAcceptableValue(d.recordTime.value, _recordTimeMeta));
    } else if (recordTime.isRequired && isInserting) {
      context.missing(_recordTimeMeta);
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (userId.isRequired && isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalUserBodyIndexData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalUserBodyIndexData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalUserBodyIndexCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.bodyIndex.present) {
      map['body_index'] = Variable<String, StringType>(d.bodyIndex.value);
    }
    if (d.value.present) {
      map['value'] = Variable<double, RealType>(d.value.value);
    }
    if (d.unit.present) {
      map['unit'] = Variable<String, StringType>(d.unit.value);
    }
    if (d.recordTime.present) {
      map['record_time'] = Variable<int, IntType>(d.recordTime.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<String, StringType>(d.userId.value);
    }
    return map;
  }

  @override
  $LocalUserBodyIndexTable createAlias(String alias) {
    return $LocalUserBodyIndexTable(_db, alias);
  }
}

class LocalPlannedExerciseData extends DataClass
    implements Insertable<LocalPlannedExerciseData> {
  final String id;
  final String executeDate;
  final int exerciseTemplateId;
  final int userId;
  final int hasBeenExecuted;
  LocalPlannedExerciseData(
      {@required this.id,
      @required this.executeDate,
      @required this.exerciseTemplateId,
      @required this.userId,
      @required this.hasBeenExecuted});
  factory LocalPlannedExerciseData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return LocalPlannedExerciseData(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      executeDate: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}execute_date']),
      exerciseTemplateId: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}exercise_template_id']),
      userId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      hasBeenExecuted: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}has_been_executed']),
    );
  }
  factory LocalPlannedExerciseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalPlannedExerciseData(
      id: serializer.fromJson<String>(json['id']),
      executeDate: serializer.fromJson<String>(json['executeDate']),
      exerciseTemplateId: serializer.fromJson<int>(json['exerciseTemplateId']),
      userId: serializer.fromJson<int>(json['userId']),
      hasBeenExecuted: serializer.fromJson<int>(json['hasBeenExecuted']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'id': serializer.toJson<String>(id),
      'executeDate': serializer.toJson<String>(executeDate),
      'exerciseTemplateId': serializer.toJson<int>(exerciseTemplateId),
      'userId': serializer.toJson<int>(userId),
      'hasBeenExecuted': serializer.toJson<int>(hasBeenExecuted),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalPlannedExerciseData>>(
      bool nullToAbsent) {
    return LocalPlannedExerciseCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      executeDate: executeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(executeDate),
      exerciseTemplateId: exerciseTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseTemplateId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      hasBeenExecuted: hasBeenExecuted == null && nullToAbsent
          ? const Value.absent()
          : Value(hasBeenExecuted),
    ) as T;
  }

  LocalPlannedExerciseData copyWith(
          {String id,
          String executeDate,
          int exerciseTemplateId,
          int userId,
          int hasBeenExecuted}) =>
      LocalPlannedExerciseData(
        id: id ?? this.id,
        executeDate: executeDate ?? this.executeDate,
        exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
        userId: userId ?? this.userId,
        hasBeenExecuted: hasBeenExecuted ?? this.hasBeenExecuted,
      );
  @override
  String toString() {
    return (StringBuffer('LocalPlannedExerciseData(')
          ..write('id: $id, ')
          ..write('executeDate: $executeDate, ')
          ..write('exerciseTemplateId: $exerciseTemplateId, ')
          ..write('userId: $userId, ')
          ..write('hasBeenExecuted: $hasBeenExecuted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          executeDate.hashCode,
          $mrjc(exerciseTemplateId.hashCode,
              $mrjc(userId.hashCode, hasBeenExecuted.hashCode)))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalPlannedExerciseData &&
          other.id == id &&
          other.executeDate == executeDate &&
          other.exerciseTemplateId == exerciseTemplateId &&
          other.userId == userId &&
          other.hasBeenExecuted == hasBeenExecuted);
}

class LocalPlannedExerciseCompanion
    extends UpdateCompanion<LocalPlannedExerciseData> {
  final Value<String> id;
  final Value<String> executeDate;
  final Value<int> exerciseTemplateId;
  final Value<int> userId;
  final Value<int> hasBeenExecuted;
  const LocalPlannedExerciseCompanion({
    this.id = const Value.absent(),
    this.executeDate = const Value.absent(),
    this.exerciseTemplateId = const Value.absent(),
    this.userId = const Value.absent(),
    this.hasBeenExecuted = const Value.absent(),
  });
  LocalPlannedExerciseCompanion copyWith(
      {Value<String> id,
      Value<String> executeDate,
      Value<int> exerciseTemplateId,
      Value<int> userId,
      Value<int> hasBeenExecuted}) {
    return LocalPlannedExerciseCompanion(
      id: id ?? this.id,
      executeDate: executeDate ?? this.executeDate,
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      userId: userId ?? this.userId,
      hasBeenExecuted: hasBeenExecuted ?? this.hasBeenExecuted,
    );
  }
}

class $LocalPlannedExerciseTable extends LocalPlannedExercise
    with TableInfo<$LocalPlannedExerciseTable, LocalPlannedExerciseData> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalPlannedExerciseTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn('id', $tableName, false, maxTextLength: 64);
  }

  final VerificationMeta _executeDateMeta =
      const VerificationMeta('executeDate');
  GeneratedTextColumn _executeDate;
  @override
  GeneratedTextColumn get executeDate =>
      _executeDate ??= _constructExecuteDate();
  GeneratedTextColumn _constructExecuteDate() {
    return GeneratedTextColumn('execute_date', $tableName, false,
        maxTextLength: 32);
  }

  final VerificationMeta _exerciseTemplateIdMeta =
      const VerificationMeta('exerciseTemplateId');
  GeneratedIntColumn _exerciseTemplateId;
  @override
  GeneratedIntColumn get exerciseTemplateId =>
      _exerciseTemplateId ??= _constructExerciseTemplateId();
  GeneratedIntColumn _constructExerciseTemplateId() {
    return GeneratedIntColumn(
      'exercise_template_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedIntColumn _userId;
  @override
  GeneratedIntColumn get userId => _userId ??= _constructUserId();
  GeneratedIntColumn _constructUserId() {
    return GeneratedIntColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hasBeenExecutedMeta =
      const VerificationMeta('hasBeenExecuted');
  GeneratedIntColumn _hasBeenExecuted;
  @override
  GeneratedIntColumn get hasBeenExecuted =>
      _hasBeenExecuted ??= _constructHasBeenExecuted();
  GeneratedIntColumn _constructHasBeenExecuted() {
    return GeneratedIntColumn(
      'has_been_executed',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, executeDate, exerciseTemplateId, userId, hasBeenExecuted];
  @override
  $LocalPlannedExerciseTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'local_planned_exercise';
  @override
  final String actualTableName = 'local_planned_exercise';
  @override
  VerificationContext validateIntegrity(LocalPlannedExerciseCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.executeDate.present) {
      context.handle(_executeDateMeta,
          executeDate.isAcceptableValue(d.executeDate.value, _executeDateMeta));
    } else if (executeDate.isRequired && isInserting) {
      context.missing(_executeDateMeta);
    }
    if (d.exerciseTemplateId.present) {
      context.handle(
          _exerciseTemplateIdMeta,
          exerciseTemplateId.isAcceptableValue(
              d.exerciseTemplateId.value, _exerciseTemplateIdMeta));
    } else if (exerciseTemplateId.isRequired && isInserting) {
      context.missing(_exerciseTemplateIdMeta);
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (userId.isRequired && isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.hasBeenExecuted.present) {
      context.handle(
          _hasBeenExecutedMeta,
          hasBeenExecuted.isAcceptableValue(
              d.hasBeenExecuted.value, _hasBeenExecutedMeta));
    } else if (hasBeenExecuted.isRequired && isInserting) {
      context.missing(_hasBeenExecutedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  LocalPlannedExerciseData map(Map<String, dynamic> data,
      {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LocalPlannedExerciseData.fromData(data, _db,
        prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LocalPlannedExerciseCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.executeDate.present) {
      map['execute_date'] = Variable<String, StringType>(d.executeDate.value);
    }
    if (d.exerciseTemplateId.present) {
      map['exercise_template_id'] =
          Variable<int, IntType>(d.exerciseTemplateId.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<int, IntType>(d.userId.value);
    }
    if (d.hasBeenExecuted.present) {
      map['has_been_executed'] =
          Variable<int, IntType>(d.hasBeenExecuted.value);
    }
    return map;
  }

  @override
  $LocalPlannedExerciseTable createAlias(String alias) {
    return $LocalPlannedExerciseTable(_db, alias);
  }
}

class LocalCompletedSession extends DataClass
    implements Insertable<LocalCompletedSession> {
  final int sessionId;
  final int userId;
  final int exerciseId;
  final int plannedExerciseId;
  final String completedDate;
  LocalCompletedSession(
      {@required this.sessionId,
      @required this.userId,
      @required this.exerciseId,
      @required this.plannedExerciseId,
      @required this.completedDate});
  factory LocalCompletedSession.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return LocalCompletedSession(
      sessionId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}session_id']),
      userId:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      exerciseId: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}exercise_id']),
      plannedExerciseId: intType.mapFromDatabaseResponse(
          data['${effectivePrefix}planned_exercise_id']),
      completedDate: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}completed_date']),
    );
  }
  factory LocalCompletedSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return LocalCompletedSession(
      sessionId: serializer.fromJson<int>(json['sessionId']),
      userId: serializer.fromJson<int>(json['userId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      plannedExerciseId: serializer.fromJson<int>(json['plannedExerciseId']),
      completedDate: serializer.fromJson<String>(json['completedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return {
      'sessionId': serializer.toJson<int>(sessionId),
      'userId': serializer.toJson<int>(userId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'plannedExerciseId': serializer.toJson<int>(plannedExerciseId),
      'completedDate': serializer.toJson<String>(completedDate),
    };
  }

  @override
  T createCompanion<T extends UpdateCompanion<LocalCompletedSession>>(
      bool nullToAbsent) {
    return LocalCompletedSessionsCompanion(
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      exerciseId: exerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseId),
      plannedExerciseId: plannedExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedExerciseId),
      completedDate: completedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDate),
    ) as T;
  }

  LocalCompletedSession copyWith(
          {int sessionId,
          int userId,
          int exerciseId,
          int plannedExerciseId,
          String completedDate}) =>
      LocalCompletedSession(
        sessionId: sessionId ?? this.sessionId,
        userId: userId ?? this.userId,
        exerciseId: exerciseId ?? this.exerciseId,
        plannedExerciseId: plannedExerciseId ?? this.plannedExerciseId,
        completedDate: completedDate ?? this.completedDate,
      );
  @override
  String toString() {
    return (StringBuffer('LocalCompletedSession(')
          ..write('sessionId: $sessionId, ')
          ..write('userId: $userId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('plannedExerciseId: $plannedExerciseId, ')
          ..write('completedDate: $completedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      sessionId.hashCode,
      $mrjc(
          userId.hashCode,
          $mrjc(exerciseId.hashCode,
              $mrjc(plannedExerciseId.hashCode, completedDate.hashCode)))));
  @override
  bool operator ==(other) =>
      identical(this, other) ||
      (other is LocalCompletedSession &&
          other.sessionId == sessionId &&
          other.userId == userId &&
          other.exerciseId == exerciseId &&
          other.plannedExerciseId == plannedExerciseId &&
          other.completedDate == completedDate);
}

class LocalCompletedSessionsCompanion
    extends UpdateCompanion<LocalCompletedSession> {
  final Value<int> sessionId;
  final Value<int> userId;
  final Value<int> exerciseId;
  final Value<int> plannedExerciseId;
  final Value<String> completedDate;
  const LocalCompletedSessionsCompanion({
    this.sessionId = const Value.absent(),
    this.userId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.plannedExerciseId = const Value.absent(),
    this.completedDate = const Value.absent(),
  });
  LocalCompletedSessionsCompanion copyWith(
      {Value<int> sessionId,
      Value<int> userId,
      Value<int> exerciseId,
      Value<int> plannedExerciseId,
      Value<String> completedDate}) {
    return LocalCompletedSessionsCompanion(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      exerciseId: exerciseId ?? this.exerciseId,
      plannedExerciseId: plannedExerciseId ?? this.plannedExerciseId,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

class $LocalCompletedSessionsTable extends LocalCompletedSessions
    with TableInfo<$LocalCompletedSessionsTable, LocalCompletedSession> {
  final GeneratedDatabase _db;
  final String _alias;
  $LocalCompletedSessionsTable(this._db, [this._alias]);
  final VerificationMeta _sessionIdMeta = const VerificationMeta('sessionId');
  GeneratedIntColumn _sessionId;
  @override
  GeneratedIntColumn get sessionId => _sessionId ??= _constructSessionId();
  GeneratedIntColumn _constructSessionId() {
    return GeneratedIntColumn(
      'session_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedIntColumn _userId;
  @override
  GeneratedIntColumn get userId => _userId ??= _constructUserId();
  GeneratedIntColumn _constructUserId() {
    return GeneratedIntColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _exerciseIdMeta = const VerificationMeta('exerciseId');
  GeneratedIntColumn _exerciseId;
  @override
  GeneratedIntColumn get exerciseId => _exerciseId ??= _constructExerciseId();
  GeneratedIntColumn _constructExerciseId() {
    return GeneratedIntColumn(
      'exercise_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _plannedExerciseIdMeta =
      const VerificationMeta('plannedExerciseId');
  GeneratedIntColumn _plannedExerciseId;
  @override
  GeneratedIntColumn get plannedExerciseId =>
      _plannedExerciseId ??= _constructPlannedExerciseId();
  GeneratedIntColumn _constructPlannedExerciseId() {
    return GeneratedIntColumn(
      'planned_exercise_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _completedDateMeta =
      const VerificationMeta('completedDate');
  GeneratedTextColumn _completedDate;
  @override
  GeneratedTextColumn get completedDate =>
      _completedDate ??= _constructCompletedDate();
  GeneratedTextColumn _constructCompletedDate() {
    return GeneratedTextColumn('completed_date', $tableName, false,
        maxTextLength: 24);
  }

  @override
  List<GeneratedColumn> get $columns =>
      [sessionId, userId, exerciseId, plannedExerciseId, completedDate];
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
    if (d.sessionId.present) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableValue(d.sessionId.value, _sessionIdMeta));
    } else if (sessionId.isRequired && isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (userId.isRequired && isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.exerciseId.present) {
      context.handle(_exerciseIdMeta,
          exerciseId.isAcceptableValue(d.exerciseId.value, _exerciseIdMeta));
    } else if (exerciseId.isRequired && isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (d.plannedExerciseId.present) {
      context.handle(
          _plannedExerciseIdMeta,
          plannedExerciseId.isAcceptableValue(
              d.plannedExerciseId.value, _plannedExerciseIdMeta));
    } else if (plannedExerciseId.isRequired && isInserting) {
      context.missing(_plannedExerciseIdMeta);
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
    if (d.sessionId.present) {
      map['session_id'] = Variable<int, IntType>(d.sessionId.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<int, IntType>(d.userId.value);
    }
    if (d.exerciseId.present) {
      map['exercise_id'] = Variable<int, IntType>(d.exerciseId.value);
    }
    if (d.plannedExerciseId.present) {
      map['planned_exercise_id'] =
          Variable<int, IntType>(d.plannedExerciseId.value);
    }
    if (d.completedDate.present) {
      map['completed_date'] =
          Variable<String, StringType>(d.completedDate.value);
    }
    return map;
  }

  @override
  $LocalCompletedSessionsTable createAlias(String alias) {
    return $LocalCompletedSessionsTable(_db, alias);
  }
}

abstract class _$ExerciseDatabase extends GeneratedDatabase {
  _$ExerciseDatabase(QueryExecutor e)
      : super(const SqlTypeSystem.withDefaults(), e);
  $LocalUsersTable _localUsers;
  $LocalUsersTable get localUsers => _localUsers ??= $LocalUsersTable(this);
  $LocalSessionMaterialsTable _localSessionMaterials;
  $LocalSessionMaterialsTable get localSessionMaterials =>
      _localSessionMaterials ??= $LocalSessionMaterialsTable(this);
  $LocalUserBodyIndexTable _localUserBodyIndex;
  $LocalUserBodyIndexTable get localUserBodyIndex =>
      _localUserBodyIndex ??= $LocalUserBodyIndexTable(this);
  $LocalPlannedExerciseTable _localPlannedExercise;
  $LocalPlannedExerciseTable get localPlannedExercise =>
      _localPlannedExercise ??= $LocalPlannedExerciseTable(this);
  $LocalCompletedSessionsTable _localCompletedSessions;
  $LocalCompletedSessionsTable get localCompletedSessions =>
      _localCompletedSessions ??= $LocalCompletedSessionsTable(this);
  @override
  List<TableInfo> get allTables => [
        localUsers,
        localSessionMaterials,
        localUserBodyIndex,
        localPlannedExercise,
        localCompletedSessions
      ];
}
