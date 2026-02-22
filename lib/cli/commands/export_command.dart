import 'cli_command.dart';
import '../../services/export_import_service.dart';

/// Exports whitelist configuration to a JSON file.
class ExportCommand extends CliCommand {
  final ExportImportService _service;

  @override
  final String name = 'export';

  @override
  final String description = 'Export whitelist configuration to a JSON file.';

  ExportCommand(this._service);

  @override
  Future<void> run() async {
    final filePath = requiredArg(0, 'file');
    await _service.exportToFile(filePath);
    printResult({'exported': filePath});
  }

  @override
  void printHuman(Object data) {
    final d = data as Map<String, dynamic>;
    print('Exported to: ${d['exported']}');
  }
}
