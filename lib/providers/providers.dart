import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/repositories/group_repository.dart';
import '../data/repositories/scan_root_repository.dart';
import '../data/repositories/whitelist_repository.dart';
import '../platform/recycle_bin.dart';
import '../platform/recycle_bin_factory.dart';
import '../services/deletion_service.dart';
import '../services/export_import_service.dart';
import '../services/group_service.dart';
import '../services/path_matcher_service.dart';
import '../services/scan_root_service.dart';
import '../services/whitelist_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final whitelistRepositoryProvider = Provider<WhitelistRepository>((ref) {
  return WhitelistRepository(ref.watch(databaseProvider));
});

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  return GroupRepository(ref.watch(databaseProvider));
});

final scanRootRepositoryProvider = Provider<ScanRootRepository>((ref) {
  return ScanRootRepository(ref.watch(databaseProvider));
});

final whitelistServiceProvider = Provider<WhitelistService>((ref) {
  return WhitelistService(ref.watch(whitelistRepositoryProvider));
});

final groupServiceProvider = Provider<GroupService>((ref) {
  return GroupService(ref.watch(groupRepositoryProvider));
});

final scanRootServiceProvider = Provider<ScanRootService>((ref) {
  return ScanRootService(ref.watch(scanRootRepositoryProvider));
});

final pathMatcherServiceProvider = Provider<PathMatcherService>((ref) {
  return PathMatcherService(ref.watch(whitelistServiceProvider));
});

final recycleBinProvider = Provider<RecycleBin>((ref) {
  return RecycleBinFactory.create();
});

final deletionServiceProvider = Provider<DeletionService>((ref) {
  return DeletionService(ref.watch(recycleBinProvider));
});

final exportImportServiceProvider = Provider<ExportImportService>((ref) {
  return ExportImportService(
    ref.watch(whitelistServiceProvider),
    ref.watch(groupServiceProvider),
    ref.watch(scanRootServiceProvider),
  );
});

final whitelistItemsProvider = StreamProvider<List<WhitelistItem>>((ref) {
  return ref.watch(whitelistServiceProvider).watchAllItems();
});

final scanRootsProvider = StreamProvider<List<ScanRoot>>((ref) {
  return ref.watch(scanRootServiceProvider).watchAllScanRoots();
});
