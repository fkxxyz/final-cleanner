import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../data/database.dart';
import '../data/repositories/group_repository.dart';
import '../data/repositories/scan_root_repository.dart';
import '../data/repositories/whitelist_repository.dart';
import '../platform/recycle_bin_factory.dart';
import '../services/deletion_service.dart';
import '../services/export_import_service.dart';
import '../services/group_service.dart';
import '../services/path_matcher_service.dart';
import '../services/scan_root_service.dart';
import '../services/scan_service.dart';
import '../services/whitelist_service.dart';
import 'commands/clean_command.dart';
import 'commands/export_command.dart';
import 'commands/group_command.dart';
import 'commands/import_command.dart';
import 'commands/scan_command.dart';
import 'commands/scan_root_command.dart';
import 'commands/whitelist_command.dart';
import 'db_path.dart';

/// Assembles and runs the CLI application.
class CliApp {
  /// Parses [args], builds the service graph, and runs the matched command.
  ///
  /// Returns the process exit code.
  Future<int> run(List<String> args) async {
    final runner = CommandRunner<void>(
      'final-cleanner',
      'A whitelist-driven file management tool.',
    );
    runner.argParser
      ..addOption('db', help: 'Path to the database file.')
      ..addFlag('json', help: 'Output results as JSON.', negatable: false);

    // Parse global options early to resolve DB path before building services.
    final ArgResults topResults;
    try {
      topResults = runner.argParser.parse(args);
    } on FormatException catch (e) {
      stderr.writeln(e.message);
      stderr.writeln();
      stderr.writeln(runner.usage);
      return 64;
    }

    final dbPath = topResults.option('db') ?? defaultDbPath();
    final db = AppDatabase.withPath(dbPath);

    try {
      // Repositories
      final whitelistRepo = WhitelistRepository(db);
      final groupRepo = GroupRepository(db);
      final scanRootRepo = ScanRootRepository(db);

      // Services
      final whitelistService = WhitelistService(whitelistRepo);
      final groupService = GroupService(groupRepo);
      final scanRootService = ScanRootService(scanRootRepo);
      final pathMatcherService = PathMatcherService(whitelistService);
      final scanService = ScanService(
        scanRootService,
        pathMatcherService,
      );
      final recycleBin = RecycleBinFactory.create();
      final deletionService = DeletionService(recycleBin);
      final exportImportService = ExportImportService(
        whitelistService,
        groupService,
        scanRootService,
      );

      // Register commands
      runner
        ..addCommand(WhitelistCommand(whitelistService))
        ..addCommand(GroupCommand(groupService))
        ..addCommand(ScanRootCommand(scanRootService))
        ..addCommand(ScanCommand(scanService))
        ..addCommand(CleanCommand(scanService, deletionService))
        ..addCommand(ExportCommand(exportImportService))
        ..addCommand(ImportCommand(exportImportService));

      await runner.run(args);
      return 0;
    } on UsageException catch (e) {
      stderr.writeln(e.message);
      stderr.writeln();
      stderr.writeln(e.usage);
      return 64;
    } on ArgumentError catch (e) {
      stderr.writeln('Error: $e');
      return 1;
    } on StateError catch (e) {
      stderr.writeln('Error: $e');
      return 1;
    } catch (e, st) {
      stderr.writeln('Unexpected error: $e');
      stderr.writeln(st);
      return 1;
    } finally {
      await db.close();
    }
  }
}
