import 'dart:io';
import '../../models/scan_result.dart';
import '../path_trie.dart';

class ScanProgress {
  final int scannedCount;
  final int foundCount;
  final String currentPath;

  const ScanProgress({
    required this.scannedCount,
    required this.foundCount,
    required this.currentPath,
  });
}

typedef IsWhitelistedFn = bool Function(String path);

class FilesystemScanner {
  Stream<dynamic> scan(String rootPath, IsWhitelistedFn isWhitelisted) async* {
    final rootDir = Directory(rootPath);
    if (!rootDir.existsSync()) {
      return;
    }

    final normalizedRoot = PathTrie.normalizePath(rootPath);
    if (isWhitelisted(normalizedRoot)) {
      return;
    }

    final stack = <Directory>[rootDir];
    final visitedPaths = <String>{};
    var scannedCount = 0;
    var foundCount = 0;

    while (stack.isNotEmpty) {
      final dir = stack.removeLast();

      try {
        final entities = dir.listSync(followLinks: false);

        for (final entity in entities) {
          scannedCount++;
          final entityPath = PathTrie.normalizePath(entity.path);

          if (scannedCount % 1000 == 0) {
            yield ScanProgress(
              scannedCount: scannedCount,
              foundCount: foundCount,
              currentPath: entityPath,
            );
          }

          if (isWhitelisted(entityPath)) {
            continue;
          }

          try {
            final stat = entity.statSync();

            if (visitedPaths.contains(entityPath)) {
              continue;
            }
            visitedPaths.add(entityPath);

            final isDir = entity is Directory;
            String? extension;
            if (!isDir && entity is File) {
              final name = entity.uri.pathSegments.last;
              final dotIndex = name.lastIndexOf('.');
              if (dotIndex > 0 && dotIndex < name.length - 1) {
                extension = name.substring(dotIndex + 1);
              }
            }

            foundCount++;
            yield ScanResult(
              path: entityPath,
              sizeBytes: stat.size,
              modifiedAt: stat.modified,
              isDirectory: isDir,
              extension: extension,
            );

            if (isDir) {
              stack.add(Directory(entityPath));
            }
          } on FileSystemException catch (e) {
            // Log permission errors instead of silently skipping
            print('FileSystemException accessing $entityPath: ${e.message}');
            continue;
        }
      } on FileSystemException {
        continue;
      }
    }
  }
}
