import 'dart:async';
import '../models/scan_result.dart';
import 'scan/isolate_scanner.dart';
import 'path_matcher_service.dart';
import 'scan_root_service.dart';
import 'whitelist_service.dart';

enum ScanState { idle, scanning, complete }

class ScanStatus {
  final ScanState state;
  final int totalScanned;
  final int totalFound;
  final String? currentPath;
  final List<ScanResult> results;

  const ScanStatus({
    required this.state,
    this.totalScanned = 0,
    this.totalFound = 0,
    this.currentPath,
    this.results = const [],
  });

  ScanStatus copyWith({
    ScanState? state,
    int? totalScanned,
    int? totalFound,
    String? currentPath,
    List<ScanResult>? results,
  }) {
    return ScanStatus(
      state: state ?? this.state,
      totalScanned: totalScanned ?? this.totalScanned,
      totalFound: totalFound ?? this.totalFound,
      currentPath: currentPath ?? this.currentPath,
      results: results ?? this.results,
    );
  }
}

class ScanService {
  final ScanRootService _scanRootService;
  final WhitelistService _whitelistService;
  final PathMatcherService _pathMatcherService;

  final _statusController = StreamController<ScanStatus>.broadcast();
  Stream<ScanStatus> get statusStream => _statusController.stream;

  ScanStatus _currentStatus = const ScanStatus(state: ScanState.idle);
  ScanStatus get currentStatus => _currentStatus;

  bool _isScanning = false;
  final List<StreamSubscription> _activeSubscriptions = [];

  ScanService(
    this._scanRootService,
    this._whitelistService,
    this._pathMatcherService,
  );

  Future<void> startScan() async {
    if (_isScanning) return;
    _isScanning = true;

    await _pathMatcherService.rebuildTrie();

    final scanRoots = await _scanRootService.getEnabledScanRoots();
    if (scanRoots.isEmpty) {
      _updateStatus(const ScanStatus(state: ScanState.complete));
      _isScanning = false;
      return;
    }

    final whitelistItems = await _whitelistService.getAllItems();
    final whitelistedPaths = whitelistItems.map((item) => item.path).toList();

    _updateStatus(const ScanStatus(state: ScanState.scanning));

    final results = <ScanResult>[];
    var totalScanned = 0;
    var totalFound = 0;
    var activeScanners = scanRoots.length;

    for (final root in scanRoots) {
      final stream = await IsolateScanner.scanInIsolate(
        root.path,
        whitelistedPaths,
      );

      final subscription = stream.listen(
        (message) {
          if (!_isScanning) return;

          if (message is Map) {
            if (message['type'] == 'result') {
              final result = ScanResult.fromJson(
                message['data'] as Map<String, dynamic>,
              );
              results.add(result);
              totalFound++;
              _updateStatus(
                _currentStatus.copyWith(
                  totalFound: totalFound,
                  results: List.from(results),
                ),
              );
            } else if (message['type'] == 'progress') {
              totalScanned = message['scannedCount'] as int;
              _updateStatus(
                _currentStatus.copyWith(
                  totalScanned: totalScanned,
                  currentPath: message['currentPath'] as String,
                ),
              );
            }
          }
        },
        onDone: () {
          activeScanners--;
          if (activeScanners == 0 && _isScanning) {
            _updateStatus(_currentStatus.copyWith(state: ScanState.complete));
            _isScanning = false;
            _activeSubscriptions.clear();
          }
        },
        onError: (error) {
          activeScanners--;
          if (activeScanners == 0 && _isScanning) {
            _updateStatus(_currentStatus.copyWith(state: ScanState.complete));
            _isScanning = false;
            _activeSubscriptions.clear();
          }
        },
      );

      _activeSubscriptions.add(subscription);
    }
  }

  void stopScan() {
    if (!_isScanning) return;
    _isScanning = false;

    for (final subscription in _activeSubscriptions) {
      subscription.cancel();
    }
    _activeSubscriptions.clear();

    _updateStatus(_currentStatus.copyWith(state: ScanState.idle));
  }

  void _updateStatus(ScanStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  void dispose() {
    stopScan();
    _statusController.close();
  }
}
