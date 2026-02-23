import 'package:drift/drift.dart';

class WhitelistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text().unique()();
  TextColumn get name => text().nullable()();
  TextColumn get note => text().nullable()();
  BoolColumn get isDirectory => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get groupId => integer().nullable().references(Groups, #id)();
}

class Groups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class GroupClosure extends Table {
  @ReferenceName('ancestorClosures')
  IntColumn get ancestor => integer().references(Groups, #id)();
  @ReferenceName('descendantClosures')
  IntColumn get descendant => integer().references(Groups, #id)();
  IntColumn get depth => integer()();

  @override
  Set<Column> get primaryKey => {ancestor, descendant};
}



class ScanRoots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text().unique()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
}
