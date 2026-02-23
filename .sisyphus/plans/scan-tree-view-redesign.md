# 扫描结果树状展示与按需加载设计

**日期**: 2026-02-23  
**状态**: 设计完成，待实现

## 问题背景

当前扫描实现存在以下问题：

1. **全量扫描低效**：一次性扫描所有目录，即使用户只关心顶层结果
2. **扁平列表难导航**：所有结果平铺显示，无法体现目录层级关系
3. **交互不合理**：
   - 支持多选批量添加白名单，但缺少强制填写名称和描述的机制
   - 文件夹大小在扫描时全部计算，影响性能
4. **数据模型问题**：WhitelistItem 和 Group 是多对多关系，过于复杂

## 设计目标

1. **按需扫描**：只扫描用户展开的目录，提升性能
2. **树状展示**：以目录树形式展示结果，支持展开/折叠
3. **智能展开**：自动展开包含白名单项的父目录
4. **单选添加**：强制用户为每个白名单项填写信息
5. **多选删除**：保留批量删除功能
6. **简化关系**：WhitelistItem 和 Group 改为多对一关系

---

## 数据模型设计

### 1. 扫描结果模型

```dart
// 目录扫描结果
class DirectoryNode {
  final String path;              // 当前目录路径
  final List<FileNode> files;     // 直接子文件列表
  final List<FolderNode> folders; // 直接子文件夹列表
}

// 文件节点
class FileNode {
  final String path;
  final String name;
  final int sizeBytes;            // 文件总是有大小
  final DateTime modifiedAt;
}

// 文件夹节点
class FolderNode {
  final String path;
  final String name;
  final int? sizeBytes;           // null = 不可计算（包含未展开的子文件夹）
  final bool autoExpand;          // true = 深层有白名单项，需要自动展开
  final DateTime modifiedAt;
}
```

**设计要点**：

- `DirectoryNode` 只包含直接子项，不递归嵌套
- `FolderNode.sizeBytes` 可空：
  - `null`：包含未展开的子文件夹，无法计算
  - `数字`：所有子项都已展开且可计算，累加得出
- `FolderNode.autoExpand`：标记是否需要自动展开
  - `true`：该文件夹的某个后代在白名单中
  - `false`：无白名单后代，用户需手动展开

### 2. WhitelistItem 模型变更

```dart
class WhitelistItem {
  final int? id;
  final String path;
  final String? name;
  final String? note;
  final bool isDirectory;
  final int? groupId;             // 新增：关联分组（可为空表示未分组）
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

**变更说明**：

- 添加 `groupId` 字段，建立多对一关系
- 一个白名单项只能属于一个分组--

## 扫描服务 API 设计

### ScanService 接口

```dart
class ScanService {
  // 扫描指定目录，返回该目录的直接子项（非白名单的文件和文件夹）
  Future<DirectoryNode> scanDirectory(String path);
  
  // 扫描所有 scan roots 的顶层（用于初始显示）
  Future<List<DirectoryNode>> scanRoots();
}
```

**行为说明**：

- `scanDirectory(path)`：
  - 列出 `path` 下的所有直接子项
  - 跳过白名单中的项
  - 对每个子文件夹调用 `PathTrie.hasWhitelistedDescendants()` 判断是否自动展开
  - 计算文件夹大小（如果所有子项都可计算）
  
- `scanRoots()`：
  - 对每个启用的 scan root 调用 `scanDirectory()`
  - 返回所有根目录的扫描结果

### PathTrie 扩展

```dart
class PathTrie {
  // 现有：检查路径是否在白名单中
  bool contains(String path);
  
  // 新增：检查路径下是否有白名单后代（用于判断是否自动展开）
  bool hasWhitelistedDescendants(String path);
}
```

**实现要点**：

- `hasWhitelistedDescendants(path)` 遍历 Trie，查找是否有以 `path` 为前缀的节点
- 时间复杂度：O(路径深度)

---

## UI 交互设计

### 扫描结果页面结构

```
ScanResultPage
├── AppBar（标题 + 排序选项）
├── TreeView（树状列表）
│   └── TreeNode（递归组件）
│       ├── Checkbox（多选）
│       ├── ExpandIcon（文件夹展开/折叠）
│       ├── Icon（文件/文件夹图标）
│       ├── 名称 + 路径
│       ├── 大小（文件或可计算的文件夹）
│       └── "添加"按钮
└── BottomBar（选中项 > 0 时显示）
    ├── 已选数量显示
    ├── 全选/取消全选按钮
    └── 删除 (N) 按钮
```

### 交互行为

| 操作 | 行为 |
|------|------|
| 点击文件夹名称/展开图标 | 展开/折叠，首次展开时调用 `scanDirectory()` 按需加载 |
| 点击文件名称 | 视觉反馈（高亮），无其他操作 |
| 点击复选框 | 切换选中状态 |
| 点击"添加"按钮 | 弹出"添加到白名单"对话框 |
| 页面加载 | 自动递归展开所有 `autoExpand = true` 的文件夹 |

### 自动展开逻辑

**场景示例**：

白名单中有：`/home/user/Documents/project/src/main.dart`

扫描 `/home/user/` 时：

1. 扫描返回 `Documents/` 标记为 `autoExpand = true`
2. UI 自动展开 `Documents/`，触发扫描 `/home/user/Documents/`
3. 扫描返回 `project/` 标记为 `autoExpand = true`
4. UI 自动展开 `project/`，触发扫描 `/home/user/Documents/project/`
5. 扫描返回 `src/` 标记为 `autoExpand = true`
6. UI 自动展开 `src/`，触发扫描 `/home/user/Documents/project/src/`
7. 扫描发现 `main.dart` 在白名单中，跳过
8. 如果 `src/` 下还有其他非白名单文件（如 `test.dart`），则显示

**不显示的情况**：

如果 `/home/user/Documents/project/src/` 下只有 `main.dart`（在白名单中），且：
- `/home/user/Documents/project/` 下只有 `src/`
- `/home/user/Documents/` 下只有 `project/`

那么整个 `Documents/` 树都不显示（因为展开后是空的）。

### 添加到白名单对话框

```
AddToWhitelistDialog
├── 路径（只读显示，灰色文本）
├── 名称输入框
│   └── 默认值：文件/文件夹名（光标在末尾，可直接编辑）
├── 描述输入框（可选，多行文本）
├── 分组选择器
│   └── 下拉列表：未分组 / Group1 / Group2 / ...
└── 按钮
    ├── 取消
    └── 确认
```

**交互细节**：

- 名称输入框默认填充文件/文件夹名，光标在末尾
- 用户可以直接编辑，无需先删除默认值
- 描述和分组可选，可以留空
- 点击确认后，调用 `WhitelistService.addItem()` 添加

---

## 数据库 Schema 变更

### WhitelistItem 表变更

```sql
-- 添加 group_id 字段
ALTER TABLE whitelist_items ADD COLUMN group_id INTEGER REFERENCES groups(id);

-- 删除旧的多对多关系表（如果存在）
DROP TABLE IF EXISTS white_groups;
```

### 迁移策略

对于现有数据：
- 如果某个 WhitelistItem 之前属于多个分组，迁移时只保留第一个分组
- 或者全部设为 `null`（未分组），让用户重新分配

### Service API 变更

**WhitelistService**

```dart
class WhitelistService {
  // 添加白名单项（现在可以直接指定 groupId）
  Future<WhitelistItem> addItem({
    required String path,
    required bool isDirectory,
    String? name,
    String? note,
    int? groupId,  // 新增参数
  });
  
  // 更新白名单项（可以修改分组）
  Future<WhitelistItem> updateItem(
    int id, {
    String? name,
    String? note,
    int? groupId,  // 新增参数
  });
}
```

**GroupService**

```dart
class GroupService {
  // 删除多对多关系的方法
  // ❌ Future<void> addItemToGroup(int itemId, int groupId);
  // ❌ Future<void> removeItemFromGroup(int itemId, int groupId);
  
  // 保留查询方法
  Future<List<WhitelistItem>> getItemsInGroup(int groupId);
  
  // 简化：一个 item 只属于一个 group
  // ❌ Future<List<Group>> getGroupsForItem(int itemId);
  Future<Group?> getGroupForItem(int itemId);  // 改为返回单个
}
```

---

## 实现范围

### 需要修改/新增的文件

**模型层**：
- `lib/models/directory_node.dart` - 新增
- `lib/models/file_node.dart` - 新增
- `lib/models/folder_node.dart` - 新增
- `lib/models/whitelist_item.dart` - 添加 `groupId` 字段

**服务层**：
- `lib/services/scan_service.dart` - 完全重写（删除全量扫描，改为按需扫描）
- `lib/services/path_trie.dart` - 添加 `hasWhitelistedDescendants()` 方法
- `lib/services/whitelist_service.dart` - 添加 `groupId` 参数
- `lib/services/group_service.dart` - 简化 API（删除多对多关系方法）

**UI 层**：
- `lib/ui/pages/scan_page.dart` - 完全重写为树状视图
- `lib/ui/widgets/tree_node_widget.dart` - 新增（递归树节点组件）
- `lib/ui/widgets/add_to_whitelist_dialog.dart` - 新增
- `lib/ui/widgets/scan_result_tile.dart` - 删除（不再需要）

**数据层**：
- 数据库迁移脚本 - 添加 `group_id` 字段，删除关联表

---

## 性能优化

### 按需加载的优势

- **减少初始扫描时间**：只扫描顶层，不递归深入
- **降低内存占用**：不需要一次性加载所有结果
- **提升响应速度**：用户可以立即看到顶层结果

### 自动展开的性能考虑

- 自动展开可能触发多次 `scanDirectory()` 调用
- 但每次只扫描一层，总体仍比全量扫描快
- 可以考虑并行扫描多个自动展开的目录

### 文件夹大小计算

- 只在所有子项都可计算时才计算文件夹大小
- 避免在扫描时递归计算深层目录大小
- 用户展开后，逐步计算并更新父文件夹大小

---

## 测试策略

### 单元测试

- `PathTrie.hasWhitelistedDescendants()` 的正确性
- `ScanService.scanDirectory()` 的过滤逻辑
- 文件夹大小计算的准确性

### 集成测试

- 自动展开逻辑的完整流程
- 添加白名单后，扫描结果的更新
- 删除文件后，树状结构的更新

### UI 测试

- 树节点的展开/折叠
- 多选和单选操作的共存
- 对话框的输入和提交

---

## 未来扩展

### 可能的优化方向

1. **虚拟滚动**：大量结果时，只渲染可见区域
2. **缓存机制**：缓存已扫描的目录，避免重复扫描
3. **增量更新**：文件系统变化时，只更新受影响的节点
4. **搜索过滤**：在树状结构中搜索和过滤
5. **批量添加白名单**：虽然对话框是单个的，但可以支持批量添加（每个使用默认值）

### 可能的功能扩展

1. **右键菜单**：提供更多操作（重命名、移动、属性等）
2. **拖拽排序**：调整树节点的显示顺序
3. **导出树结构**：将扫描结果导出为文本或 JSON
4. **对比模式**：对比两次扫描的差异

---

## 总结

本设计方案通过以下核心变更，解决了当前扫描功能的性能和交互问题：

1. **按需扫描**：从全量扫描改为按需加载，提升性能
2. **树状展示**：从扁平列表改为树状结构，提升可导航性
3. **智能展开**：自动展开包含白名单项的父目录，提升用户体验
4. **单选添加**：强制填写名称和描述，提升数据质量
5. **简化关系**：多对多改为多对一，降低复杂度

实现后，用户可以更高效地浏览扫描结果，更精确地管理白名单。
