# Final Cleanner
[English](README.md)

你的系统里有多少文件是你真正需要的？

大多数人不知道。各种软件在后台悄悄写入缓存、日志、临时文件，日积月累，系统变得臃肿而失控。传统的清理工具靠黑名单——告诉它哪些该删。但你永远列不完。

Final Cleanner 反过来：你告诉它哪些要留，剩下的全部清理。

## 工作方式

1. 设定白名单——你明确要保留的文件和目录
2. 扫描——并行遍历文件系统，找出所有不在白名单中的文件
3. 清理——确认后批量删除，支持回收站

就这么简单。你对系统里的每一个文件都有完全的掌控。

## 特性

- 白名单驱动，而非黑名单
- 并行扫描，SSD 上每秒处理万级文件
- 分组管理白名单，支持层级结构
- 白名单导入/导出（JSON）
- 回收站支持（Linux / Windows）
- 跨平台：Android、Windows、Linux
- 中英双语界面

## 安装

### 从源码构建

需要 [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.41.0。

```bash
git clone https://github.com/fkxxyz/final-cleanner.git
cd final-cleanner
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

构建你的平台：

```bash
flutter build linux --release    # Linux
flutter build windows --release  # Windows
flutter build apk --release      # Android
```

产物在 `build/` 目录下。

## 使用场景

- 定期清理开发机上散落的构建产物和缓存
- 维护一台干净的服务器，只保留必要文件
- Android 设备存储空间管理
- 强迫症患者的终极工具

## 参与开发

欢迎贡献。开发相关信息见 [AGENTS.zh-CN.md](AGENTS.zh-CN.md)。

## License

TBD
