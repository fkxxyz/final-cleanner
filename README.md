# Final Cleaner

[中文](README.zh-CN.md)

How many files on your system do you actually need?

Most people have no idea. Apps silently dump caches, logs, and temp files everywhere. Over time, your system bloats and you lose track. Traditional cleaners use blacklists — you tell them what to delete. But you can never list everything.

Final Cleaner flips the model: you tell it what to keep. Everything else goes.

## How It Works

1. Define a whitelist — files and directories you explicitly want to keep
2. Scan — parallel filesystem traversal finds everything not on your whitelist
3. Clean — review and bulk-delete, with recycle bin support

That's it. You have full control over every file on your system.

## Features

- Whitelist-driven, not blacklist
- Parallel scanning, 10K+ files/sec on SSD
- Organize whitelist items into hierarchical groups
- Import/Export whitelist (JSON)
- Recycle bin support (Linux / Windows)
- Cross-platform: Android, Windows, Linux
- English + Chinese UI

## ⚠️ Warning

> **This tool is designed for advanced users who fully understand filesystem management.**
> 
> - This application can **permanently delete files without recovery**
> - Improper use may result in **critical system file loss**
> - By using this software, you **accept all risks and responsibilities**
> - The developers and contributors are **not liable for any data loss or damage**
> 
> **If you are not comfortable with these risks, do not use this tool.**

## Install

### Build from source

Requires [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.41.0.

```bash
git clone https://github.com/fkxxyz/final-cleaner.git
cd final-cleaner
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Build for your platform:

```bash
flutter build linux --release    # Linux
flutter build windows --release  # Windows
flutter build apk --release      # Android
```

Output goes to `build/`.

### Build AppImage (Linux)

For single-file distribution on Linux:

```bash
linux/appimage/build-appimage.sh
```

This creates `build/Final-Cleaner-1.0.0-x86_64.AppImage` that runs on most Linux distributions without installation.

Requirements:
- Flutter SDK
- wget (for downloading appimagetool)
- FUSE 2 (for running AppImage)

## Use Cases

- Periodically clean up stale build artifacts and caches on dev machines
- Keep a server lean — only the files you need, nothing else
- Manage storage on Android devices
- The ultimate tool for the tidy-minded

## Contributing

Contributions welcome. See [AGENTS.md](AGENTS.md) for development guidelines.

## License

TBD
