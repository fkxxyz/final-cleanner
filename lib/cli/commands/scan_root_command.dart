import 'package:args/command_runner.dart';

import '../../services/scan_root_service.dart';
import 'cli_command.dart';

/// Branch command for scan root management.
class ScanRootCommand extends Command<void> {
  @override
  final String name = 'scan-root';

  @override
  final String description = 'Manage scan root directories.';

  ScanRootCommand(ScanRootService service) {
    addSubcommand(_ListCommand(service));
    addSubcommand(_AddCommand(service));
    addSubcommand(_RemoveCommand(service));
    addSubcommand(_ToggleCommand(service));
  }
}

class _ListCommand extends CliCommand {
  final ScanRootService _service;

  @override
  final String name = 'list';

  @override
  final String description = 'List all scan roots.';

  _ListCommand(this._service);

  @override
  Future<void> run() async {
    final roots = await _service.getAllScanRoots();
    printResult(
      roots
          .map((r) => {'id': r.id, 'path': r.path, 'enabled': r.enabled})
          .toList(),
    );
  }

  @override
  void printHuman(Object data) {
    final roots = data as List<Map<String, dynamic>>;
    if (roots.isEmpty) {
      print('No scan roots configured.');
      return;
    }
    print('${'ID'.padRight(6)}${'Enabled'.padRight(10)}Path');
    print('-' * 60);
    for (final r in roots) {
      final enabled = (r['enabled'] as bool) ? '✓' : '✗';
      print(
        '${r['id'].toString().padRight(6)}'
        '${enabled.padRight(10)}'
        '${r['path']}',
      );
    }
  }
}

class _AddCommand extends CliCommand {
  final ScanRootService _service;

  @override
  final String name = 'add';

  @override
  final String description = 'Add a scan root directory.';

  _AddCommand(this._service);

  @override
  Future<void> run() async {
    final path = requiredArg(0, 'path');
    final root = await _service.addScanRoot(path);
    printResult({'id': root.id, 'path': root.path, 'enabled': root.enabled});
  }

  @override
  void printHuman(Object data) {
    final d = data as Map<String, dynamic>;
    print('Added scan root: ${d['path']} (id: ${d['id']})');
  }
}

class _RemoveCommand extends CliCommand {
  final ScanRootService _service;

  @override
  final String name = 'remove';

  @override
  final String description = 'Remove a scan root.';

  _RemoveCommand(this._service);

  @override
  Future<void> run() async {
    final id = requiredIntArg(0, 'id');
    await _service.deleteScanRoot(id);
    printResult({'removed': id});
  }

  @override
  void printHuman(Object data) {
    final d = data as Map<String, dynamic>;
    print('Removed scan root ${d['removed']}');
  }
}

class _ToggleCommand extends CliCommand {
  final ScanRootService _service;

  @override
  final String name = 'toggle';

  @override
  final String description = 'Enable or disable a scan root.';

  _ToggleCommand(this._service) {
    argParser
      ..addFlag('enable', help: 'Enable the scan root.', negatable: false)
      ..addFlag('disable', help: 'Disable the scan root.', negatable: false);
  }

  @override
  Future<void> run() async {
    final id = requiredIntArg(0, 'id');
    final enable = argResults!.flag('enable');
    final disable = argResults!.flag('disable');

    if (enable == disable) {
      usageError('Specify exactly one of --enable or --disable.');
    }

    await _service.toggleScanRoot(id, enabled: enable);
    printResult({'id': id, 'enabled': enable});
  }

  @override
  void printHuman(Object data) {
    final d = data as Map<String, dynamic>;
    final state = (d['enabled'] as bool) ? 'enabled' : 'disabled';
    print('Scan root ${d['id']} $state');
  }
}
