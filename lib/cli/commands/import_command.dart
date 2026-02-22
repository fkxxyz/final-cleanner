import 'dart:io';

import 'cli_command.dart';
import '../../services/export_import_service.dart';

/// Imports whitelist configuration from a JSON file.
class ImportCommand extends CliCommand {
  final ExportImportService _service;

  @override
  final String name = 'import';

  @override
  final String description = 'Import whitelist configuration from a JSON file.';

  ImportCommand(this._service);

  @override
  Future<void> run() async {
    final filePath = requiredArg(0, 'file');
    if (!File(filePath).existsSync()) {
      throw StateError('File not found: $filePath');
    }
    await _service.importFromFile(filePath);
    printResult({'imported': filePath});
  }

  @override
  void printHuman(Object data) {
    final d = data as Map<String, dynamic>;
    print('Imported from: ${d['imported']}');
  }
}
