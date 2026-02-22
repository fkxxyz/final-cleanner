import 'package:drift/drift.dart';

import '../database.dart';

class ScanRootRepository {
  final AppDatabase _db;

  ScanRootRepository(this._db);

  Future<ScanRoot> addScanRoot(String path, {bool enabled = true}) async {
    final id = await _db
        .into(_db.scanRoots)
        .insert(ScanRootsCompanion.insert(path: path, enabled: Value(enabled)));
    return ScanRoot(id: id, path: path, enabled: enabled);
  }

  Future<void> deleteScanRoot(int id) async {
    await (_db.delete(_db.scanRoots)..where((t) => t.id.equals(id))).go();
  }

  Future<void> toggleScanRoot(int id, bool enabled) async {
    await (_db.update(_db.scanRoots)..where((t) => t.id.equals(id))).write(
      ScanRootsCompanion(enabled: Value(enabled)),
    );
  }

  Future<List<ScanRoot>> getAllScanRoots() {
    return _db.select(_db.scanRoots).get();
  }

  Future<List<ScanRoot>> getEnabledScanRoots() {
    return (_db.select(
      _db.scanRoots,
    )..where((t) => t.enabled.equals(true))).get();
  }

  Stream<List<ScanRoot>> watchAllScanRoots() {
    return _db.select(_db.scanRoots).watch();
  }
}
