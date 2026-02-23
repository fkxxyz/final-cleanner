import 'package:drift/drift.dart';
import '../database.dart';

class WhitelistRepository {
  final AppDatabase _db;

  WhitelistRepository(this._db);

  Future<WhitelistItem> addItem({
    required String path,
    required bool isDirectory,
    String? name,
    String? note,
    int? groupId,
  }) async {
    final id = await _db
        .into(_db.whitelistItems)
        .insert(
          WhitelistItemsCompanion.insert(
            path: path,
            isDirectory: Value(isDirectory),
            name: Value(name),
            note: Value(note),
            groupId: Value(groupId),
          ),
        );
    return (await getItemById(id))!;
  }

  Future<WhitelistItem> updateItem(int id, {String? name, String? note, int? groupId}) async {
    await (_db.update(_db.whitelistItems)..where((t) => t.id.equals(id))).write(
      WhitelistItemsCompanion(
        name: Value(name),
        note: Value(note),
        groupId: Value(groupId),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return (await getItemById(id))!;
  }

  Future<void> deleteItem(int id) async {
    await (_db.delete(_db.whitelistItems)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteItems(List<int> ids) async {
    await (_db.delete(_db.whitelistItems)..where((t) => t.id.isIn(ids))).go();
  }

  Future<WhitelistItem?> getItemById(int id) async {
    return await (_db.select(
      _db.whitelistItems,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<WhitelistItem?> getItemByPath(String path) async {
    return await (_db.select(
      _db.whitelistItems,
    )..where((t) => t.path.equals(path))).getSingleOrNull();
  }

  Future<List<WhitelistItem>> getAllItems() async {
    return await _db.select(_db.whitelistItems).get();
  }

  Future<List<WhitelistItem>> searchItems(String query) async {
    return await (_db.select(_db.whitelistItems)..where(
          (t) =>
              t.path.like('%$query%') |
              t.name.like('%$query%') |
              t.note.like('%$query%'),
        ))
        .get();
  }

  Stream<List<WhitelistItem>> watchAllItems() {
    return _db.select(_db.whitelistItems).watch();
  }

  Stream<List<WhitelistItem>> watchUngroupedItems() {
    return (_db.select(_db.whitelistItems)..where((t) => t.groupId.isNull())).watch();
  }

  Future<List<WhitelistItem>> getAllItemsForTrie() async {
    return await (_db.select(
      _db.whitelistItems,
    )..orderBy([(t) => OrderingTerm.asc(t.path)])).get();
  }
}
