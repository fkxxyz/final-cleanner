import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:args/args.dart';
import 'dart:io';

import 'package:final_cleaner/commands/export_command.dart';
import 'package:final_cleaner/commands/import_command.dart';
import 'package:final_cleaner/services/export_import_service.dart';
import 'package:final_cleaner/test_helpers.dart';

// Mocks
class MockExportImportService extends Mock implements ExportImportService {}

void main() {
  late MockExportImportService mockService;
  late CommandRunner<void> runner;

  setUp(() {
    mockService = MockExportImportService();
    // Setup commands
    final exportCommand = ExportCommand(service: mockService);
    final importCommand = ImportCommand(service: mockService);
    runner = CommandRunner<void>('test', 'tests')
      ..addCommand(exportCommand)
      ..addCommand(importCommand);
  });

  group('ExportCommand', () {
    test('export success', () async {
      when(() => mockService.export(any())).thenAnswer((_) async => true);
      final result = await runner.run(['export', '/tmp/test.json']);
      verify(() => mockService.export(argThat(isA<String>()))).called(1);
    });

    test('export missing file arg', () async {
      try {
        await runner.run(['export']);
        fail('Should throw UsageException');
      } on UsageException catch (_) {}
    });

    test('export JSON output', () async {
      when(() => mockService.export(any())).thenAnswer((_) async => true);
      final result = await runner.run(['export', '/tmp/test.json', '--json']);
      verify(() => mockService.export(argThat(isA<String>()))).called(1);
    });
  });

  group('ImportCommand', () {
    test('import success', () async {
      final testFile = '/tmp/import.json';
      final mockFile = FakeFile(testFile);
      when(() => mockFile.existsSync()).thenReturn(true);
      when(() => mockService.import(any())).thenAnswer((_) async => true);
      final result = await runner.run(['import', testFile]);
      verify(() => mockService.import(argThat(isA<String>()))).called(1);
    });

    test('import file not found', () async {
      final testFile = '/tmp/missing.json';
      final mockFile = FakeFile(testFile);
      when(() => mockFile.existsSync()).thenReturn(false);
      try {
        await runner.run(['import', testFile]);
        fail('Should throw StateError');
      } on StateError catch (_) {}
    });

    test('import missing file arg', () async {
      try {
        await runner.run(['import']);
        fail('Should throw UsageException');
      } on UsageException catch (_) {}
    });

    test('import JSON output', () async {
      when(() => mockService.import(any())).thenAnswer((_) async => true);
      final result = await runner.run(['import', '/tmp/test.json', '--json']);
      verify(() => mockService.import(argThat(isA<String>()))).called(1);
    });
  });
}

// Fake File class to mock existsSync()
class FakeFile {
  final String path;
  FakeFile(this.path);
  bool existsSync() => false; // Override in tests
}
