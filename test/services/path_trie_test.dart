import 'package:flutter_test/flutter_test.dart';
import 'package:final_cleanner/services/path_trie.dart';

void main() {
  late PathTrie trie;

  setUp(() {
    trie = PathTrie();
  });

  group('normalizePath', () {
    test('trims whitespace', () {
      expect(PathTrie.normalizePath('  /home  '), '/home');
    });

    test('replaces backslashes', () {
      expect(PathTrie.normalizePath('C:\\Users\\test'), 'C:/Users/test');
    });

    test('collapses multiple slashes', () {
      expect(PathTrie.normalizePath('/home//user///file'), '/home/user/file');
    });

    test('removes trailing slash', () {
      expect(PathTrie.normalizePath('/home/user/'), '/home/user');
    });

    test('preserves root slash', () {
      expect(PathTrie.normalizePath('/'), '/');
    });

    test('empty string becomes root', () {
      expect(PathTrie.normalizePath(''), '/');
    });

    test('whitespace only becomes root', () {
      expect(PathTrie.normalizePath('   '), '/');
    });
  });

  group('insert and contains', () {
    test('basic insert and contains', () {
      trie.insert('/home/user');
      expect(trie.contains('/home/user'), isTrue);
      expect(trie.contains('/home'), isFalse);
      expect(trie.contains('/home/user/file'), isFalse);
    });

    test('root path', () {
      trie.insert('/');
      expect(trie.contains('/'), isTrue);
    });

    test('multiple paths', () {
      trie.insert('/a');
      trie.insert('/b');
      trie.insert('/a/b/c');
      expect(trie.contains('/a'), isTrue);
      expect(trie.contains('/b'), isTrue);
      expect(trie.contains('/a/b/c'), isTrue);
      expect(trie.contains('/a/b'), isFalse);
    });

    test('normalizes on insert', () {
      trie.insert('/home/user/');
      expect(trie.contains('/home/user'), isTrue);
    });
  });

  group('isWhitelisted', () {
    test('exact match', () {
      trie.insert('/home/user');
      expect(trie.isWhitelisted('/home/user'), isTrue);
    });

    test('ancestor match', () {
      trie.insert('/home');
      expect(trie.isWhitelisted('/home/user/file.txt'), isTrue);
    });

    test('segment boundary - /abc does NOT match /abcdef', () {
      trie.insert('/abc');
      expect(trie.isWhitelisted('/abcdef'), isFalse);
    });

    test('root whitelisted matches everything', () {
      trie.insert('/');
      expect(trie.isWhitelisted('/anything/at/all'), isTrue);
    });

    test('no match returns false', () {
      trie.insert('/home');
      expect(trie.isWhitelisted('/var/log'), isFalse);
    });

    test('deep ancestor match', () {
      trie.insert('/a');
      expect(trie.isWhitelisted('/a/b/c/d/e/f/g/h'), isTrue);
    });

    test('partial path not whitelisted', () {
      trie.insert('/home/user/documents');
      expect(trie.isWhitelisted('/home/user'), isFalse);
      expect(trie.isWhitelisted('/home'), isFalse);
    });
  });

  group('remove', () {
    test('removes existing path', () {
      trie.insert('/home/user');
      expect(trie.contains('/home/user'), isTrue);
      trie.remove('/home/user');
      expect(trie.contains('/home/user'), isFalse);
    });

    test('remove non-existent path is safe', () {
      trie.remove('/does/not/exist');
      expect(trie.size, 0);
    });

    test('remove cleans up empty parent nodes', () {
      trie.insert('/a/b/c');
      trie.remove('/a/b/c');
      expect(trie.contains('/a/b/c'), isFalse);
      expect(trie.contains('/a/b'), isFalse);
      expect(trie.contains('/a'), isFalse);
    });

    test('remove preserves sibling paths', () {
      trie.insert('/a/b');
      trie.insert('/a/c');
      trie.remove('/a/b');
      expect(trie.contains('/a/b'), isFalse);
      expect(trie.contains('/a/c'), isTrue);
    });

    test('remove preserves parent terminal', () {
      trie.insert('/a');
      trie.insert('/a/b');
      trie.remove('/a/b');
      expect(trie.contains('/a'), isTrue);
      expect(trie.contains('/a/b'), isFalse);
    });
  });

  group('size', () {
    test('starts at 0', () {
      expect(trie.size, 0);
    });

    test('increments on insert', () {
      trie.insert('/a');
      expect(trie.size, 1);
      trie.insert('/b');
      expect(trie.size, 2);
    });

    test('duplicate insert does not increment', () {
      trie.insert('/a');
      trie.insert('/a');
      expect(trie.size, 1);
    });

    test('decrements on remove', () {
      trie.insert('/a');
      trie.insert('/b');
      trie.remove('/a');
      expect(trie.size, 1);
    });
  });

  group('clear', () {
    test('resets everything', () {
      trie.insert('/a');
      trie.insert('/b');
      trie.insert('/c/d/e');
      trie.clear();
      expect(trie.size, 0);
      expect(trie.contains('/a'), isFalse);
      expect(trie.contains('/b'), isFalse);
      expect(trie.contains('/c/d/e'), isFalse);
    });
  });
}
