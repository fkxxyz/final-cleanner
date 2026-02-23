import 'dart:async';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:args/command_runner.dart';

import 'package:final_cleaner/cli/commands/scan_command.dart';
import 'package:final_cleaner/services/scan_service.dart';
import 'package:final_cleaner/models/scan_result.dart';
import 'package:final_cleaner/models/scan_status.dart';
import 'package:final_cleaner/models/scan_state.dart';

import '../../mocks.dart';
import '../../test_helpers.dart';

void main() {
  late MockScanService mockScanService;
  late StreamController<ScanStatus> statusController;
  late CommandRunner runner;
  late List<String> stdOut;

  setUp(() {
    mockScanService = MockScanService();
    statusController = StreamController<ScanStatus>.broadcast();
    stdOut = [];
    runner = CommandRunner('tester', 'desc')
      ..addCommand(
        ScanCommand(scanService: mockScanService, stdout: stdOut.add),
      );
    when(
      () => mockScanService.statusStream,
    ).thenAnswer((_) => statusController.stream);
    when(() => mockScanService.startScan()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await statusController.close();
  });

  test('scan with results', () async {
    final results = [
      ScanResult(path: '/foo/bar.txt', size: 123456),
      ScanResult(path: '/baz/qux.mp3', size: 7890000),
    ];
    unawaited(runner.run(['scan']));
    await Future.delayed(Duration(milliseconds: 5));
    statusController.add(
      ScanStatus(state: ScanState.complete, results: results),
    );
    await Future.delayed(Duration(milliseconds: 20));
    final output = stdOut.join("\n");
    expect(output, contains('/foo/bar.txt'));
    expect(output, contains('121 KB'));
    expect(output, contains('/baz/qux.mp3'));
    expect(output, contains('7.5 MB'));
    expect(output, contains('共 2 个文件，7.52 MB'));
  });

  test('scan with no results', () async {
    unawaited(runner.run(['scan']));
    await Future.delayed(Duration(milliseconds: 5));
    statusController.add(ScanStatus(state: ScanState.complete, results: []));
    await Future.delayed(Duration(milliseconds: 20));
    final output = stdOut.join("\n");
    expect(output, contains('未发现未白名单文件'));
    expect(output, contains('共 0 个文件'));
  });

  test('scan JSON output', () async {
    final results = [
      ScanResult(path: '/a.txt', size: 100),
      ScanResult(path: '/b.txt', size: 200),
    ];
    unawaited(runner.run(['scan', '--json']));
    await Future.delayed(Duration(milliseconds: 5));
    statusController.add(
      ScanStatus(state: ScanState.complete, results: results),
    );
    await Future.delayed(Duration(milliseconds: 20));
    final output = stdOut.join();
    final jsonOut = json.decode(output) as List;
    expect(jsonOut, isA<List>());
    expect(jsonOut.length, 2);
    expect(jsonOut.first['path'], '/a.txt');
    expect(jsonOut.last['size'], 200);
  });

  test('scan output formatting', () async {
    final results = [
      ScanResult(path: '/test/中文名字.flac', size: 3653532345),
      ScanResult(path: '/test/space file.txt', size: 31566),
    ];
    unawaited(runner.run(['scan']));
    await Future.delayed(Duration(milliseconds: 5));
    statusController.add(
      ScanStatus(state: ScanState.complete, results: results),
    );
    await Future.delayed(Duration(milliseconds: 25));
    final output = stdOut.join("\n");
    // Table header
    expect(output, contains('路径'));
    expect(output, contains('大小'));
    expect(output, contains('/test/中文名字.flac'));
    expect(output, contains('3.4 GB'));
    expect(output, contains('/test/space file.txt'));
    expect(output, contains('30.8 KB'));
    // Chinese summary
    expect(output, contains('共 2 个文件，3.40 GB'));
  });
}
