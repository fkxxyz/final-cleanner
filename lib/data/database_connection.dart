import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Creates a [LazyDatabase] connection for the GUI using path_provider.
///
/// This is separated from database.dart so that CLI code can import
/// the database class without pulling in Flutter dependencies.
LazyDatabase openGuiConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'final_cleaner.db'));
    return NativeDatabase.createInBackground(file);
  });
}
