import 'dart:io';

import '../models/directory_node.dart';
import '../models/file_node.dart';
import '../models/folder_node.dart';
import 'path_matcher_service.dart';
import 'scan_root_service.dart';
// import 'whitelist_service.dart'; // Not needed for on-demand scanning

class ScanService {
  final ScanRootService _scanRootService;
  // WhitelistService removed - not needed for on-demand scanning
  final PathMatcherService _pathMatcherService;

  ScanService(
    this._scanRootService,
    // this._whitelistService,
    this._pathMatcherService,
  );

  /// Scans a single directory and returns its contents as a DirectoryNode.
  /// Only includes non-whitelisted items.
  Future<DirectoryNode> scanDirectory(String path) async {
    final dir = Directory(path);
    final files = <FileNode>[];
    final folders = <FolderNode>[];

    try {
      final entities = dir.listSync();

      for (final entity in entities) {
        final entityPath = entity.path;

        // Skip whitelisted items
        if (_pathMatcherService.isWhitelisted(entityPath)) {
          continue;
        }

        if (entity is File) {
          final stat = entity.statSync();
          files.add(
            FileNode(
              path: entityPath,
              name: _getFileName(entityPath),
              sizeBytes: stat.size,
              modifiedAt: stat.modified,
            ),
          );
        } else if (entity is Directory) {
          final stat = entity.statSync();

          final autoExpand =
              _pathMatcherService.hasWhitelistedDescendants(entityPath);
          folders.add(
            FolderNode(
              path: entityPath,
              name: _getFileName(entityPath),
              // sizeBytes not calculated for on-demand scanning
              autoExpand: autoExpand,
              modifiedAt: stat.modified,
            ),
          );
        }
      }
    } catch (e) {
      // Handle permission errors or other IO exceptions
      // Return empty lists for this directory
    }

    return DirectoryNode(path: path, files: files, folders: folders);
  }

  /// Scans all enabled scan roots and returns a list of DirectoryNodes.
  Future<List<DirectoryNode>> scanRoots() async {
    await _pathMatcherService.rebuildTrie();

    final scanRoots = await _scanRootService.getEnabledScanRoots();
    final results = <DirectoryNode>[];

    for (final root in scanRoots) {
      final node = await scanDirectory(root.path);
      results.add(node);
    }

    return results;
  }

  String _getFileName(String path) {
    final normalized = path.replaceAll('\\', '/');
    final segments = normalized.split('/');
    return segments.last.isEmpty && segments.length > 1
        ? segments[segments.length - 2]
        : segments.last;
  }
}
