import 'package:args/command_runner.dart';

import '../../data/database.dart';
import '../../services/whitelist_service.dart';
import 'cli_command.dart';

/// Branch command for whitelist management.
class WhitelistCommand extends Command<void> {
  @override
  final String name = 'whitelist';

  @override
  final String description = 'Manage whitelist items.';

  WhitelistCommand(WhitelistService service) {
    addSubcommand(_ListCommand(service));
    addSubcommand(_AddCommand(service));
    addSubcommand(_RemoveCommand(service));
    addSubcommand(_SearchCommand(service));
  }
}

class _ListCommand extends CliCommand {
  final WhitelistService _service;

  @override
  final String name = 'list';

  @override
  final String description = 'List all whitelist items.';

  _ListCommand(this._service);

  @override
  Future<void> run() async {
    final items = await _service.getAllItems();
    printResult(_itemsToData(items));
  }

  @override
  void printHuman(Object data) {
    final items = data as List<Map<String, dynamic>>;
    if (items.isEmpty) {
      print('No whitelist items.');
      return;
    }
    print(
      '${'ID'.padRight(6)}'
      '${'Path'.padRight(50)}'
      '${'Type'.padRight(6)}'
      '${'Name'.padRight(20)}'
      'Note',
    );
    print('-' * 90);
    for (final item in items) {
      print(
        '${item['id'].toString().padRight(6)}'
        '${(item['path'] as String).padRight(50)}'
        '${(item['isDirectory'] as bool ? 'dir' : 'file').padRight(6)}'
        '${((item['name'] as String?) ?? '').padRight(20)}'
        '${(item['note'] as String?) ?? ''}',
      );
    }
  }
}

class _AddCommand extends CliCommand {
  final WhitelistService _service;

  @override
  final String name = 'add';

  @override
  final String description = 'Add a path to the whitelist.';

  _AddCommand(this._service) {
    argParser
      ..addFlag('dir', help: 'Mark as directory.', negatable: false)
      ..addOption('name', help: 'Display name.')
      ..addOption('note', help: 'Note.');
  }

  @override
  Future<void> run() async {
    final path = requiredArg(0, 'path');
    final isDir = argResults!.flag('dir');
    final itemName = argResults!.option('name');
    final note = argResults!.option('note');

    try {
      final item = await _service.addItem(
        path: path,
        isDirectory: isDir,
        name: itemName,
        note: note,
      );
      printResult({
        'id': item.id,
        'path': item.path,
        'isDirectory': item.isDirectory,
        'name': item.name,
        'note': item.note,
      });
    } on DuplicatePathException catch (e) {
      throw StateError(e.toString());
    }
  }

  @override
  void printHuman(Object data) {
    final item = data as Map<String, dynamic>;
    print('Added: ${item['path']} (id: ${item['id']})');
  }
}

class _RemoveCommand extends CliCommand {
  final WhitelistService _service;

  @override
  final String name = 'remove';

  @override
  final String description = 'Remove a whitelist item by ID.';

  _RemoveCommand(this._service);

  @override
  Future<void> run() async {
    final id = requiredIntArg(0, 'id');
    await _service.deleteItem(id);
    printResult({'removed': id});
  }

  @override
  void printHuman(Object data) {
    final d = data as Map<String, dynamic>;
    print('Removed whitelist item ${d['removed']}');
  }
}

class _SearchCommand extends CliCommand {
  final WhitelistService _service;

  @override
  final String name = 'search';

  @override
  final String description = 'Search whitelist items.';

  _SearchCommand(this._service);

  @override
  Future<void> run() async {
    final query = requiredArg(0, 'query');
    final items = await _service.searchItems(query);
    printResult(_itemsToData(items));
  }

  @override
  void printHuman(Object data) {
    // Reuse the same format as list.
    _ListCommand(_service).printHuman(data);
  }
}

List<Map<String, dynamic>> _itemsToData(List<WhitelistItem> items) {
  return items
      .map(
        (item) => {
          'id': item.id,
          'path': item.path,
          'isDirectory': item.isDirectory,
          'name': item.name,
          'note': item.note,
          'createdAt': item.createdAt.toIso8601String(),
          'updatedAt': item.updatedAt.toIso8601String(),
        },
      )
      .toList();
}
