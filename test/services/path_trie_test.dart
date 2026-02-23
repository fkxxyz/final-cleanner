import 'package:flutter_test/flutter_test.dart';
import 'package:final_cleanner/services/path_trie.dart';

void main() {
  group('PathTrie.hasWhitelistedDescendants', () {
    test('returns false for empty trie', () {
      final trie = PathTrie();
      expect(trie.hasWhitelistedDescendants('/home/user'), false);
    });

    test('returns true when path has direct child', () {
      final trie = PathTrie();
      trie.insert('/home/user/documents/file.txt');
      expect(trie.hasWhitelistedDescendants('/home/user'), true);
    });

    test('returns true when path has nested descendant', () {
      final trie = PathTrie();
      trie.insert('/var/log/system/error.log');
      expect(trie.hasWhitelistedDescendants('/'), true);
    });

    test('returns false when path has no descendants', () {
      final trie = PathTrie();
      trie.insert('/tmp/something');
      expect(trie.hasWhitelistedDescendants('/tmp/something'), false);
    });

    test('returns false when siblings are not descendants', () {
      final trie = PathTrie();
      trie.insert('/etc/config');
      expect(trie.hasWhitelistedDescendants('/usr/bin'), false);
    });

    test('root path / with descendants', () {
      final trie = PathTrie();
      trie.insert('/usr/local/bin');
      expect(trie.hasWhitelistedDescendants('/'), true);
    });

    test('edge case: nested path without explicit insert', () {
      final trie = PathTrie();
      trie.insert('/a/b/c');
      expect(trie.hasWhitelistedDescendants('/a'), true);
    });
  });
}
