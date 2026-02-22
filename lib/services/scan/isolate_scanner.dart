import 'dart:async';
import 'dart:isolate';
import '../../models/scan_result.dart';
import '../path_trie.dart';
import 'filesystem_scanner.dart';

class IsolateScannerMessage {
  final String rootPath;
  final List<String> whitelistedPaths;
  final SendPort sendPort;

  const IsolateScannerMessage({
    required this.rootPath,
    required this.whitelistedPaths,
    required this.sendPort,
  });
}

class IsolateScanner {
  static Future<Stream<dynamic>> scanInIsolate(
    String rootPath,
    List<String> whitelistedPaths,
  ) async {
    final receivePort = ReceivePort();
    final controller = StreamController<dynamic>();

    await Isolate.spawn(
      _isolateEntry,
      IsolateScannerMessage(
        rootPath: rootPath,
        whitelistedPaths: whitelistedPaths,
        sendPort: receivePort.sendPort,
      ),
    );

    receivePort.listen((message) {
      if (message == null) {
        controller.close();
        receivePort.close();
      } else {
        controller.add(message);
      }
    });

    return controller.stream;
  }

  static void _isolateEntry(IsolateScannerMessage message) async {
    final trie = PathTrie();
    for (final path in message.whitelistedPaths) {
      trie.insert(path);
    }

    final scanner = FilesystemScanner();
    final stream = scanner.scan(message.rootPath, trie.isWhitelisted);

    await for (final result in stream) {
      if (result is ScanResult) {
        message.sendPort.send({'type': 'result', 'data': result.toJson()});
      } else if (result is ScanProgress) {
        message.sendPort.send({
          'type': 'progress',
          'scannedCount': result.scannedCount,
          'foundCount': result.foundCount,
          'currentPath': result.currentPath,
        });
      }
    }

    message.sendPort.send(null);
  }
}
