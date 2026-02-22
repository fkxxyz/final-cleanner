# 终极清理 - 项目指南

## 项目简介

一个白名单驱动的文件管理工具，为高级用户设计，通过扫描和删除非白名单文件来完全掌控 Android/Windows/Linux 系统。

## 架构

**技术栈**: Flutter (Dart) + SQLite + 内存 Trie

**核心组件**:
- UI 层: Flutter widgets + Riverpod 状态管理
- 服务层: WhitelistService, ScanService, PathMatcherService
- 数据层: SQLite (持久化) + 内存 Trie (运行时缓存)

**数据流**:
1. 启动: 从 SQLite 加载白名单 → 构建内存 Trie
2. 扫描: 并行文件系统遍历 → Trie 查询 → 收集非白名单项
3. 管理: CRUD 操作 → 更新 SQLite → 重建 Trie
4. 清理: 删除选中项 → 回收站 (Windows/Linux) 或直接删除 (Android)

## 项目结构

```
lib/
├── main.dart
├── models/              # 数据模型 (WhitelistItem, Group, ScanResult)
├── services/            # 业务逻辑 (白名单、扫描、路径匹配)
├── providers/           # Riverpod 状态提供者
├── ui/
│   ├── pages/          # 主要页面 (扫描、白名单、设置)
│   └── widgets/        # 可复用组件
├── utils/              # 工具函数
└── platform/           # 平台特定代码 (回收站操作)
```

## 开发规范

### 代码风格

1. **Dart**: 遵循官方 [Effective Dart](https://dart.dev/guides/language/effective-dart) 指南
2. **格式化**: 每次提交前运行 `dart format .`
3. **代码检查**: 修复所有 `dart analyze` 警告
4. **命名规范**:
   - 类名: `PascalCase`
   - 函数/变量: `camelCase`
   - 常量: `lowerCamelCase` (Dart 约定)
   - 私有成员: 前缀 `_`

### Git 提交信息

遵循 [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**示例**:
- `feat(scan): 实现并行文件系统遍历`
- `fix(whitelist): 解决 Trie 重建竞态条件`
- `docs(readme): 添加安装说明`

### 数据库架构

**禁止直接修改生产环境数据库架构**。使用迁移脚本:

```dart
// migrations/001_initial_schema.dart
// migrations/002_add_scan_roots.dart
```

### 测试策略

1. **单元测试**: 所有服务层逻辑 (目标 100% 覆盖率)
2. **组件测试**: 关键 UI 组件
3. **集成测试**: 端到端工作流 (扫描 → 清理)
4. **平台测试**: 各平台回收站操作

每次提交前运行测试: `flutter test`

### 平台特定代码

将平台代码隔离在 `lib/platform/`:

```dart
// lib/platform/recycle_bin.dart
abstract class RecycleBin {
  Future<void> moveToTrash(String path);
}

// lib/platform/recycle_bin_windows.dart
class RecycleBinWindows implements RecycleBin { ... }

// lib/platform/recycle_bin_linux.dart
class RecycleBinLinux implements RecycleBin { ... }

// lib/platform/recycle_bin_android.dart
class RecycleBinAndroid implements RecycleBin { ... }
```

使用工厂模式在运行时选择实现。

## 常见陷阱

1. **Trie 重建**: 白名单修改后必须重建 Trie (添加/删除/更新)
2. **Isolate 通信**: 使用 `SendPort`/`ReceivePort` 传递扫描结果，不要共享内存
3. **路径规范化**: Trie 查询前必须规范化路径 (处理 `/`, `\`, 尾部斜杠)
4. **权限错误**: 捕获并记录，不要让整个扫描崩溃
5. **循环符号链接**: 跟踪已访问的 inode 防止无限循环
6. **SQLite 事务**: 批量操作用事务包装以提升性能
7. **Android 分区存储**: 请求 `MANAGE_EXTERNAL_STORAGE` 以获得完整文件系统访问权限

## 性能目标

- **启动时间**: < 2秒 (包括构建 10K 白名单项的 Trie)
- **扫描速度**: SSD 上 > 10K 文件/秒
- **Trie 查询**: < 1μs 每次路径查询
- **UI 响应**: 扫描期间保持 60 FPS (使用 Isolate 处理重任务)

## 安全考虑

1. **无需 Root**: 应用应在无 root/管理员权限下工作
2. **确认对话框**: 批量删除前必须确认
3. **白名单备份**: 重大操作前自动备份
4. **路径验证**: 清理用户输入防止路径遍历攻击

## 多语言一致性

1. 每个 `AGENTS.md` 必须有对应的 `AGENTS.zh-CN.md`
2. 所有面向用户的字符串必须国际化 (使用 Flutter 的 `intl` 包)
3. 默认语言: 英语
4. 支持语言 (MVP): 英语、简体中文

## 文档

1. **代码注释**: 解释为什么 (WHY)，而不是做什么 (WHAT) (代码应该自解释)
2. **API 文档**: 公共 API 使用 `///` (生成 dartdoc)
3. **架构决策**: 记录在 `docs/decisions/` (ADR 格式)
4. **用户指南**: 维护在 `docs/user-guide.md`

## 每次提交前

```bash
# 格式化代码
dart format .

# 运行代码检查
dart analyze

# 运行测试
flutter test

# 检查过期依赖
flutter pub outdated
```

## 部署

- **Android**: 使用 `flutter build apk --release` 构建 APK/AAB
- **Windows**: 使用 `flutter build windows --release` 构建
- **Linux**: 使用 `flutter build linux --release` 构建

## 联系方式

- **项目负责人**: fkxxyz
- **代码仓库**: https://github.com/fkxxyz/final-cleanner (如适用)
