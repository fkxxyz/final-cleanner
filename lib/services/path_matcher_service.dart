import 'path_trie.dart';
import 'whitelist_service.dart';

class PathMatcherService {
  PathTrie _trie = PathTrie();
  final WhitelistService _whitelistService;

  PathMatcherService(this._whitelistService);

  Future<void> rebuildTrie() async {
    _trie = await _whitelistService.buildTrie();
  }

  bool isWhitelisted(String path) => _trie.isWhitelisted(path);

  bool contains(String path) => _trie.contains(path);

  int get whitelistSize => _trie.size;
}
