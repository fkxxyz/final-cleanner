import 'package:mocktail/mocktail.dart';

import 'package:final_cleaner/services/whitelist_service.dart';
import 'package:final_cleaner/services/group_service.dart';
import 'package:final_cleaner/services/scan_root_service.dart';
import 'package:final_cleaner/services/scan_service.dart';
import 'package:final_cleaner/services/deletion_service.dart';
import 'package:final_cleaner/services/export_import_service.dart';

// Create mocks for all services

class MockWhitelistService extends Mock implements WhitelistService {}

class MockGroupService extends Mock implements GroupService {}

class MockScanRootService extends Mock implements ScanRootService {}

class MockScanService extends Mock implements ScanService {}

class MockDeletionService extends Mock implements DeletionService {}

class MockExportImportService extends Mock implements ExportImportService {}
