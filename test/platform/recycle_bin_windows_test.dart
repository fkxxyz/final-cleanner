import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:final_cleaner/platform/recycle_bin_windows.dart';

void main() {
  group('RecycleBinWindows', () {
    late RecycleBinWindows recycleBin;

    setUp(() {
      recycleBin = RecycleBinWindows();
    });

    test('isSupported returns true', () {
      expect(recycleBin.isSupported, true);
    });

    test('moveToTrash returns false for non-existent path', () async {
      final result = await recycleBin.moveToTrash('/non/existent/path.txt');
      expect(result, false);
    });

    test('moveMultipleToTrash collects failed paths', () async {
      final paths = ['/non/existent/file1.txt', '/non/existent/file2.txt'];
      final failed = await recycleBin.moveMultipleToTrash(paths);
      expect(failed, containsAll(paths));
    });

    // Platform-specific tests that only run on Windows
    group('Windows-specific tests', () {
      test('moveToTrash succeeds for existing file', () async {
        if (!Platform.isWindows) {
          // Skip on non-Windows platforms
          return;
        }

        // Create a temporary file
        final tempDir = Directory.systemTemp.createTempSync('recycle_test_');
        final testFile = File('${tempDir.path}/test_file.txt');
        await testFile.writeAsString('test content');

        // Move to trash
        final result = await recycleBin.moveToTrash(testFile.path);
        expect(result, true);

        // Verify file no longer exists at original location
        expect(testFile.existsSync(), false);

        // Cleanup temp directory
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      test('moveToTrash succeeds for existing directory', () async {
        if (!Platform.isWindows) {
          return;
        }

        final tempDir = Directory.systemTemp.createTempSync('recycle_test_');
        final testDir = Directory('${tempDir.path}/test_dir');
        await testDir.create();
        await File('${testDir.path}/file.txt').writeAsString('content');

        final result = await recycleBin.moveToTrash(testDir.path);
        expect(result, true);
        expect(testDir.existsSync(), false);

        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      test('moveToTrash handles path with single quote', () async {
        if (!Platform.isWindows) {
          return;
        }

        final tempDir = Directory.systemTemp.createTempSync('recycle_test_');
        final testFile = File("${tempDir.path}/test'file.txt");
        await testFile.writeAsString('test content');

        final result = await recycleBin.moveToTrash(testFile.path);
        expect(result, true);
        expect(testFile.existsSync(), false);

        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });

      test('moveMultipleToTrash handles mixed success and failure', () async {
        if (!Platform.isWindows) {
          return;
        }

        final tempDir = Directory.systemTemp.createTempSync('recycle_test_');
        final existingFile = File('${tempDir.path}/existing.txt');
        await existingFile.writeAsString('content');

        final paths = [existingFile.path, '/non/existent/file.txt'];

        final failed = await recycleBin.moveMultipleToTrash(paths);
        expect(failed, hasLength(1));
        expect(failed.first, '/non/existent/file.txt');
        expect(existingFile.existsSync(), false);

        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      });
    });
  });
}
