import 'dart:io';

import 'recycle_bin.dart';

class RecycleBinWindows implements RecycleBin {
  @override
  bool get isSupported => false;

  @override
  Future<bool> moveToTrash(String path) async {
    try {
      final type = FileSystemEntity.typeSync(path);
      if (type == FileSystemEntityType.notFound) return false;

      if (type == FileSystemEntityType.directory) {
        await Directory(path).delete(recursive: true);
      } else {
        await File(path).delete();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<String>> moveMultipleToTrash(List<String> paths) async {
    final failed = <String>[];
    for (final path in paths) {
      if (!await moveToTrash(path)) {
        failed.add(path);
      }
    }
    return failed;
  }
}
