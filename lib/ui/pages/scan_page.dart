import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/scan_result.dart';
import '../widgets/scan_result_tile.dart';

enum ScanState { idle, scanning, completed }

enum SortBy { size, time, path }

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  ScanState _scanState = ScanState.idle;
  int _scannedCount = 0;
  String _currentPath = '';
  List<ScanResult> _results = [];
  final Set<String> _selectedPaths = {};
  SortBy _sortBy = SortBy.size;

  void _startScan() {
    setState(() {
      _scanState = ScanState.scanning;
      _scannedCount = 0;
      _currentPath = '/home/user/documents';
      _results = [];
      _selectedPaths.clear();
    });
  }

  void _stopScan() {
    setState(() {
      _scanState = ScanState.completed;
      _results = _generateMockResults();
    });
  }

  List<ScanResult> _generateMockResults() {
    return [
      ScanResult(
        path: '/home/user/downloads/temp.txt',
        sizeBytes: 1024 * 512,
        modifiedAt: DateTime.now().subtract(const Duration(days: 2)),
        isDirectory: false,
        extension: 'txt',
      ),
      ScanResult(
        path: '/home/user/cache/old_data',
        sizeBytes: 1024 * 1024 * 150,
        modifiedAt: DateTime.now().subtract(const Duration(days: 30)),
        isDirectory: true,
      ),
      ScanResult(
        path: '/tmp/session_12345.log',
        sizeBytes: 1024 * 256,
        modifiedAt: DateTime.now().subtract(const Duration(hours: 5)),
        isDirectory: false,
        extension: 'log',
      ),
    ];
  }

  void _toggleSelection(String path) {
    setState(() {
      if (_selectedPaths.contains(path)) {
        _selectedPaths.remove(path);
      } else {
        _selectedPaths.add(path);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedPaths.addAll(_results.map((r) => r.path));
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedPaths.clear();
    });
  }

  List<ScanResult> get _sortedResults {
    final results = List<ScanResult>.from(_results);
    switch (_sortBy) {
      case SortBy.size:
        results.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
      case SortBy.time:
        results.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
      case SortBy.path:
        results.sort((a, b) => a.path.compareTo(b.path));
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        actions: _scanState == ScanState.completed
            ? [
                PopupMenuButton<SortBy>(
                  icon: const Icon(Icons.sort),
                  onSelected: (value) => setState(() => _sortBy = value),
                  itemBuilder: (context) => [
                    CheckedPopupMenuItem(
                      value: SortBy.size,
                      checked: _sortBy == SortBy.size,
                      child: const Text('Sort by Size'),
                    ),
                    CheckedPopupMenuItem(
                      value: SortBy.time,
                      checked: _sortBy == SortBy.time,
                      child: const Text('Sort by Time'),
                    ),
                    CheckedPopupMenuItem(
                      value: SortBy.path,
                      checked: _sortBy == SortBy.path,
                      child: const Text('Sort by Path'),
                    ),
                  ],
                ),
              ]
            : null,
      ),
      body: _buildBody(),
      bottomNavigationBar:
          _scanState == ScanState.completed && _results.isNotEmpty
          ? _buildActionBar()
          : null,
    );
  }

  Widget _buildBody() {
    switch (_scanState) {
      case ScanState.idle:
        return _buildIdleState();
      case ScanState.scanning:
        return _buildScanningState();
      case ScanState.completed:
        return _buildResultsState();
    }
  }

  Widget _buildIdleState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _startScan,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Scan'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 32),
            Text(
              'Scanned $_scannedCount files',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Found ${_results.length} non-whitelisted items',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              _currentPath,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 32),
            FilledButton.tonalIcon(
              onPressed: _stopScan,
              icon: const Icon(Icons.stop),
              label: const Text('Stop Scan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsState() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.5),
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
      itemCount: _sortedResults.length,
      itemBuilder: (context, index) {
        final result = _sortedResults[index];
        return ScanResultTile(
          result: result,
          isSelected: _selectedPaths.contains(result.path),
          onToggle: () => _toggleSelection(result.path),
        );
      },
    );
  }

  Widget _buildActionBar() {
    final selectedCount = _selectedPaths.length;
    final allSelected = selectedCount == _results.length;

    return BottomAppBar(
      child: Row(
        children: [
          TextButton.icon(
            onPressed: allSelected ? _deselectAll : _selectAll,
            icon: Icon(
              allSelected ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            label: Text(allSelected ? 'Deselect All' : 'Select All'),
          ),
          const Spacer(),
          if (selectedCount > 0) ...[
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.playlist_add),
              label: const Text('Add to Whitelist'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () {},
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
