# 扫描结果树状展示实施计划

**基于设计**: scan-tree-view-redesign.md  
**创建时间**: 2026-02-23  
**预计工作量**: 大型重构

## 任务清单

### 阶段 1: 数据模型层 (可并行)

 [x] 创建 `lib/models/directory_node.dart` - DirectoryNode 模型
 [x] 创建 `lib/models/file_node.dart` - FileNode 模型  
 [x] 创建 `lib/models/folder_node.dart` - FolderNode 模型
 [x] 修改 `lib/models/whitelist_item.dart` - 添加 groupId 字段

### 阶段 2: 数据库迁移 (依赖阶段1)

 [x] 创建数据库迁移脚本 - 添加 whitelist_items.group_id 字段
 [x] 创建数据库迁移脚本 - 删除 whitelist_item_groups 表（如果存在）
 [x] 更新 repository 层 - 适配新的 groupId 字段

### 阶段 3: 服务层重构 (依赖阶段2)

 [x] 扩展 `lib/services/path_trie.dart` - 添加 hasWhitelistedDescendants() 方法
- [ ] 重写 `lib/services/scan_service.dart` - 实现按需扫描 scanDirectory() 和 scanRoots()
 [x] 更新 `lib/services/whitelist_service.dart` - addItem() 和 updateItem() 添加 groupId 参数
- [ ] 简化 `lib/services/group_service.dart` - 删除多对多关系方法，改为多对一

### 阶段 4: UI 组件开发 (可部分并行)

- [ ] 创建 `lib/ui/widgets/tree_node_widget.dart` - 递归树节点组件
- [ ] 创建 `lib/ui/widgets/add_to_whitelist_dialog.dart` - 添加白名单对话框
- [ ] 重写 `lib/ui/pages/scan_page.dart` - 树状视图 + 自动展开逻辑
- [ ] 删除 `lib/ui/widgets/scan_result_tile.dart` - 不再需要

### 阶段 5: 测试与验证

- [ ] 编写单元测试 - PathTrie.hasWhitelistedDescendants()
- [ ] 编写单元测试 - ScanService.scanDirectory() 过滤逻辑
- [ ] 编写集成测试 - 自动展开完整流程
- [ ] 编写 UI 测试 - 树节点展开/折叠、多选/单选共存
- [ ] 手动测试 - 完整用户流程验证

---

## 任务详细说明

### 阶段 1 任务详情

#### 任务 1: 创建 DirectoryNode 模型
**文件**: `lib/models/directory_node.dart`
**内容**:
```dart
class DirectoryNode {
  final String path;
  final List<FileNode> files;
  final List<FolderNode> folders;
  
  const DirectoryNode({
    required this.path,
    required this.files,
    required this.folders,
  });
  
  // toJson, fromJson, copyWith, ==, hashCode
}
```

#### 任务 2: 创建 FileNode 模型
**文件**: `lib/models/file_node.dart`
**内容**:
```dart
class FileNode {
  final String path;
  final String name;
  final int sizeBytes;
  final DateTime modifiedAt;
  
  const FileNode({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.modifiedAt,
  });
  
  String get formattedSize { /* 格式化大小 */ }
  
  // toJson, fromJson, copyWith, ==, hashCode
}
```

#### 任务 3: 创建 FolderNode 模型
**文件**: `lib/models/folder_node.dart`
**内容**:
```dart
class FolderNode {
  final String path;
  final String name;
  final int? sizeBytes;  // null = 不可计算
  final bool autoExpand;
  final DateTime modifiedAt;
  
  const FolderNode({
    required this.path,
    required this.name,
    this.sizeBytes,
    required this.autoExpand,
    required this.modifiedAt,
  });
  
  String? get formattedSize { /* 格式化大小，可能为 null */ }
  
  // toJson, fromJson, copyWith, ==, hashCode
}
```

#### 任务 4: 修改 WhitelistItem 模型
**文件**: `lib/models/whitelist_item.dart`
**变更**: 添加 `final int? groupId;` 字段

---

### 阶段 2 任务详情

#### 任务 5: 数据库迁移 - 添加 group_id
**创建迁移脚本** (具体路径根据项目结构确定)
```sql
ALTER TABLE whitelist_items ADD COLUMN group_id INTEGER REFERENCES groups(id);
```

#### 任务 6: 数据库迁移 - 删除关联表
```sql
DROP TABLE IF EXISTS whitelist_item_groups;
```

#### 任务 7: 更新 repository 层
- 修改 `WhitelistRepository` 的 `addItem()` 和 `updateItem()` 方法
- 修改 SQL 查询，包含 `group_id` 字段

---

### 阶段 3 任务详情

#### 任务 8: 扩展 PathTrie
**文件**: `lib/services/path_trie.dart`
**新增方法**:
```dart
bool hasWhitelistedDescendants(String path) {
  // 遍历 Trie，查找是否有以 path 为前缀的节点
  // 返回 true 如果找到任何后代节点
}
```

#### 任务 9: 重写 ScanService
**文件**: `lib/services/scan_service.dart`
**删除**: `startScan()`, `stopScan()`, 所有全量扫描逻辑
**新增**:
```dart
Future<DirectoryNode> scanDirectory(String path) {
  // 1. 列出 path 下的直接子项
  // 2. 跳过白名单中的项
  // 3. 对每个文件夹调用 hasWhitelistedDescendants()
  // 4. 计算文件夹大小（如果可能）
  // 5. 返回 DirectoryNode
}

Future<List<DirectoryNode>> scanRoots() {
  // 对每个启用的 scan root 调用 scanDirectory()
}
```

#### 任务 10: 更新 WhitelistService
**文件**: `lib/services/whitelist_service.dart`
**变更**: `addItem()` 和 `updateItem()` 添加 `int? groupId` 参数

#### 任务 11: 简化 GroupService
**文件**: `lib/services/group_service.dart`
**删除**:
- `addItemToGroup()`
- `removeItemFromGroup()`
- `getGroupsForItem()` (返回 List)

**新增**:
- `getGroupForItem(int itemId)` 返回 `Future<Group?>`

---

### 阶段 4 任务详情

#### 任务 12: 创建树节点组件
**文件**: `lib/ui/widgets/tree_node_widget.dart`
**功能**:
- 递归渲染文件夹和文件
- 支持展开/折叠
- 显示复选框 + "添加"按钮
- 首次展开时调用 `scanDirectory()`

#### 任务 13: 创建添加白名单对话框
**文件**: `lib/ui/widgets/add_to_whitelist_dialog.dart`
**字段**:
- 路径（只读）
- 名称（默认文件名，可编辑）
- 描述（可选）
- 分组选择器（下拉列表）

#### 任务 14: 重写扫描页面
**文件**: `lib/ui/pages/scan_page.dart`
**功能**:
- 调用 `scanRoots()` 获取初始数据
- 渲染树状视图
- 实现自动展开逻辑（递归展开 autoExpand = true 的文件夹）
- 底部操作栏（全选/取消全选、删除）

#### 任务 15: 删除旧组件
**文件**: `lib/ui/widgets/scan_result_tile.dart`
**操作**: 删除文件

---

### 阶段 5 任务详情

#### 任务 16-19: 测试
- 单元测试覆盖核心逻辑
- 集成测试验证完整流程
- UI 测试确保交互正确
- 手动测试用户体验

---

## 并行化建议

**可并行执行的任务组**:
- 阶段 1 的所有任务 (1-4) 可并行
- 任务 12 和 13 可并行（UI 组件独立）

**必须顺序执行**:
- 阶段 1 → 阶段 2 → 阶段 3 → 阶段 4 → 阶段 5

---

## 风险与注意事项

1. **数据迁移**: 现有数据库可能有多对多关系数据，需要妥善处理
2. **性能测试**: 自动展开可能触发多次扫描，需要验证性能
3. **UI 复杂度**: 树状组件的递归渲染需要仔细处理状态管理
4. **向后兼容**: 考虑是否需要保留旧的扫描 API 供 CLI 使用

---

## 参考文档

- 设计方案: `.sisyphus/plans/scan-tree-view-redesign.md`
- 项目规范: `AGENTS.md`, `AGENTS.zh-CN.md`
