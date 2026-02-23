import '../data/database.dart';
import '../data/repositories/whitelist_repository.dart';
import 'path_trie.dart';

class DuplicatePathException implements Exception {
  final String path;
  DuplicatePathException(this.path);

  @override
  String toString() => 'Path already exists in whitelist: $path';
}

class WhitelistService {
  final WhitelistRepository _repo;

  WhitelistService(this._repo);

  Future<WhitelistItem> addItem({
    required String path,
    required bool isDirectory,
    String? name,
    String? note,
    int? groupId,
  }) async {
    final normalized = PathTrie.normalizePath(path);
    if (normalized.isEmpty || normalized == '/') {
      throw ArgumentError('Invalid path: $path');
    }

    final existing = await _repo.getItemByPath(normalized);
    if (existing != null) {
      throw DuplicatePathException(normalized);
    }

    return _repo.addItem(
      path: normalized,
      isDirectory: isDirectory,
      name: name,
      note: note,
      groupId: groupId,
    );
  }

  Future<WhitelistItem> updateItem(int id, {String? name, String? note, int? groupId}) {
    return _repo.updateItem(id, name: name, note: note, groupId: groupId);
  }

  Future<void> deleteItem(int id) => _repo.deleteItem(id);

  Future<void> deleteItems(List<int> ids) => _repo.deleteItems(ids);

  Future<WhitelistItem?> getItemById(int id) => _repo.getItemById(id);

  Future<List<WhitelistItem>> getAllItems() => _repo.getAllItems();

  Future<List<WhitelistItem>> searchItems(String query) =>
      _repo.searchItems(query);

  Stream<List<WhitelistItem>> watchAllItems() => _repo.watchAllItems();

  Future<PathTrie> buildTrie() async {
    final items = await _repo.getAllItems();
    final trie = PathTrie();
    for (final item in items) {
      trie.insert(item.path, isDirectory: item.isDirectory);
    }
    return trie;
  }
}
