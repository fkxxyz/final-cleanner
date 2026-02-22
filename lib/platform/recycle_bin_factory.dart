import 'dart:io' show Platform;

import 'recycle_bin.dart';
import 'recycle_bin_android.dart';
import 'recycle_bin_linux.dart';
import 'recycle_bin_windows.dart';

class RecycleBinFactory {
  static RecycleBin create() {
    if (Platform.isLinux) return RecycleBinLinux();
    if (Platform.isWindows) return RecycleBinWindows();
    if (Platform.isAndroid) return RecycleBinAndroid();
    throw UnsupportedError(
      'Platform not supported: ${Platform.operatingSystem}',
    );
  }
}
