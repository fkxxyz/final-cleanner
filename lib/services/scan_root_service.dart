import 'dart:io' show Directory, Platform;

import '../data/database.dart';
import '../data/repositories/scan_root_repository.dart';

class ScanRootService {
  final ScanRootRepository _repo;

  ScanRootService(this._repo);

  Future<ScanRoot> addScanRoot(String path) async {
    if (!Directory(path).existsSync()) {
      throw ArgumentError('Path does not exist or is not a directory: $path');
    }
    return _repo.addScanRoot(path);
  }

  Future<void> deleteScanRoot(int id) => _repo.deleteScanRoot(id);

  Future<void> toggleScanRoot(int id, {required bool enabled}) =>
      _repo.toggleScanRoot(id, enabled);

  Future<List<ScanRoot>> getAllScanRoots() => _repo.getAllScanRoots();

  Future<List<ScanRoot>> getEnabledScanRoots() => _repo.getEnabledScanRoots();

  Stream<List<ScanRoot>> watchAllScanRoots() => _repo.watchAllScanRoots();

  static List<String> getDefaultScanRoots() {
    if (Platform.isAndroid) return ['/storage/emulated/0'];
    if (Platform.isWindows) {
      return ['C:\\Users\\${Platform.environment['USERNAME']}'];
    }
    if (Platform.isLinux) {
      return [Platform.environment['HOME'] ?? '/home'];
    }
    return [];
  }
}
