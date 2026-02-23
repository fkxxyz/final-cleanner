# Final Cleanner - Project Guidelines

## What This Project Does

A whitelist-driven file management tool for power users to maintain complete control over their Android/Windows/Linux systems by scanning and removing non-whitelisted files.

## Architecture

**Tech Stack**: Flutter (Dart) + SQLite + In-Memory Trie

**Core Components**:
- UI Layer: Flutter widgets with Riverpod state management
- Service Layer: WhitelistService, ScanService, PathMatcherService
- Data Layer: SQLite (persistent) + In-Memory Trie (runtime cache)

**Data Flow**:
1. Startup: Load whitelist from SQLite → Build in-memory Trie
2. Scan: Parallel filesystem traversal → Trie lookup → Collect non-whitelisted items
3. Manage: CRUD operations → Update SQLite → Rebuild Trie
4. Clean: Delete selected items → Recycle bin (Windows/Linux) or direct delete (Android)

## Project Structure

```
lib/
├── main.dart
├── models/              # Data models (WhitelistItem, Group, ScanResult)
├── services/            # Business logic (whitelist, scan, path matching)
├── providers/           # Riverpod state providers
├── ui/
│   ├── pages/          # Main pages (scan, whitelist, settings)
│   └── widgets/        # Reusable components
├── utils/              # Helper functions
└── platform/           # Platform-specific code (recycle bin operations)
```

## Development Rules

### Code Style

1. **Dart**: Follow official [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
2. **Formatting**: Run `dart format .` before every commit
3. **Linting**: Fix all warnings from `dart analyze`
4. **Naming**: Follow [Effective Dart](https://dart.dev/guides/language/effective-dart/style#identifiers) naming conventions

### Git Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/) format.
**Examples**:
 `feat(scan): implement parallel filesystem traversal`
 `fix(whitelist): resolve Trie rebuild race condition`
 `docs(readme): add installation instructions`

### Database Schema

**Never modify schema directly in production**. Use migration scripts:

```dart
// migrations/001_initial_schema.dart
// migrations/002_add_scan_roots.dart
```

### Testing Strategy

1. **Unit tests**: All service layer logic (100% coverage target)
2. **Widget tests**: Critical UI components
3. **Integration tests**: End-to-end workflows (scan → clean)
4. **Platform tests**: Recycle bin operations on each platform

Run tests before every commit: `flutter test`

### Platform-Specific Code

Isolate platform code in `lib/platform/`:

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

Use factory pattern to select implementation at runtime.

## Common Pitfalls

1. **Trie Rebuild**: Always rebuild Trie after whitelist modifications (add/delete/update)
2. **Isolate Communication**: Use `SendPort`/`ReceivePort` for scan results, not shared memory
3. **Path Normalization**: Always normalize paths before Trie lookup (handle `/`, `\`, trailing slashes)
4. **Permission Errors**: Catch and log, don't crash the entire scan
5. **Circular Symlinks**: Track visited inodes to prevent infinite loops
6. **SQLite Transactions**: Wrap batch operations in transactions for performance
7. **Android Scoped Storage**: Request `MANAGE_EXTERNAL_STORAGE` for full filesystem access

## Performance Targets

- **Startup**: < 2s (including Trie build for 10K whitelist items)
- **Scan**: > 10K files/second on SSD
- **Trie Lookup**: < 1μs per path
- **UI Responsiveness**: 60 FPS during scan (use Isolates for heavy work)

## Security Considerations

1. **No Root Required**: App should work without root/admin privileges
2. **Confirmation Dialogs**: Always confirm before bulk deletion
3. **Whitelist Backup**: Auto-backup before major operations
4. **Path Validation**: Sanitize user input to prevent path traversal attacks

## Multi-language Consistency
1. All user-facing strings must be internationalized (use Flutter's `intl` package)
2. Default language: English
3. Supported languages (MVP): English, Simplified Chinese

## Documentation

1. **Code Comments**: Explain WHY, not WHAT (code should be self-explanatory)
2. **API Docs**: Use `///` for public APIs (generates dartdoc)
3. **Architecture Decisions**: Document in `docs/decisions/` (ADR format)
4. **User Guide**: Maintain in `docs/user-guide.md`

## Before Every Commit

```bash
# Format code
dart format .

# Run linter
dart analyze

# Run tests
flutter test

# Check for outdated dependencies
flutter pub outdated
```

## Deployment

- **Android**: Build APK/AAB with `flutter build apk --release`
- **Windows**: Build with `flutter build windows --release`
- **Linux**: Build with `flutter build linux --release`

## Contact

- **Project Lead**: fkxxyz
- **Repository**: https://github.com/fkxxyz/final-cleaner (if applicable)
