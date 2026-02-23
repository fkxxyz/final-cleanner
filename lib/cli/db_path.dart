import 'dart:io';

import 'package:path/path.dart' as p;

/// Returns the default database file path for the current platform.
///
/// Linux:   ~/.local/share/final_cleaner/final_cleaner.db
/// Windows: %LOCALAPPDATA%\final_cleaner\final_cleaner.db
///
/// Creates the parent directory if it does not exist.
String defaultDbPath() {
  final String dir;

  if (Platform.isLinux || Platform.isAndroid) {
    final home = Platform.environment['HOME'];
    if (home == null) {
      throw StateError('HOME environment variable is not set');
    }
    dir = p.join(home, '.local', 'share', 'final_cleaner');
  } else if (Platform.isWindows) {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData == null) {
      throw StateError('LOCALAPPDATA environment variable is not set');
    }
    dir = p.join(localAppData, 'final_cleaner');
  } else {
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  final directory = Directory(dir);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  return p.join(dir, 'final_cleaner.db');
}
