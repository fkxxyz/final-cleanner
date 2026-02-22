import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../services/deletion_service.dart';
import '../../services/scan_service.dart';
import 'cli_command.dart';

/// Scans and deletes non-whitelisted files.
class CleanCommand extends CliCommand {
  final ScanService _scanService;
  final DeletionService _deletionService;

  @override
  final String name = 'clean';

  @override
  final String description = 'Scan and delete non-whitelisted files.';

  CleanCommand(this._scanService, this._deletionService) {
    argParser.addFlag(
      'yes',
      abbr: 'y',
      help: 'Skip confirmation prompt.',
      negatable: false,
    );
  }

  @override
  Future<void> run() async {
    // Run scan
    final completer = Completer<ScanStatus>();
    final subscription = _scanService.statusStream.listen((status) {
      if (status.state == ScanState.complete) {
        completer.complete(status);
      }
    });

    await _scanService.startScan();
    final finalStatus = await completer.future;
    await subscription.cancel();

    final results = finalStatus.results;
    if (results.isEmpty) {
      if (isJson) {
        print(
          jsonEncode({
            'successCount': 0,
            'failCount': 0,
            'freedBytes': 0,
            'failedPaths': <String>[],
          }),
        );
      } else {
        print('No non-whitelisted files found.');
      }
      return;
    }

    final totalBytes = results.fold<int>(0, (sum, r) => sum + r.sizeBytes);

    // Confirm
    final skipConfirm = argResults!.flag('yes');
    if (!skipConfirm) {
      stdout.write(
        '发现 ${results.length} 个非白名单文件 '
        '(共 ${_formatBytes(totalBytes)})\n'
        '确认删除以上文件？[y/N] ',
      );
      final answer = stdin.readLineSync()?.trim().toLowerCase();
      if (answer != 'y') {
        print('已取消');
        return;
      }
    }

    // Delete
    final result = await _deletionService.deleteItems(results);

    if (isJson) {
      print(
        jsonEncode({
          'successCount': result.successCount,
          'failCount': result.failCount,
          'freedBytes': result.freedBytes,
          'failedPaths': result.failedPaths,
        }),
      );
    } else {
      print(
        '已删除 ${result.successCount} 个文件，'
        '释放 ${_formatBytes(result.freedBytes)}',
      );
      if (result.failedPaths.isNotEmpty) {
        print('${result.failCount} 个文件删除失败:');
        for (final path in result.failedPaths) {
          print('  $path');
        }
      }
    }
  }

  @override
  void printHuman(Object data) {
    // Output is handled directly in run().
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  }
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}
