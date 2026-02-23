import 'dart:async';
import 'package:final_cleaner/data/database.dart';
import 'package:final_cleaner/models/scan_root.dart';
import 'package:final_cleaner/models/scan_result.dart';

/// Captures stdout output from a function
Future<String> captureStdout(Future<void> Function() fn) async {
  final buffer = StringBuffer();
  await runZoned(
    fn,
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        buffer.writeln(line);
      },
    ),
  );
  return buffer.toString();
}

/// Test data builders
WhitelistItem createWhitelistItem({
  int id = 1,
  String path = '/test',
  String? name,
  String? note,
  bool isDirectory = false,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return WhitelistItem(
    id: id,
    path: path,
    name: name,
    note: note,
    isDirectory: isDirectory,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

Group createGroup({
  int id = 1,
  String name = 'Test Group',
  String? note,
  DateTime? createdAt,
}) {
  return Group(
    id: id,
    name: name,
    note: note,
    createdAt: createdAt ?? DateTime.now(),
  );
}

ScanRoot createScanRoot({
  int? id = 1,
  String path = '/test',
  bool enabled = true,
}) {
  return ScanRoot(id: id, path: path, enabled: enabled);
}

ScanResult createScanResult({
  String path = '/test/file.txt',
  int sizeBytes = 1024,
  DateTime? modifiedAt,
  bool isDirectory = false,
  String? extension,
}) {
  return ScanResult(
    path: path,
    sizeBytes: sizeBytes,
    modifiedAt: modifiedAt ?? DateTime.now(),
    isDirectory: isDirectory,
    extension: extension,
  );
}
