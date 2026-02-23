# CLI 客户端设计

## 概述

为 Final Cleanner 添加独立的 Dart CLI 可执行文件（`bin/cli.dart`），复用现有服务层，通过 git 风格子命令暴露所有功能。

## 关键决策

| 决策项 | 选择 |
|--------|------|
| 运行方式 | 独立 Dart 可执行文件（`bin/cli.dart`） |
| 功能范围 | 对齐 UI 所有功能 |
| 子命令风格 | git 风格多级子命令 |
| 数据库 | 默认共享 GUI 数据库，`--db` 可覆盖 |
| 输出格式 | 默认人类可读，`--json` 切换 JSON |
| 扫描进度 | 只输出最终结果 |
| 删除确认 | 默认交互式确认，`-y` 跳过 |
| 参数解析 | `args` 官方包 |

## 架构变更

核心改动是把 `AppDatabase` 的初始化从 Flutter 插件依赖中解耦：

```
现状:
  main.dart → ProviderScope → AppDatabase() → path_provider (Flutter插件)

CLI:
  bin/cli.dart → AppDatabase.withPath(dbPath) → 直接打开文件 (纯Dart)
```

需要：
- 给 `AppDatabase` 加一个命名构造函数，接受显式路径
- 新增纯 Dart 的默认路径解析（不依赖 `path_provider`）
- `pubspec.yaml` 加 `args` 依赖
- CLI 入口不依赖任何 `package:flutter/` 导入

## 子命令结构

```
fc <global-options> <command> <subcommand> [arguments] [options]

全局选项:
  --db=<path>       指定数据库路径
  --json            JSON 格式输出

命令:
  whitelist          白名单管理
    list             列出所有白名单条目
    add <path>       添加路径 (--dir 标记为目录, --name=, --note=)
    remove <id>      删除条目
    search <query>   搜索白名单

  group              分组管理
    list             列出根分组
    create <name>    创建分组 (--parent=<id>, --note=)
    delete <id>      删除分组 (--recursive 连子分组一起删)
    items <id>       查看分组内条目
    add-item <group-id> <item-id>    添加条目到分组
    remove-item <group-id> <item-id> 从分组移除条目

  scan-root          扫描根目录管理
    list             列出所有扫描根目录
    add <path>       添加扫描根目录
    remove <id>      删除
    toggle <id>      启用/禁用 (--enable/--disable)

  scan               执行扫描，输出非白名单文件列表

  clean              扫描并删除非白名单文件
    (默认交互式确认, -y 跳过)

  export <file>      导出配置到 JSON 文件
  import <file>      从 JSON 文件导入配置
```

## 文件结构

```
bin/
  cli.dart                  # 入口
lib/
  cli/
    commands/
      whitelist_command.dart
      group_command.dart
      scan_root_command.dart
      scan_command.dart
      clean_command.dart
      export_command.dart
      import_command.dart
    cli_app.dart            # CommandRunner 组装
    db_path.dart            # 各平台默认数据库路径解析(纯Dart)
  data/
    database.dart           # 修改: 加 AppDatabase.withPath() 构造函数
```

## 数据库路径解析（纯 Dart）

```
Linux:   ~/.local/share/final_cleaner/final_cleaner.db
Windows: %LOCALAPPDATA%\final_cleaner\final_cleaner.db
```

与 `path_provider` 的 `getApplicationDocumentsDirectory` 对齐。

## 依赖管理

- CLI 入口只 import `lib/cli/`、`lib/services/`、`lib/models/`、`lib/data/` 下的纯 Dart 代码
- CLI 的数据库初始化用 `AppDatabase.withPath()` 绕过 `path_provider`
- SQLite 原生库：CLI 环境下使用系统 `libsqlite3`，不需要 `sqlite3_flutter_libs`
- 开发阶段用 `dart run bin/cli.dart`

## 错误处理

- 参数错误 → 打印用法提示，exit code 64
- 业务错误（路径不存在、重复添加等）→ 打印错误信息到 stderr，exit code 1
- 未知错误 → 打印堆栈到 stderr，exit code 1

## 不改动的部分

- 所有现有服务层代码不变
- 所有 model 不变
- GUI 入口 `main.dart` 不变
- 现有 provider 不变（CLI 不用 Riverpod，直接构造服务实例）

## 交互示例

### scan

```
$ fc scan
/home/user/.cache/some-app/temp.dat    1.2 MB   2025-01-15
/home/user/Downloads/random.zip       45.3 MB   2024-12-01
...
共 42 个文件，1.2 GB
```

### clean

```
$ fc clean
扫描中...
发现 42 个非白名单文件 (共 1.2 GB)

确认删除以上文件？[y/N] y

已删除 40 个文件，释放 1.1 GB
2 个文件删除失败:
  /path/to/locked/file
  /path/to/another/file
```

### JSON 输出

```
$ fc scan --json
[{"path": "...", "sizeBytes": ..., "modifiedAt": "...", "isDirectory": false}, ...]
```
