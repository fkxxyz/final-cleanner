import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:args/command_runner.dart';
import 'package:final_cleanner/cli/commands/whitelist_command.dart';
import 'package:final_cleanner/services/whitelist_service.dart';
import 'package:final_cleanner/data/database.dart';
import '../../mocks.dart';
import '../../test_helpers.dart';

void main() {
  late MockWhitelistService mockService;
  late CommandRunner<void> runner;

  setUp(() {
    mockService = MockWhitelistService();
    runner = CommandRunner<void>('cli', '')
      ..addCommand(WhitelistCommand(mockService));
    reset(mockService);
  });

  group('whitelist list', () {
    test('returns empty when no items', () async {
      when(() => mockService.list()).thenAnswer((_) async => []);
      final output = await captureStdout(
        () => runner.run(['whitelist', 'list']),
      );
      expect(output.trim(), 'No whitelist items found.');
      verify(() => mockService.list()).called(1);
    });

    test('returns items in human readable output', () async {
      final items = [
        WhitelistItem(id: 1, path: '/foo/bar', name: 'Bar', note: 'baz'),
        WhitelistItem(id: 2, path: '/a/b', name: 'Ab', note: ''),
      ];
      when(() => mockService.list()).thenAnswer((_) async => items);
      final output = await captureStdout(
        () => runner.run(['whitelist', 'list']),
      );
      expect(output, contains('/foo/bar'));
      expect(output, contains('Bar'));
      expect(output, contains('/a/b'));
      verify(() => mockService.list()).called(1);
    });

    test('returns items as JSON with --json', () async {
      final items = [
        WhitelistItem(id: 17, path: '/x', name: 'test', note: 'a'),
      ];
      when(() => mockService.list()).thenAnswer((_) async => items);
      final output = await captureStdout(
        () => runner.run(['whitelist', 'list', '--json']),
      );
      expect(output.trim(), startsWith('['));
      expect(output, contains('"id": 17'));
      expect(output, contains('"path": "/x"'));
      verify(() => mockService.list()).called(1);
    });
  });

  group('whitelist add', () {
    test('adds path success', () async {
      when(
        () =>
            mockService.add(path: '/foo', isDir: false, name: null, note: null),
      ).thenAnswer(
        (_) async => WhitelistItem(id: 42, path: '/foo', name: '', note: ''),
      );
      final output = await captureStdout(
        () => runner.run(['whitelist', 'add', '/foo']),
      );
      expect(output, contains('Added /foo'));
      verify(
        () =>
            mockService.add(path: '/foo', isDir: false, name: null, note: null),
      ).called(1);
    });

    test('adds path with flags', () async {
      when(
        () => mockService.add(
          path: '/d',
          isDir: true,
          name: 'Dir',
          note: 'something',
        ),
      ).thenAnswer(
        (_) async =>
            WhitelistItem(id: 7, path: '/d', name: 'Dir', note: 'something'),
      );
      final output = await captureStdout(
        () => runner.run([
          'whitelist',
          'add',
          '/d',
          '--dir',
          '--name',
          'Dir',
          '--note',
          'something',
        ]),
      );
      expect(output, contains('Added /d'));
      expect(output, contains('Dir'));
      verify(
        () => mockService.add(
          path: '/d',
          isDir: true,
          name: 'Dir',
          note: 'something',
        ),
      ).called(1);
    });

    test('errors on duplicate path', () async {
      when(
        () =>
            mockService.add(path: '/dup', isDir: false, name: null, note: null),
      ).thenThrow(DuplicatePathException('/dup'));
      final output = await captureStdout(
        () => runner.run(['whitelist', 'add', '/dup']),
        expectThrows: true,
      );
      expect(output, contains('Path already whitelisted'));
      verify(
        () =>
            mockService.add(path: '/dup', isDir: false, name: null, note: null),
      ).called(1);
    });

    test('prints JSON result', () async {
      when(
        () => mockService.add(path: '/x', isDir: true, name: 'A', note: 'B'),
      ).thenAnswer(
        (_) async => WhitelistItem(id: 33, path: '/x', name: 'A', note: 'B'),
      );
      final output = await captureStdout(
        () => runner.run([
          'whitelist',
          'add',
          '/x',
          '--dir',
          '--name',
          'A',
          '--note',
          'B',
          '--json',
        ]),
      );
      expect(output.trim(), startsWith('{'));
      expect(output, contains('"id": 33'));
      verify(
        () => mockService.add(path: '/x', isDir: true, name: 'A', note: 'B'),
      ).called(1);
    });
  });

  group('whitelist remove', () {
    test('removes by id', () async {
      when(() => mockService.remove(7)).thenAnswer((_) async => true);
      final output = await captureStdout(
        () => runner.run(['whitelist', 'remove', '7']),
      );
      expect(output, contains('Removed'));
      verify(() => mockService.remove(7)).called(1);
    });

    test('errors on missing id', () async {
      final output = await captureStdout(
        () => runner.run(['whitelist', 'remove']),
        expectThrows: true,
      );
      expect(output, contains('ID argument required'));
      verifyNever(() => mockService.remove(any()));
    });

    test('errors on invalid id format', () async {
      final output = await captureStdout(
        () => runner.run(['whitelist', 'remove', 'foo']),
        expectThrows: true,
      );
      expect(output, contains('Invalid ID'));
      verifyNever(() => mockService.remove(any()));
    });

    test('prints JSON result', () async {
      when(() => mockService.remove(3)).thenAnswer((_) async => true);
      final output = await captureStdout(
        () => runner.run(['whitelist', 'remove', '3', '--json']),
      );
      expect(output.trim(), startsWith('{'));
      expect(output, contains('"success": true'));
      verify(() => mockService.remove(3)).called(1);
    });
  });

  group('whitelist search', () {
    test('returns matches', () async {
      when(() => mockService.search('b')).thenAnswer(
        (_) async => [WhitelistItem(id: 2, path: '/b', name: '', note: '')],
      );
      final output = await captureStdout(
        () => runner.run(['whitelist', 'search', 'b']),
      );
      expect(output, contains('/b'));
      verify(() => mockService.search('b')).called(1);
    });

    test('returns nothing when no matches', () async {
      when(() => mockService.search('q')).thenAnswer((_) async => []);
      final output = await captureStdout(
        () => runner.run(['whitelist', 'search', 'q']),
      );
      expect(output, contains('No whitelist items found for'));
      verify(() => mockService.search('q')).called(1);
    });

    test('errors when missing query arg', () async {
      final output = await captureStdout(
        () => runner.run(['whitelist', 'search']),
        expectThrows: true,
      );
      expect(output, contains('Query argument required'));
      verifyNever(() => mockService.search(any()));
    });

    test('prints results as JSON', () async {
      when(() => mockService.search('jsonify')).thenAnswer(
        (_) async => [WhitelistItem(id: 8, path: '/json', name: '', note: '')],
      );
      final output = await captureStdout(
        () => runner.run(['whitelist', 'search', 'jsonify', '--json']),
      );
      expect(output.trim(), startsWith('['));
      expect(output, contains('"id": 8'));
      verify(() => mockService.search('jsonify')).called(1);
    });
  });
}
