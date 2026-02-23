import 'package:mocktail/mocktail.dart';

import 'package:final_cleanner/services/whitelist_service.dart';
import 'package:final_cleanner/services/group_service.dart';
import 'package:final_cleanner/services/scan_root_service.dart';
import 'package:final_cleanner/services/scan_service.dart';
import 'package:final_cleanner/services/deletion_service.dart';
import 'package:final_cleanner/services/export_import_service.dart';

// Create mocks for all services

class MockWhitelistService extends Mock implements WhitelistService {}

class MockGroupService extends Mock implements GroupService {}

class MockScanRootService extends Mock implements ScanRootService {}

class MockScanService extends Mock implements ScanService {}

class MockDeletionService extends Mock implements DeletionService {}

class MockExportImportService extends Mock implements ExportImportService {}
