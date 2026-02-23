import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:args/args.dart';
import 'dart:async';
import 'dart:io';

import 'package:your_package/commands/clean_command.dart';
import 'package:your_package/services/scan_service.dart';
import 'package:your_package/services/deletion_service.dart';
import 'package:your_package/mocks/mocks.dart';
import 'package:your_package/test_helpers/test_helpers.dart';

import 'package:your_package/models/scan_status.dart';
import 'package:your_package/models/scan_state.dart';
import 'package:your_package/models/scan_result.dart';
import 'package:your_package/models/deletion_result.dart';

void main() {
  late MockScanService mockScanService;
  late MockDeletionService mockDeletionService;
  late CommandRunner runner;
  late MockStdin mockStdin;

  setUp(() {
    mockScanService = MockScanService();
    mockDeletionService = MockDeletionService();
    mockStdin = MockStdin();

    // Register fallback values for mocktail
    registerFallbackValue(Stream<List<int>>.empty());

    // Instantiate command with dependencies
    final cleanCommand = CleanCommand(
      scanService: mockScanService,
      deletionService: mockDeletionService,
    );

    runner = CommandRunner('test', 'test')..addCommand(cleanCommand);
  });

  test('clean with --yes flag', () async {
    // Arrange: scan returns some results
    when(
      () => mockScanService.statusStream,
    ).thenAnswer((_) => Stream<ScanStatus>.value(ScanStatus.completed));
    when(
      () => mockScanService.results,
    ).thenReturn([ScanResult(path: 'file1', size: 100)]);
    when(
      () => mockDeletionService.deleteItems(any()),
    ).thenAnswer((_) async => DeletionResult(deletedCount: 1, freedMB: 0.1));

    // Act: run with --yes
    await IOOverrides.runZoned(
      () => runner.run(['clean', '--yes']),
      stdin: () => mockStdin,
    );

    // Assert: verify output contains delete info
    // (capture print or check logs if implemented)
    verify(() => mockDeletionService.deleteItems(any())).called(1);
  });

  test('clean with confirmation yes', () async {
    // Arrange: scan returns some results
    when(
      () => mockScanService.statusStream,
    ).thenAnswer((_) => Stream<ScanStatus>.value(ScanStatus.completed));
    when(
      () => mockScanService.results,
    ).thenReturn([ScanResult(path: 'file2', size: 200)]);
    when(
      () => mockDeletionService.deleteItems(any()),
    ).thenAnswer((_) async => DeletionResult(deletedCount: 1, freedMB: 0.2));

    // Mock stdin to yield 'y\n'
    final inputStream = Stream<List<int>>.fromIterable([utf8.encode('y\n')]);

    await IOOverrides.runZoned(
      () => runner.run(['clean']),
      stdin: () => inputStream,
    );

    verify(() => mockDeletionService.deleteItems(any())).called(1);
  });

  test('clean with confirmation no', () async {
    final inputStream = Stream<List<int>>.fromIterable([utf8.encode('n\n')]);

    // Run command and verify no deletion
    await IOOverrides.runZoned(
      () => runner.run(['clean']),
      stdin: () => inputStream,
    );
    verifyNever(() => mockDeletionService.deleteItems(any()));
  });

  test('clean with no results', () async {
    // Arrange: scan results empty
    when(
      () => mockScanService.statusStream,
    ).thenAnswer((_) => Stream<ScanStatus>.value(ScanStatus.completed));
    when(() => mockScanService.results).thenReturn([]);

    await IOOverrides.runZoned(
      () => runner.run(['clean', '--yes']),
      stdin: () => mockStdin,
    );
    verifyNever(() => mockDeletionService.deleteItems(any()));
  });

  test('clean JSON output', () async {
    when(
      () => mockScanService.statusStream,
    ).thenAnswer((_) => Stream<ScanStatus>.value(ScanStatus.completed));
    when(
      () => mockScanService.results,
    ).thenReturn([ScanResult(path: 'file3', size: 300)]);
    when(
      () => mockDeletionService.deleteItems(any()),
    ).thenAnswer((_) async => DeletionResult(deletedCount: 1, freedMB: 0.3));

    await IOOverrides.runZoned(
      () => runner.run(['clean', '--json', '--yes']),
      stdin: () => mockStdin,
    );
    // Verify output JSON if captured
  });

  test('clean with deletion failures', () async {
    when(
      () => mockScanService.statusStream,
    ).thenAnswer((_) => Stream<ScanStatus>.value(ScanStatus.completed));
    when(
      () => mockScanService.results,
    ).thenReturn([ScanResult(path: 'file4', size: 400)]);
    when(() => mockDeletionService.deleteItems(any())).thenAnswer(
      (_) async =>
          DeletionResult(deletedCount: 0, failedPaths: ['file4'], freedMB: 0),
    );

    await IOOverrides.runZoned(
      () => runner.run(['clean', '--yes']),
      stdin: () => mockStdin,
    );
    // Verify output contains failure info
  });
}
