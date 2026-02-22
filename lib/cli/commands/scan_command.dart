import 'dart:async';

import '../../models/scan_result.dart';
import '../../services/scan_service.dart';
import 'cli_command.dart';

/// Scans the filesystem and outputs non-whitelisted files.
class ScanCommand extends CliCommand {
  final ScanService _service;

  @override
  final String name = 'scan';

  @override
  final String description = 'Scan filesystem for non-whitelisted files.';

  ScanCommand(this._service);

  @override
  Future<void> run() async {
    final completer = Completer<ScanStatus>();
    final subscription = _service.statusStream.listen((status) {
      if (status.state == ScanState.complete) {
        completer.complete(status);
      }
    });

    await _service.startScan();
    final finalStatus = await completer.future;
    await subscription.cancel();

    printResult(finalStatus.results);
  }

  @override
  void printHuman(Object data) {
    final results = data as List<ScanResult>;
    if (results.isEmpty) {
      print('No non-whitelisted files found.');
      return;
    }

    for (final r in results) {
      final date =
          '${r.modifiedAt.year}-'
          '${r.modifiedAt.month.toString().padLeft(2, '0')}-'
          '${r.modifiedAt.day.toString().padLeft(2, '0')}';
      print(
        '${r.path.padRight(60)}'
        '${r.formattedSize.padRight(12)}'
        '$date',
      );
    }

    final totalBytes = results.fold<int>(0, (sum, r) => sum + r.sizeBytes);
    print('');
    print('共 ${results.length} 个文件，${_formatBytes(totalBytes)}');
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
