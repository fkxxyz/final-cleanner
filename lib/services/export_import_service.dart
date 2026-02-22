import 'dart:convert';
import 'dart:io';

import '../data/database.dart';
import 'group_service.dart';
import 'scan_root_service.dart';
import 'whitelist_service.dart';

class ExportImportService {
  final WhitelistService _whitelistService;
  final GroupService _groupService;
  final ScanRootService _scanRootService;

  ExportImportService(
    this._whitelistService,
    this._groupService,
    this._scanRootService,
  );

  Future<String> exportToJson() async {
    final items = await _whitelistService.getAllItems();
    final scanRoots = await _scanRootService.getAllScanRoots();

    final rootGroups = await _groupService.getRootGroups();
    final allGroups = <Map<String, dynamic>>[];
    final groupIndexMap = <int, int>{};

    Future<void> collectGroups(Group group, int? parentIndex) async {
      final currentIndex = allGroups.length;
      groupIndexMap[group.id] = currentIndex;

      allGroups.add({
        'name': group.name,
        'note': group.note,
        'parentIndex': parentIndex,
      });

      final children = await _groupService.getChildren(group.id);
      for (final child in children) {
        await collectGroups(child, currentIndex);
      }
    }

    for (final root in rootGroups) {
      await collectGroups(root, null);
    }

    final itemsData = <Map<String, dynamic>>[];
    for (final item in items) {
      final groups = await _groupService.getGroupsForItem(item.id);
      final groupIndices = groups
          .map((g) => groupIndexMap[g.id])
          .where((idx) => idx != null)
          .cast<int>()
          .toList();

      itemsData.add({
        'path': item.path,
        'isDirectory': item.isDirectory,
        'name': item.name,
        'note': item.note,
        'groupIndices': groupIndices,
      });
    }

    final exportData = {
      'whitelistItems': itemsData,
      'groups': allGroups,
      'scanRoots': scanRoots
          .map((root) => {'path': root.path, 'enabled': root.enabled})
          .toList(),
    };

    return jsonEncode(exportData);
  }

  Future<void> exportToFile(String filePath) async {
    final json = await exportToJson();
    await File(filePath).writeAsString(json);
  }

  Future<void> importFromJson(String jsonString) async {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    final groupsData = (data['groups'] as List<dynamic>?) ?? [];
    final indexToGroupId = <int, int>{};

    for (var i = 0; i < groupsData.length; i++) {
      final groupData = groupsData[i] as Map<String, dynamic>;
      final parentIndex = groupData['parentIndex'] as int?;
      final parentId = parentIndex != null ? indexToGroupId[parentIndex] : null;

      final group = await _groupService.createGroup(
        name: groupData['name'] as String,
        note: groupData['note'] as String?,
        parentId: parentId,
      );

      indexToGroupId[i] = group.id;
    }

    final itemsData = (data['whitelistItems'] as List<dynamic>?) ?? [];
    for (final itemData in itemsData) {
      final item = await _whitelistService.addItem(
        path: itemData['path'] as String,
        isDirectory: itemData['isDirectory'] as bool,
        name: itemData['name'] as String?,
        note: itemData['note'] as String?,
      );

      final groupIndices = (itemData['groupIndices'] as List<dynamic>?) ?? [];
      for (final index in groupIndices) {
        final groupId = indexToGroupId[index as int];
        if (groupId != null) {
          await _groupService.addItemToGroup(item.id, groupId);
        }
      }
    }

    final scanRootsData = (data['scanRoots'] as List<dynamic>?) ?? [];
    for (final rootData in scanRootsData) {
      await _scanRootService.addScanRoot(rootData['path'] as String);
    }
  }

  Future<void> importFromFile(String filePath) async {
    final json = await File(filePath).readAsString();
    await importFromJson(json);
  }
}
