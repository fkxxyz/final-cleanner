// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<Group> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final int id;
  final String name;
  final String? note;
  final DateTime createdAt;
  const Group({
    required this.id,
    required this.name,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Group.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Group copyWith({
    int? id,
    String? name,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Group(
    id: id ?? this.id,
    name: name ?? this.name,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Group> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GroupsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WhitelistItemsTable extends WhitelistItems
    with TableInfo<$WhitelistItemsTable, WhitelistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WhitelistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDirectoryMeta = const VerificationMeta(
    'isDirectory',
  );
  @override
  late final GeneratedColumn<bool> isDirectory = GeneratedColumn<bool>(
    'is_directory',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_directory" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    path,
    name,
    note,
    isDirectory,
    createdAt,
    updatedAt,
    groupId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'whitelist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WhitelistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_directory')) {
      context.handle(
        _isDirectoryMeta,
        isDirectory.isAcceptableOrUnknown(
          data['is_directory']!,
          _isDirectoryMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WhitelistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WhitelistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isDirectory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_directory'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      ),
    );
  }

  @override
  $WhitelistItemsTable createAlias(String alias) {
    return $WhitelistItemsTable(attachedDatabase, alias);
  }
}

class WhitelistItem extends DataClass implements Insertable<WhitelistItem> {
  final int id;
  final String path;
  final String? name;
  final String? note;
  final bool isDirectory;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? groupId;
  const WhitelistItem({
    required this.id,
    required this.path,
    this.name,
    this.note,
    required this.isDirectory,
    required this.createdAt,
    required this.updatedAt,
    this.groupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_directory'] = Variable<bool>(isDirectory);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    return map;
  }

  WhitelistItemsCompanion toCompanion(bool nullToAbsent) {
    return WhitelistItemsCompanion(
      id: Value(id),
      path: Value(path),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isDirectory: Value(isDirectory),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
    );
  }

  factory WhitelistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WhitelistItem(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      name: serializer.fromJson<String?>(json['name']),
      note: serializer.fromJson<String?>(json['note']),
      isDirectory: serializer.fromJson<bool>(json['isDirectory']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      groupId: serializer.fromJson<int?>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'name': serializer.toJson<String?>(name),
      'note': serializer.toJson<String?>(note),
      'isDirectory': serializer.toJson<bool>(isDirectory),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'groupId': serializer.toJson<int?>(groupId),
    };
  }

  WhitelistItem copyWith({
    int? id,
    String? path,
    Value<String?> name = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? isDirectory,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<int?> groupId = const Value.absent(),
  }) => WhitelistItem(
    id: id ?? this.id,
    path: path ?? this.path,
    name: name.present ? name.value : this.name,
    note: note.present ? note.value : this.note,
    isDirectory: isDirectory ?? this.isDirectory,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    groupId: groupId.present ? groupId.value : this.groupId,
  );
  WhitelistItem copyWithCompanion(WhitelistItemsCompanion data) {
    return WhitelistItem(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      name: data.name.present ? data.name.value : this.name,
      note: data.note.present ? data.note.value : this.note,
      isDirectory: data.isDirectory.present
          ? data.isDirectory.value
          : this.isDirectory,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WhitelistItem(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('isDirectory: $isDirectory, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    path,
    name,
    note,
    isDirectory,
    createdAt,
    updatedAt,
    groupId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WhitelistItem &&
          other.id == this.id &&
          other.path == this.path &&
          other.name == this.name &&
          other.note == this.note &&
          other.isDirectory == this.isDirectory &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.groupId == this.groupId);
}

class WhitelistItemsCompanion extends UpdateCompanion<WhitelistItem> {
  final Value<int> id;
  final Value<String> path;
  final Value<String?> name;
  final Value<String?> note;
  final Value<bool> isDirectory;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> groupId;
  const WhitelistItemsCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.name = const Value.absent(),
    this.note = const Value.absent(),
    this.isDirectory = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.groupId = const Value.absent(),
  });
  WhitelistItemsCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    this.name = const Value.absent(),
    this.note = const Value.absent(),
    this.isDirectory = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.groupId = const Value.absent(),
  }) : path = Value(path);
  static Insertable<WhitelistItem> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<String>? name,
    Expression<String>? note,
    Expression<bool>? isDirectory,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? groupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (name != null) 'name': name,
      if (note != null) 'note': note,
      if (isDirectory != null) 'is_directory': isDirectory,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (groupId != null) 'group_id': groupId,
    });
  }

  WhitelistItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? path,
    Value<String?>? name,
    Value<String?>? note,
    Value<bool>? isDirectory,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int?>? groupId,
  }) {
    return WhitelistItemsCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      note: note ?? this.note,
      isDirectory: isDirectory ?? this.isDirectory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isDirectory.present) {
      map['is_directory'] = Variable<bool>(isDirectory.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WhitelistItemsCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('isDirectory: $isDirectory, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }
}

class $GroupClosureTable extends GroupClosure
    with TableInfo<$GroupClosureTable, GroupClosureData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupClosureTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ancestorMeta = const VerificationMeta(
    'ancestor',
  );
  @override
  late final GeneratedColumn<int> ancestor = GeneratedColumn<int>(
    'ancestor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _descendantMeta = const VerificationMeta(
    'descendant',
  );
  @override
  late final GeneratedColumn<int> descendant = GeneratedColumn<int>(
    'descendant',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id)',
    ),
  );
  static const VerificationMeta _depthMeta = const VerificationMeta('depth');
  @override
  late final GeneratedColumn<int> depth = GeneratedColumn<int>(
    'depth',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ancestor, descendant, depth];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_closure';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupClosureData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ancestor')) {
      context.handle(
        _ancestorMeta,
        ancestor.isAcceptableOrUnknown(data['ancestor']!, _ancestorMeta),
      );
    } else if (isInserting) {
      context.missing(_ancestorMeta);
    }
    if (data.containsKey('descendant')) {
      context.handle(
        _descendantMeta,
        descendant.isAcceptableOrUnknown(data['descendant']!, _descendantMeta),
      );
    } else if (isInserting) {
      context.missing(_descendantMeta);
    }
    if (data.containsKey('depth')) {
      context.handle(
        _depthMeta,
        depth.isAcceptableOrUnknown(data['depth']!, _depthMeta),
      );
    } else if (isInserting) {
      context.missing(_depthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ancestor, descendant};
  @override
  GroupClosureData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupClosureData(
      ancestor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ancestor'],
      )!,
      descendant: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}descendant'],
      )!,
      depth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}depth'],
      )!,
    );
  }

  @override
  $GroupClosureTable createAlias(String alias) {
    return $GroupClosureTable(attachedDatabase, alias);
  }
}

class GroupClosureData extends DataClass
    implements Insertable<GroupClosureData> {
  final int ancestor;
  final int descendant;
  final int depth;
  const GroupClosureData({
    required this.ancestor,
    required this.descendant,
    required this.depth,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ancestor'] = Variable<int>(ancestor);
    map['descendant'] = Variable<int>(descendant);
    map['depth'] = Variable<int>(depth);
    return map;
  }

  GroupClosureCompanion toCompanion(bool nullToAbsent) {
    return GroupClosureCompanion(
      ancestor: Value(ancestor),
      descendant: Value(descendant),
      depth: Value(depth),
    );
  }

  factory GroupClosureData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupClosureData(
      ancestor: serializer.fromJson<int>(json['ancestor']),
      descendant: serializer.fromJson<int>(json['descendant']),
      depth: serializer.fromJson<int>(json['depth']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ancestor': serializer.toJson<int>(ancestor),
      'descendant': serializer.toJson<int>(descendant),
      'depth': serializer.toJson<int>(depth),
    };
  }

  GroupClosureData copyWith({int? ancestor, int? descendant, int? depth}) =>
      GroupClosureData(
        ancestor: ancestor ?? this.ancestor,
        descendant: descendant ?? this.descendant,
        depth: depth ?? this.depth,
      );
  GroupClosureData copyWithCompanion(GroupClosureCompanion data) {
    return GroupClosureData(
      ancestor: data.ancestor.present ? data.ancestor.value : this.ancestor,
      descendant: data.descendant.present
          ? data.descendant.value
          : this.descendant,
      depth: data.depth.present ? data.depth.value : this.depth,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupClosureData(')
          ..write('ancestor: $ancestor, ')
          ..write('descendant: $descendant, ')
          ..write('depth: $depth')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ancestor, descendant, depth);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupClosureData &&
          other.ancestor == this.ancestor &&
          other.descendant == this.descendant &&
          other.depth == this.depth);
}

class GroupClosureCompanion extends UpdateCompanion<GroupClosureData> {
  final Value<int> ancestor;
  final Value<int> descendant;
  final Value<int> depth;
  final Value<int> rowid;
  const GroupClosureCompanion({
    this.ancestor = const Value.absent(),
    this.descendant = const Value.absent(),
    this.depth = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupClosureCompanion.insert({
    required int ancestor,
    required int descendant,
    required int depth,
    this.rowid = const Value.absent(),
  }) : ancestor = Value(ancestor),
       descendant = Value(descendant),
       depth = Value(depth);
  static Insertable<GroupClosureData> custom({
    Expression<int>? ancestor,
    Expression<int>? descendant,
    Expression<int>? depth,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ancestor != null) 'ancestor': ancestor,
      if (descendant != null) 'descendant': descendant,
      if (depth != null) 'depth': depth,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupClosureCompanion copyWith({
    Value<int>? ancestor,
    Value<int>? descendant,
    Value<int>? depth,
    Value<int>? rowid,
  }) {
    return GroupClosureCompanion(
      ancestor: ancestor ?? this.ancestor,
      descendant: descendant ?? this.descendant,
      depth: depth ?? this.depth,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ancestor.present) {
      map['ancestor'] = Variable<int>(ancestor.value);
    }
    if (descendant.present) {
      map['descendant'] = Variable<int>(descendant.value);
    }
    if (depth.present) {
      map['depth'] = Variable<int>(depth.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupClosureCompanion(')
          ..write('ancestor: $ancestor, ')
          ..write('descendant: $descendant, ')
          ..write('depth: $depth, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScanRootsTable extends ScanRoots
    with TableInfo<$ScanRootsTable, ScanRoot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanRootsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, path, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_roots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanRoot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanRoot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanRoot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $ScanRootsTable createAlias(String alias) {
    return $ScanRootsTable(attachedDatabase, alias);
  }
}

class ScanRoot extends DataClass implements Insertable<ScanRoot> {
  final int id;
  final String path;
  final bool enabled;
  const ScanRoot({required this.id, required this.path, required this.enabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  ScanRootsCompanion toCompanion(bool nullToAbsent) {
    return ScanRootsCompanion(
      id: Value(id),
      path: Value(path),
      enabled: Value(enabled),
    );
  }

  factory ScanRoot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanRoot(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  ScanRoot copyWith({int? id, String? path, bool? enabled}) => ScanRoot(
    id: id ?? this.id,
    path: path ?? this.path,
    enabled: enabled ?? this.enabled,
  );
  ScanRoot copyWithCompanion(ScanRootsCompanion data) {
    return ScanRoot(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanRoot(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanRoot &&
          other.id == this.id &&
          other.path == this.path &&
          other.enabled == this.enabled);
}

class ScanRootsCompanion extends UpdateCompanion<ScanRoot> {
  final Value<int> id;
  final Value<String> path;
  final Value<bool> enabled;
  const ScanRootsCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  ScanRootsCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    this.enabled = const Value.absent(),
  }) : path = Value(path);
  static Insertable<ScanRoot> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (enabled != null) 'enabled': enabled,
    });
  }

  ScanRootsCompanion copyWith({
    Value<int>? id,
    Value<String>? path,
    Value<bool>? enabled,
  }) {
    return ScanRootsCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanRootsCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $WhitelistItemsTable whitelistItems = $WhitelistItemsTable(this);
  late final $GroupClosureTable groupClosure = $GroupClosureTable(this);
  late final $ScanRootsTable scanRoots = $ScanRootsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    groups,
    whitelistItems,
    groupClosure,
    scanRoots,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$GroupsTableCreateCompanionBuilder =
    GroupsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$GroupsTableUpdateCompanionBuilder =
    GroupsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WhitelistItemsTable, List<WhitelistItem>>
  _whitelistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.whitelistItems,
    aliasName: $_aliasNameGenerator(db.groups.id, db.whitelistItems.groupId),
  );

  $$WhitelistItemsTableProcessedTableManager get whitelistItemsRefs {
    final manager = $$WhitelistItemsTableTableManager(
      $_db,
      $_db.whitelistItems,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_whitelistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupClosureTable, List<GroupClosureData>>
  _ancestorClosuresTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupClosure,
    aliasName: $_aliasNameGenerator(db.groups.id, db.groupClosure.ancestor),
  );

  $$GroupClosureTableProcessedTableManager get ancestorClosures {
    final manager = $$GroupClosureTableTableManager(
      $_db,
      $_db.groupClosure,
    ).filter((f) => f.ancestor.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ancestorClosuresTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupClosureTable, List<GroupClosureData>>
  _descendantClosuresTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupClosure,
    aliasName: $_aliasNameGenerator(db.groups.id, db.groupClosure.descendant),
  );

  $$GroupClosureTableProcessedTableManager get descendantClosures {
    final manager = $$GroupClosureTableTableManager(
      $_db,
      $_db.groupClosure,
    ).filter((f) => f.descendant.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_descendantClosuresTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> whitelistItemsRefs(
    Expression<bool> Function($$WhitelistItemsTableFilterComposer f) f,
  ) {
    final $$WhitelistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.whitelistItems,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WhitelistItemsTableFilterComposer(
            $db: $db,
            $table: $db.whitelistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ancestorClosures(
    Expression<bool> Function($$GroupClosureTableFilterComposer f) f,
  ) {
    final $$GroupClosureTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupClosure,
      getReferencedColumn: (t) => t.ancestor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupClosureTableFilterComposer(
            $db: $db,
            $table: $db.groupClosure,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> descendantClosures(
    Expression<bool> Function($$GroupClosureTableFilterComposer f) f,
  ) {
    final $$GroupClosureTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupClosure,
      getReferencedColumn: (t) => t.descendant,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupClosureTableFilterComposer(
            $db: $db,
            $table: $db.groupClosure,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> whitelistItemsRefs<T extends Object>(
    Expression<T> Function($$WhitelistItemsTableAnnotationComposer a) f,
  ) {
    final $$WhitelistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.whitelistItems,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WhitelistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.whitelistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ancestorClosures<T extends Object>(
    Expression<T> Function($$GroupClosureTableAnnotationComposer a) f,
  ) {
    final $$GroupClosureTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupClosure,
      getReferencedColumn: (t) => t.ancestor,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupClosureTableAnnotationComposer(
            $db: $db,
            $table: $db.groupClosure,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> descendantClosures<T extends Object>(
    Expression<T> Function($$GroupClosureTableAnnotationComposer a) f,
  ) {
    final $$GroupClosureTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupClosure,
      getReferencedColumn: (t) => t.descendant,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupClosureTableAnnotationComposer(
            $db: $db,
            $table: $db.groupClosure,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          Group,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (Group, $$GroupsTableReferences),
          Group,
          PrefetchHooks Function({
            bool whitelistItemsRefs,
            bool ancestorClosures,
            bool descendantClosures,
          })
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                name: name,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                name: name,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GroupsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                whitelistItemsRefs = false,
                ancestorClosures = false,
                descendantClosures = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (whitelistItemsRefs) db.whitelistItems,
                    if (ancestorClosures) db.groupClosure,
                    if (descendantClosures) db.groupClosure,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (whitelistItemsRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          WhitelistItem
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._whitelistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).whitelistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ancestorClosures)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          GroupClosureData
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._ancestorClosuresTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).ancestorClosures,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ancestor == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (descendantClosures)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          GroupClosureData
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._descendantClosuresTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).descendantClosures,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.descendant == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      Group,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (Group, $$GroupsTableReferences),
      Group,
      PrefetchHooks Function({
        bool whitelistItemsRefs,
        bool ancestorClosures,
        bool descendantClosures,
      })
    >;
typedef $$WhitelistItemsTableCreateCompanionBuilder =
    WhitelistItemsCompanion Function({
      Value<int> id,
      required String path,
      Value<String?> name,
      Value<String?> note,
      Value<bool> isDirectory,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int?> groupId,
    });
typedef $$WhitelistItemsTableUpdateCompanionBuilder =
    WhitelistItemsCompanion Function({
      Value<int> id,
      Value<String> path,
      Value<String?> name,
      Value<String?> note,
      Value<bool> isDirectory,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int?> groupId,
    });

final class $$WhitelistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $WhitelistItemsTable, WhitelistItem> {
  $$WhitelistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTable _groupIdTable(_$AppDatabase db) => db.groups.createAlias(
    $_aliasNameGenerator(db.whitelistItems.groupId, db.groups.id),
  );

  $$GroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<int>('group_id');
    if ($_column == null) return null;
    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WhitelistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WhitelistItemsTable> {
  $$WhitelistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDirectory => $composableBuilder(
    column: $table.isDirectory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WhitelistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WhitelistItemsTable> {
  $$WhitelistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDirectory => $composableBuilder(
    column: $table.isDirectory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WhitelistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WhitelistItemsTable> {
  $$WhitelistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isDirectory => $composableBuilder(
    column: $table.isDirectory,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WhitelistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WhitelistItemsTable,
          WhitelistItem,
          $$WhitelistItemsTableFilterComposer,
          $$WhitelistItemsTableOrderingComposer,
          $$WhitelistItemsTableAnnotationComposer,
          $$WhitelistItemsTableCreateCompanionBuilder,
          $$WhitelistItemsTableUpdateCompanionBuilder,
          (WhitelistItem, $$WhitelistItemsTableReferences),
          WhitelistItem,
          PrefetchHooks Function({bool groupId})
        > {
  $$WhitelistItemsTableTableManager(
    _$AppDatabase db,
    $WhitelistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WhitelistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WhitelistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WhitelistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isDirectory = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int?> groupId = const Value.absent(),
              }) => WhitelistItemsCompanion(
                id: id,
                path: path,
                name: name,
                note: note,
                isDirectory: isDirectory,
                createdAt: createdAt,
                updatedAt: updatedAt,
                groupId: groupId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String path,
                Value<String?> name = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isDirectory = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int?> groupId = const Value.absent(),
              }) => WhitelistItemsCompanion.insert(
                id: id,
                path: path,
                name: name,
                note: note,
                isDirectory: isDirectory,
                createdAt: createdAt,
                updatedAt: updatedAt,
                groupId: groupId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WhitelistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$WhitelistItemsTableReferences
                                    ._groupIdTable(db),
                                referencedColumn:
                                    $$WhitelistItemsTableReferences
                                        ._groupIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WhitelistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WhitelistItemsTable,
      WhitelistItem,
      $$WhitelistItemsTableFilterComposer,
      $$WhitelistItemsTableOrderingComposer,
      $$WhitelistItemsTableAnnotationComposer,
      $$WhitelistItemsTableCreateCompanionBuilder,
      $$WhitelistItemsTableUpdateCompanionBuilder,
      (WhitelistItem, $$WhitelistItemsTableReferences),
      WhitelistItem,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$GroupClosureTableCreateCompanionBuilder =
    GroupClosureCompanion Function({
      required int ancestor,
      required int descendant,
      required int depth,
      Value<int> rowid,
    });
typedef $$GroupClosureTableUpdateCompanionBuilder =
    GroupClosureCompanion Function({
      Value<int> ancestor,
      Value<int> descendant,
      Value<int> depth,
      Value<int> rowid,
    });

final class $$GroupClosureTableReferences
    extends
        BaseReferences<_$AppDatabase, $GroupClosureTable, GroupClosureData> {
  $$GroupClosureTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _ancestorTable(_$AppDatabase db) => db.groups.createAlias(
    $_aliasNameGenerator(db.groupClosure.ancestor, db.groups.id),
  );

  $$GroupsTableProcessedTableManager get ancestor {
    final $_column = $_itemColumn<int>('ancestor')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ancestorTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GroupsTable _descendantTable(_$AppDatabase db) =>
      db.groups.createAlias(
        $_aliasNameGenerator(db.groupClosure.descendant, db.groups.id),
      );

  $$GroupsTableProcessedTableManager get descendant {
    final $_column = $_itemColumn<int>('descendant')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_descendantTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupClosureTableFilterComposer
    extends Composer<_$AppDatabase, $GroupClosureTable> {
  $$GroupClosureTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get depth => $composableBuilder(
    column: $table.depth,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get ancestor {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ancestor,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableFilterComposer get descendant {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.descendant,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupClosureTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupClosureTable> {
  $$GroupClosureTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get depth => $composableBuilder(
    column: $table.depth,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get ancestor {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ancestor,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableOrderingComposer get descendant {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.descendant,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupClosureTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupClosureTable> {
  $$GroupClosureTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get depth =>
      $composableBuilder(column: $table.depth, builder: (column) => column);

  $$GroupsTableAnnotationComposer get ancestor {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ancestor,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GroupsTableAnnotationComposer get descendant {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.descendant,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupClosureTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupClosureTable,
          GroupClosureData,
          $$GroupClosureTableFilterComposer,
          $$GroupClosureTableOrderingComposer,
          $$GroupClosureTableAnnotationComposer,
          $$GroupClosureTableCreateCompanionBuilder,
          $$GroupClosureTableUpdateCompanionBuilder,
          (GroupClosureData, $$GroupClosureTableReferences),
          GroupClosureData,
          PrefetchHooks Function({bool ancestor, bool descendant})
        > {
  $$GroupClosureTableTableManager(_$AppDatabase db, $GroupClosureTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupClosureTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupClosureTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupClosureTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ancestor = const Value.absent(),
                Value<int> descendant = const Value.absent(),
                Value<int> depth = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupClosureCompanion(
                ancestor: ancestor,
                descendant: descendant,
                depth: depth,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int ancestor,
                required int descendant,
                required int depth,
                Value<int> rowid = const Value.absent(),
              }) => GroupClosureCompanion.insert(
                ancestor: ancestor,
                descendant: descendant,
                depth: depth,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupClosureTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ancestor = false, descendant = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ancestor) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ancestor,
                                referencedTable: $$GroupClosureTableReferences
                                    ._ancestorTable(db),
                                referencedColumn: $$GroupClosureTableReferences
                                    ._ancestorTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (descendant) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.descendant,
                                referencedTable: $$GroupClosureTableReferences
                                    ._descendantTable(db),
                                referencedColumn: $$GroupClosureTableReferences
                                    ._descendantTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupClosureTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupClosureTable,
      GroupClosureData,
      $$GroupClosureTableFilterComposer,
      $$GroupClosureTableOrderingComposer,
      $$GroupClosureTableAnnotationComposer,
      $$GroupClosureTableCreateCompanionBuilder,
      $$GroupClosureTableUpdateCompanionBuilder,
      (GroupClosureData, $$GroupClosureTableReferences),
      GroupClosureData,
      PrefetchHooks Function({bool ancestor, bool descendant})
    >;
typedef $$ScanRootsTableCreateCompanionBuilder =
    ScanRootsCompanion Function({
      Value<int> id,
      required String path,
      Value<bool> enabled,
    });
typedef $$ScanRootsTableUpdateCompanionBuilder =
    ScanRootsCompanion Function({
      Value<int> id,
      Value<String> path,
      Value<bool> enabled,
    });

class $$ScanRootsTableFilterComposer
    extends Composer<_$AppDatabase, $ScanRootsTable> {
  $$ScanRootsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScanRootsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanRootsTable> {
  $$ScanRootsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScanRootsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanRootsTable> {
  $$ScanRootsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$ScanRootsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScanRootsTable,
          ScanRoot,
          $$ScanRootsTableFilterComposer,
          $$ScanRootsTableOrderingComposer,
          $$ScanRootsTableAnnotationComposer,
          $$ScanRootsTableCreateCompanionBuilder,
          $$ScanRootsTableUpdateCompanionBuilder,
          (ScanRoot, BaseReferences<_$AppDatabase, $ScanRootsTable, ScanRoot>),
          ScanRoot,
          PrefetchHooks Function()
        > {
  $$ScanRootsTableTableManager(_$AppDatabase db, $ScanRootsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanRootsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanRootsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanRootsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => ScanRootsCompanion(id: id, path: path, enabled: enabled),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String path,
                Value<bool> enabled = const Value.absent(),
              }) => ScanRootsCompanion.insert(
                id: id,
                path: path,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScanRootsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScanRootsTable,
      ScanRoot,
      $$ScanRootsTableFilterComposer,
      $$ScanRootsTableOrderingComposer,
      $$ScanRootsTableAnnotationComposer,
      $$ScanRootsTableCreateCompanionBuilder,
      $$ScanRootsTableUpdateCompanionBuilder,
      (ScanRoot, BaseReferences<_$AppDatabase, $ScanRootsTable, ScanRoot>),
      ScanRoot,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$WhitelistItemsTableTableManager get whitelistItems =>
      $$WhitelistItemsTableTableManager(_db, _db.whitelistItems);
  $$GroupClosureTableTableManager get groupClosure =>
      $$GroupClosureTableTableManager(_db, _db.groupClosure);
  $$ScanRootsTableTableManager get scanRoots =>
      $$ScanRootsTableTableManager(_db, _db.scanRoots);
}
