import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Requests storage permissions required for filesystem scanning.
  /// On Android 11+, this will prompt the user to grant MANAGE_EXTERNAL_STORAGE.
  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) {
      // Non-Android platforms don't need runtime permission requests
      return true;
    }

    // Android 11+ (API 30+) requires MANAGE_EXTERNAL_STORAGE for full filesystem access
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    // Request the permission
    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    }

    // If denied, check if we should show rationale or open settings
    if (status.isPermanentlyDenied) {
      // User has permanently denied - open app settings
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Checks if storage permission is currently granted.
  Future<bool> hasStoragePermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    return await Permission.manageExternalStorage.isGranted;
  }
}
