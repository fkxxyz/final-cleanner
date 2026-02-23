import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/directory_node.dart';
import '../../models/folder_node.dart';
import '../../providers/providers.dart';
import '../widgets/tree_node_widget.dart';
import '../widgets/add_to_whitelist_dialog.dart';
import '../../l10n/app_localizations.dart';
import '../../services/permission_service.dart';

class RefreshIntent extends Intent {
  const RefreshIntent();
}

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  List<DirectoryNode>? _rootNodes;
  final Map<String, bool> _selectedPaths = {};
  final Map<String, DirectoryNode> _expandedDirectories = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRoots();
  }

  Future<void> _loadRoots() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final scanService = ref.read(scanServiceProvider);
      final roots = await scanService.scanRoots();

      setState(() {
        _rootNodes = roots;
        _isLoading = false;
        // Pre-populate expanded directories with roots (so they start expanded)
        for (final root in roots) {
          _expandedDirectories[root.path] = root;
        }
      });

      // Auto-expand folders with autoExpand flag
      await _autoExpandRecursively(roots);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to scan: $e')));
      }
    }
  }

  Future<void> _autoExpandRecursively(List<DirectoryNode> nodes) async {
    for (final node in nodes) {
      for (final folder in node.folders) {
        if (folder.autoExpand) {
          await _expandDirectory(folder.path);

          // Recursively expand children
          final childNode = _expandedDirectories[folder.path];
          if (childNode != null) {
            await _autoExpandRecursively([childNode]);
          }
        }
      }
    }
  }

  Future<void> _expandDirectory(String path) async {
    if (_expandedDirectories.containsKey(path)) {
      return; // Already expanded
    }

    try {
      final scanService = ref.read(scanServiceProvider);
      final node = await scanService.scanDirectory(path);

      setState(() {
        _expandedDirectories[path] = node;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to expand directory: $e')),
        );
      }
    }
  }

  void _handleSelection(String path, bool selected) {
    setState(() {
      _selectedPaths[path] = selected;
      // Hierarchical selection: when selecting a folder, select all its children
      final childPaths = _collectPathsUnder(path);
      for (final childPath in childPaths) {
        _selectedPaths[childPath] = selected;
      }
    });
  }

  List<String> _collectPathsUnder(String path) {
    final paths = <String>[];
    final node = _expandedDirectories[path];
    if (node != null) {
      for (final file in node.files) {
        paths.add(file.path);
      }
      for (final folder in node.folders) {
        paths.add(folder.path);
        paths.addAll(_collectPathsUnder(folder.path));
      }
    }
    return paths;
  }

  Future<void> _handleAddToWhitelist(String path) async {
    final data = await AddToWhitelistDialog.show(context, path);
    if (data == null) return;

    try {
      final isDirectory = await FileSystemEntity.isDirectory(path);
      await ref
          .read(whitelistServiceProvider)
          .addItem(
            path: data.path,
            isDirectory: isDirectory,
            name: data.name,
            note: data.description,
            groupId: data.groupId,
          );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Added to whitelist')));

        // Reload to reflect changes
        _loadRoots();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to whitelist: $e')),
        );
      }
    }
  }

  Future<void> _handleDelete() async {
    final selectedPaths = _selectedPaths.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (selectedPaths.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Delete ${selectedPaths.length} item(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final recycleBin = ref.read(recycleBinProvider);
      final failedPaths = await recycleBin.moveMultipleToTrash(selectedPaths);
      final successCount = selectedPaths.length - failedPaths.length;
      final failedCount = failedPaths.length;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Deleted $successCount item(s)${failedCount > 0 ? ', $failedCount failed' : ''}',
            ),
          ),
        );

        // Clear selection and reload
        setState(() {
          _selectedPaths.clear();
        });
        _loadRoots();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }

  void _selectAll() {
    setState(() {
      _collectAllPaths(_rootNodes ?? []).forEach((path) {
        _selectedPaths[path] = true;
      });
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedPaths.clear();
    });
  }

  List<String> _collectAllPaths(List<DirectoryNode> nodes) {
    final paths = <String>[];
    for (final node in nodes) {
      for (final file in node.files) {
        paths.add(file.path);
      }
      for (final folder in node.folders) {
        paths.add(folder.path);
        // Recursively collect from expanded directories
        final expanded = _expandedDirectories[folder.path];
        if (expanded != null) {
          paths.addAll(_collectAllPaths([expanded]));
        }
      }
    }
    return paths;
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.f5): const RefreshIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          RefreshIntent: CallbackAction<RefreshIntent>(
            onInvoke: (_) => _loadRoots(),
          ),
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Scan Results'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: _isLoading ? null : _loadRoots,
              ),
            ],
          ),
          body: _buildBody(),
          bottomNavigationBar: _buildActionBar(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_rootNodes == null || _rootNodes!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No non-whitelisted items found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _rootNodes!.length,
      itemBuilder: (context, index) {
        final root = _rootNodes![index];
        // Wrap root as a FolderNode so it can be rendered as a tree node
        final rootFolder = FolderNode(
          path: root.path,
          name: root.path,
          sizeBytes: null,
          autoExpand: true, // Roots start expanded
          modifiedAt: DateTime.now(),
        );
        return TreeNodeWidget(
          folder: rootFolder,
          selectedPaths: _selectedPaths,
          expandedDirectories: _expandedDirectories,
          onSelectionChanged: _handleSelection,
          onAddToWhitelist: _handleAddToWhitelist,
          onExpand: _expandDirectory,
          depth: 0,
        );
      },
    );
  }

  Widget? _buildActionBar() {
    final selectedCount = _selectedPaths.values.where((v) => v).length;

    if (selectedCount == 0 && (_rootNodes == null || _rootNodes!.isEmpty)) {
      return null;
    }

    return BottomAppBar(
      child: Row(
        children: [
          TextButton.icon(
            onPressed: selectedCount > 0 ? _deselectAll : _selectAll,
            icon: Icon(
              selectedCount > 0
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
            label: Text(selectedCount > 0 ? 'Deselect All' : 'Select All'),
          ),
          const Spacer(),
          if (selectedCount > 0) ...[
            FilledButton.icon(
              onPressed: _handleDelete,
              icon: const Icon(Icons.delete),
              label: Text('Delete ($selectedCount)'),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
