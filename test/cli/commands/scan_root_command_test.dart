import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:final_cleanner/cli/commands/scan_root_command.dart';
import 'package:final_cleanner/models/scan_root.dart';
import 'package:final_cleanner/services/scan_root_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import '../test_helpers.dart';

void main() {
  late ScanRootService mockService;
  late CommandRunner<void> runner;

  setUp(() {
    mockService = MockScanRootService();
    runner = CommandRunner<void>('runner', 'test runner')
      ..addCommand(ScanRootCommand(mockService));
    resetStdout();
  });

  group('scan-root list', () {
    test('prints empty when no roots', () async {
      when(() => mockService.getAll()).thenAnswer((_) async => []);
      await runner.run(['scan-root', 'list']);
      expect(getStdout(), contains('No scan roots configured'));
      verify(() => mockService.getAll()).called(1);
    });
    test('prints all roots, enabled and disabled', () async {
      final roots = [
        ScanRoot(id: 1, path: '/data', enabled: true),
        ScanRoot(id: 2, path: '/foo', enabled: false),
      ];
      when(() => mockService.getAll()).thenAnswer((_) async => roots);
      await runner.run(['scan-root', 'list']);
      final out = getStdout();
      expect(out, contains('/data'));
      expect(out, contains('enabled'));
      expect(out, contains('/foo'));
      expect(out, contains('disabled'));
      verify(() => mockService.getAll()).called(1);
    });
    test('prints as JSON with --json', () async {
      final roots = [ScanRoot(id: 1, path: '/data', enabled: true)];
      when(() => mockService.getAll()).thenAnswer((_) async => roots);
      await runner.run(['scan-root', 'list', '--json']);
      final out = getStdout();
      final jsonObj = json.decode(out);
      expect(jsonObj[0]['id'], 1);
      expect(jsonObj[0]['path'], '/data');
      expect(jsonObj[0]['enabled'], true);
    });
  });

  group('scan-root add', () {
    test('adds a scan root', () async {
      when(
        () => mockService.add('/test', enabled: true),
      ).thenAnswer((_) async => ScanRoot(id: 1, path: '/test', enabled: true));
      await runner.run(['scan-root', 'add', '/test']);
      expect(getStdout(), contains('/test'));
      verify(() => mockService.add('/test', enabled: true)).called(1);
    });
    test('fails with missing path', () async {
      await expectLater(
        () => runner.run(['scan-root', 'add']),
        throwsA(isA<UsageException>()),
      );
    });
    test('adds root and prints JSON with --json', () async {
      when(
        () => mockService.add('/j', enabled: true),
      ).thenAnswer((_) async => ScanRoot(id: 9, path: '/j', enabled: true));
      await runner.run(['scan-root', 'add', '/j', '--json']);
      final out = getStdout();
      final jsonObj = json.decode(out);
      expect(jsonObj['id'], 9);
      expect(jsonObj['path'], '/j');
      expect(jsonObj['enabled'], true);
    });
  });

  group('scan-root remove', () {
    test('removes an existing scan root', () async {
      when(() => mockService.remove(42)).thenAnswer((_) async => true);
      await runner.run(['scan-root', 'remove', '42']);
      expect(getStdout(), contains('removed'));
      verify(() => mockService.remove(42)).called(1);
    });
    test('fails with missing id', () async {
      await expectLater(
        () => runner.run(['scan-root', 'remove']),
        throwsA(isA<UsageException>()),
      );
    });
    test('fails with invalid id', () async {
      await expectLater(
        () => runner.run(['scan-root', 'remove', 'foo']),
        throwsA(isA<UsageException>()),
      );
    });
    test('removes root and outputs JSON', () async {
      when(() => mockService.remove(77)).thenAnswer((_) async => true);
      await runner.run(['scan-root', 'remove', '77', '--json']);
      final out = getStdout();
      final jsonObj = json.decode(out);
      expect(jsonObj['removed'], 77);
    });
  });

  group('scan-root toggle', () {
    test('toggles enable', () async {
      when(
        () => mockService.toggle(1, enabled: true),
      ).thenAnswer((_) async => true);
      await runner.run(['scan-root', 'toggle', '1', '--enable']);
      expect(getStdout(), contains('enabled'));
      verify(() => mockService.toggle(1, enabled: true)).called(1);
    });
    test('toggles disable', () async {
      when(
        () => mockService.toggle(2, enabled: false),
      ).thenAnswer((_) async => true);
      await runner.run(['scan-root', 'toggle', '2', '--disable']);
      expect(getStdout(), contains('disabled'));
      verify(() => mockService.toggle(2, enabled: false)).called(1);
    });
    test('fails if both --enable and --disable', () async {
      await expectLater(
        () => runner.run(['scan-root', 'toggle', '1', '--enable', '--disable']),
        throwsA(isA<UsageException>()),
      );
    });
    test('fails if neither --enable nor --disable', () async {
      await expectLater(
        () => runner.run(['scan-root', 'toggle', '1']),
        throwsA(isA<UsageException>()),
      );
    });
    test('fails with missing id', () async {
      await expectLater(
        () => runner.run(['scan-root', 'toggle']),
        throwsA(isA<UsageException>()),
      );
    });
    test('fails with invalid id', () async {
      await expectLater(
        () => runner.run(['scan-root', 'toggle', 'foo', '--enable']),
        throwsA(isA<UsageException>()),
      );
    });
    test('toggles and outputs JSON', () async {
      when(
        () => mockService.toggle(5, enabled: false),
      ).thenAnswer((_) async => true);
      await runner.run(['scan-root', 'toggle', '5', '--disable', '--json']);
      final out = getStdout();
      final jsonObj = json.decode(out);
      expect(jsonObj['toggled'], 5);
      expect(jsonObj['enabled'], false);
    });
  });
}
