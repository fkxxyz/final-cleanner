import '../models/scan_result.dart';
import '../platform/recycle_bin.dart';

class DeletionResult {
  final int successCount;
  final int failCount;
  final int freedBytes;
  final List<String> failedPaths;

  const DeletionResult({
    required this.successCount,
    required this.failCount,
    required this.freedBytes,
    this.failedPaths = const [],
  });
}

class DeletionService {
  final RecycleBin _recycleBin;

  DeletionService(this._recycleBin);

  Future<DeletionResult> deleteItems(List<ScanResult> items) async {
    if (items.isEmpty) {
      return const DeletionResult(successCount: 0, failCount: 0, freedBytes: 0);
    }

    final paths = items.map((item) => item.path).toList();
    final failedPaths = await _recycleBin.moveMultipleToTrash(paths);

    final failedSet = failedPaths.toSet();
    int freedBytes = 0;

    for (final item in items) {
      if (!failedSet.contains(item.path)) {
        freedBytes += item.sizeBytes;
      }
    }

    return DeletionResult(
      successCount: items.length - failedPaths.length,
      failCount: failedPaths.length,
      freedBytes: freedBytes,
      failedPaths: failedPaths,
    );
  }
}
