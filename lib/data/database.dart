import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [WhitelistItems, Groups, GroupClosure, ItemGroupRelations, ScanRoots],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Opens a database at the given file [path].
  AppDatabase.withPath(String path)
    : super(NativeDatabase.createInBackground(File(path)));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }
}
