# Final Cleanner - TODO List

This document tracks all planned features and tasks for the Final Cleanner project, organized by priority and implementation phase.

## Legend

- 🔴 **Critical** - Must be completed for MVP
- 🟡 **Important** - Should be completed for MVP
- 🟢 **Nice to Have** - Post-MVP features
- ✅ **Completed**
- 🚧 **In Progress**
- ⏸️ **Blocked**
- 📋 **Planned**

---

## Phase 0: Project Setup

### 0.1 Repository Initialization 🔴
**Status**: 📋 Planned  
**Description**: Set up the Flutter project structure and development environment.

**Tasks**:
- [ ] Initialize Flutter project with `flutter create`
- [ ] Configure multi-platform support (Android, Windows, Linux)
- [ ] Set up `.gitignore` for Flutter projects
- [ ] Create initial directory structure (`lib/models`, `lib/services`, `lib/providers`, `lib/ui`, `lib/utils`, `lib/platform`)
- [ ] Add project metadata to `pubspec.yaml` (name, description, version)
- [ ] Configure Dart SDK constraints

**Dependencies**: None  
**Estimated Time**: 2 hours

---

### 0.2 Development Tools Setup 🔴
**Status**: 📋 Planned  
**Description**: Configure linting, formatting, and analysis tools.

**Tasks**:
- [ ] Add `analysis_options.yaml` with strict linting rules
- [ ] Configure `dart format` settings
- [ ] Set up pre-commit hooks for formatting and linting
- [ ] Add recommended VS Code / Android Studio extensions to documentation
- [ ] Configure CI/CD pipeline (GitHub Actions) for automated testing

**Dependencies**: 0.1  
**Estimated Time**: 3 hours

---

### 0.3 Dependencies Installation 🔴
**Status**: 📋 Planned  
**Description**: Add all required Flutter packages to `pubspec.yaml`.

**Tasks**:
- [ ] Add `sqflite` for SQLite database
- [ ] Add `drift` for type-safe SQL queries
- [ ] Add `riverpod` and `flutter_riverpod` for state management
- [ ] Add `path_provider` for platform-specific paths
- [ ] Add `permission_handler` for runtime permissions
- [ ] Add `file_picker` for directory selection
- [ ] Add `intl` for internationalization
- [ ] Add development dependencies: `build_runner`, `drift_dev`, `flutter_test`
- [ ] Run `flutter pub get` to install all packages

**Dependencies**: 0.1  
**Estimated Time**: 1 hour

---

## Phase 1: Data Layer (M1)

### 1.1 Database Schema Design 🔴
**Status**: 📋 Planned  
**Description**: Design and implement the SQLite database schema using Drift.

**Tasks**:
- [ ] Create `lib/data/database.dart` with Drift database class
- [ ] Define `WhitelistItems` table with columns: id, path, name, note, is_directory, created_at, updated_at
- [ ] Define `Groups` table with columns: id, name, note, created_at
- [ ] Define `GroupClosure` table (closure table) with columns: ancestor, descendant, depth
- [ ] Define `ItemGroupRelations` table with columns: item_id, group_id
- [ ] Define `ScanRoots` table with columns: id, path, enabled
- [ ] Add foreign key constraints and indexes
- [ ] Generate Drift code with `flutter pub run build_runner build`
- [ ] Write migration script for initial schema

**Dependencies**: 0.3  
**Estimated Time**: 6 hours

---

### 1.2 Data Models 🔴
**Status**: 📋 Planned  
**Description**: Create Dart data models for domain entities.

**Tasks**:
- [ ] Create `lib/models/whitelist_item.dart` with WhitelistItem class
- [ ] Create `lib/models/group.dart` with Group class
- [ ] Create `lib/models/scan_root.dart` with ScanRoot class
- [ ] Create `lib/models/scan_result.dart` with ScanResult class
- [ ] Add `toJson()` and `fromJson()` methods for serialization
- [ ] Add `copyWith()` methods for immutability
- [ ] Add equality operators and hashCode overrides

**Dependencies**: None  
**Estimated Time**: 4 hours

---

### 1.3 Database Repository 🔴
**Status**: 📋 Planned  
**Description**: Implement repository pattern for database operations.

**Tasks**:
- [ ] Create `lib/data/repositories/whitelist_repository.dart`
- [ ] Implement CRUD operations for whitelist items
- [ ] Implement CRUD operations for groups
- [ ] Implement closure table operations (add/remove/move groups)
- [ ] Implement CRUD operations for scan roots
- [ ] Add transaction support for batch operations
- [ ] Add error handling and logging
- [ ] Write unit tests for all repository methods

**Dependencies**: 1.1, 1.2  
**Estimated Time**: 8 hours

---

### 1.4 In-Memory Trie Implementation 🔴
**Status**: 📋 Planned  
**Description**: Implement a Trie data structure for fast path matching.

**Tasks**:
- [ ] Create `lib/data/trie.dart` with TrieNode class
- [ ] Implement `insert(String path)` method
- [ ] Implement `contains(String path)` method with prefix matching
- [ ] Implement `remove(String path)` method
- [ ] Implement `clear()` method
- [ ] Handle path normalization (forward/backward slashes, trailing slashes)
- [ ] Optimize for memory efficiency (shared prefixes)
- [ ] Write unit tests with various path scenarios
- [ ] Benchmark query performance (target < 1μs per query)

**Dependencies**: None  
**Estimated Time**: 10 hours

---

## Phase 2: Service Layer (M1)

### 2.1 WhitelistService 🔴
**Status**: 📋 Planned  
**Description**: Business logic for whitelist management.

**Tasks**:
- [ ] Create `lib/services/whitelist_service.dart`
- [ ] Implement `addItem(WhitelistItem item)` with validation
- [ ] Implement `updateItem(WhitelistItem item)`
- [ ] Implement `deleteItem(int id)`
- [ ] Implement `deleteItems(List<int> ids)` for batch deletion
- [ ] Implement `getItem(int id)`
- [ ] Implement `getAllItems()` with optional filtering
- [ ] Implement `searchItems(String query)`
- [ ] Trigger Trie rebuild after modifications
- [ ] Write unit tests for all methods

**Dependencies**: 1.3, 1.4  
**Estimated Time**: 6 hours

---

### 2.2 GroupService 🔴
**Status**: 📋 Planned  
**Description**: Business logic for group management.

**Tasks**:
- [ ] Create `lib/services/group_service.dart`
- [ ] Implement `createGroup(Group group, int? parentId)`
- [ ] Implement `updateGroup(Group group)`
- [ ] Implement `deleteGroup(int id, DeleteStrategy strategy)` with strategies: delete all, move to parent, cancel
- [ ] Implement `moveItem(int itemId, int targetGroupId)`
- [ ] Implement `getGroupTree()` returning hierarchical structure
- [ ] Implement `getGroupPath(int groupId)` returning ancestor chain
- [ ] Implement `getItemsInGroup(int groupId, bool recursive)`
- [ ] Write unit tests for all methods

**Dependencies**: 1.3  
**Estimated Time**: 8 hours

---

### 2.3 PathMatcherService 🔴
**Status**: 📋 Planned  
**Description**: Service for matching paths against whitelist using Trie.

**Tasks**:
- [ ] Create `lib/services/path_matcher_service.dart`
- [ ] Implement `loadWhitelist()` to build Trie from database
- [ ] Implement `isWhitelisted(String path)` using Trie lookup
- [ ] Implement `rebuildTrie()` after whitelist changes
- [ ] Handle path normalization before Trie queries
- [ ] Add caching for frequently queried paths (optional optimization)
- [ ] Write unit tests with various path scenarios
- [ ] Benchmark performance with 10K whitelist items

**Dependencies**: 1.3, 1.4, 2.1  
**Estimated Time**: 5 hours

---

### 2.4 ScanRootService 🔴
**Status**: 📋 Planned  
**Description**: Business logic for scan root directory management.

**Tasks**:
- [ ] Create `lib/services/scan_root_service.dart`
- [ ] Implement `addScanRoot(String path)` with validation
- [ ] Implement `removeScanRoot(int id)`
- [ ] Implement `toggleScanRoot(int id, bool enabled)`
- [ ] Implement `getAllScanRoots()`
- [ ] Implement `getEnabledScanRoots()`
- [ ] Add default scan roots on first launch (platform-specific)
- [ ] Write unit tests for all methods

**Dependencies**: 1.3  
**Estimated Time**: 4 hours

---

## Phase 3: Scan Engine (M2)

### 3.1 Filesystem Scanner Core 🔴
**Status**: 📋 Planned  
**Description**: Core filesystem traversal logic.

**Tasks**:
- [ ] Create `lib/services/scan/filesystem_scanner.dart`
- [ ] Implement iterative depth-first traversal (avoid stack overflow)
- [ ] Implement directory skipping when whitelisted path encountered
- [ ] Implement permission error handling (log and continue)
- [ ] Implement circular symlink detection using inode tracking
- [ ] Collect file metadata: path, size, modified time, type
- [ ] Write unit tests with mock filesystem
- [ ] Test with large directory structures (100K+ files)

**Dependencies**: 2.3  
**Estimated Time**: 10 hours

---

### 3.2 Isolate-based Parallel Scanning 🔴
**Status**: 📋 Planned  
**Description**: Parallel scanning using Dart Isolates for performance.

**Tasks**:
- [ ] Create `lib/services/scan/scan_isolate.dart`
- [ ] Implement Isolate spawn for each scan root
- [ ] Implement `SendPort`/`ReceivePort` communication for progress updates
- [ ] Send scan results in batches (every 1000 files)
- [ ] Implement cancellation mechanism
- [ ] Handle Isolate errors and crashes gracefully
- [ ] Write integration tests with multiple scan roots
- [ ] Benchmark performance: target > 10K files/second on SSD

**Dependencies**: 3.1  
**Estimated Time**: 12 hours

---

### 3.3 ScanService 🔴
**Status**: 📋 Planned  
**Description**: High-level scan orchestration service.

**Tasks**:
- [ ] Create `lib/services/scan_service.dart`
- [ ] Implement `startScan(List<ScanRoot> roots)` launching Isolates
- [ ] Implement `cancelScan()` stopping all Isolates
- [ ] Aggregate results from multiple Isolates
- [ ] Emit progress updates via Stream
- [ ] Emit scan results via Stream
- [ ] Handle errors from Isolates
- [ ] Write integration tests for complete scan workflow

**Dependencies**: 3.2, 2.4  
**Estimated Time**: 8 hours

---

### 3.4 Scan Result Management 🔴
**Status**: 📋 Planned  
**Description**: Managing and filtering scan results.

**Tasks**:
- [ ] Create `lib/services/scan_result_service.dart`
- [ ] Implement in-memory storage for current scan results
- [ ] Implement `sortResults(SortBy sortBy)` with options: size, time, path
- [ ] Implement `filterResults(FilterCriteria criteria)` for search and filtering
- [ ] Implement `clearResults()`
- [ ] Implement `removeResult(String path)` when added to whitelist
- [ ] Write unit tests for sorting and filtering logic

**Dependencies**: 1.2  
**Estimated Time**: 4 hours

---

## Phase 4: State Management (M3)

### 4.1 Riverpod Providers Setup 🔴
**Status**: 📋 Planned  
**Description**: Set up Riverpod providers for state management.

**Tasks**:
- [ ] Create `lib/providers/database_provider.dart` for database instance
- [ ] Create `lib/providers/whitelist_provider.dart` for whitelist state
- [ ] Create `lib/providers/group_provider.dart` for group tree state
- [ ] Create `lib/providers/scan_provider.dart` for scan state and progress
- [ ] Create `lib/providers/scan_result_provider.dart` for scan results
- [ ] Create `lib/providers/scan_root_provider.dart` for scan roots
- [ ] Create `lib/providers/settings_provider.dart` for app settings
- [ ] Add proper provider dependencies and lifecycle management

**Dependencies**: 2.1, 2.2, 2.3, 2.4, 3.3, 3.4  
**Estimated Time**: 6 hours

---

### 4.2 Scan State Management 🔴
**Status**: 📋 Planned  
**Description**: Manage scan progress and results state.

**Tasks**:
- [ ] Create `lib/providers/scan_state.dart` with ScanState class
- [ ] Define states: idle, scanning, completed, error
- [ ] Track progress: files scanned, non-whitelisted items found, current path
- [ ] Implement StateNotifier for scan state updates
- [ ] Listen to ScanService streams and update state
- [ ] Write unit tests for state transitions

**Dependencies**: 3.3, 4.1  
**Estimated Time**: 4 hours

---

## Phase 5: User Interface (M3)

### 5.1 Main App Structure 🔴
**Status**: 📋 Planned  
**Description**: Set up main app structure and navigation.

**Tasks**:
- [ ] Create `lib/main.dart` with MaterialApp setup
- [ ] Add ProviderScope for Riverpod
- [ ] Create `lib/ui/app.dart` with bottom navigation bar
- [ ] Define 3 tabs: Scan, Whitelist, Settings
- [ ] Implement navigation between tabs
- [ ] Add app theme (light/dark mode support)
- [ ] Set up internationalization with `intl` package

**Dependencies**: 4.1  
**Estimated Time**: 4 hours

---

### 5.2 Scan Page UI 🔴
**Status**: 📋 Planned  
**Description**: Implement the scan page interface.

**Tasks**:
- [ ] Create `lib/ui/pages/scan_page.dart`
- [ ] Implement top section: scan root list (horizontal scroll)
- [ ] Implement "Start Scan" button with loading state
- [ ] Implement middle section: progress bar and statistics
- [ ] Implement bottom section: scan results list
- [ ] Add pull-to-refresh for results list
- [ ] Implement item actions: Add to Whitelist, Delete
- [ ] Implement batch selection mode with toolbar
- [ ] Add empty state when no results
- [ ] Write widget tests for all components

**Dependencies**: 4.2, 5.1  
**Estimated Time**: 12 hours

---

### 5.3 Whitelist Management Page UI 🔴
**Status**: 📋 Planned  
**Description**: Implement the whitelist management interface.

**Tasks**:
- [ ] Create `lib/ui/pages/whitelist_page.dart`
- [ ] Implement search bar with real-time filtering
- [ ] Implement "Add Item" and "Create Group" buttons
- [ ] Implement tree view with collapsible groups
- [ ] Display group metadata: name, note, item count
- [ ] Display item metadata: path, custom name, note
- [ ] Implement long-press/right-click context menu
- [ ] Implement drag-and-drop for moving items (desktop only)
- [ ] Add dialogs for add/edit/delete operations
- [ ] Write widget tests for all components

**Dependencies**: 4.1, 5.1  
**Estimated Time**: 14 hours

---

### 5.4 Settings Page UI 🔴
**Status**: 📋 Planned  
**Description**: Implement the settings interface.

**Tasks**:
- [ ] Create `lib/ui/pages/settings_page.dart`
- [ ] Implement scan root management section
- [ ] Add directory picker for adding scan roots
- [ ] Implement enable/disable toggles for scan roots
- [ ] Implement data management section: export/import/clear
- [ ] Implement about section: version, license, GitHub link
- [ ] Add confirmation dialogs for destructive actions
- [ ] Write widget tests for all components

**Dependencies**: 4.1, 5.1  
**Estimated Time**: 8 hours

---

### 5.5 Reusable UI Components 🔴
**Status**: 📋 Planned  
**Description**: Create reusable widgets for consistent UI.

**Tasks**:
- [ ] Create `lib/ui/widgets/file_item_card.dart` for displaying file/directory items
- [ ] Create `lib/ui/widgets/group_tree_node.dart` for tree view nodes
- [ ] Create `lib/ui/widgets/progress_indicator.dart` for scan progress
- [ ] Create `lib/ui/widgets/confirmation_dialog.dart` for confirmations
- [ ] Create `lib/ui/widgets/input_dialog.dart` for text input
- [ ] Create `lib/ui/widgets/empty_state.dart` for empty lists
- [ ] Write widget tests for all components

**Dependencies**: None  
**Estimated Time**: 6 hours

---

## Phase 6: Platform-Specific Features (M4)

### 6.1 Windows Recycle Bin 🔴
**Status**: 📋 Planned  
**Description**: Implement Windows recycle bin functionality.

**Tasks**:
- [ ] Create `windows/runner/recycle_bin_windows.cpp`
- [ ] Implement `IFileOperation` COM interface wrapper
- [ ] Implement `moveToRecycleBin(String path)` method
- [ ] Create `lib/platform/recycle_bin_windows.dart` with MethodChannel
- [ ] Handle errors: file not found, access denied, etc.
- [ ] Test on Windows 10 and Windows 11
- [ ] Write platform tests

**Dependencies**: None  
**Estimated Time**: 8 hours

---

### 6.2 Linux Trash Implementation 🔴
**Status**: 📋 Planned  
**Description**: Implement Linux trash functionality (FreeDesktop standard).

**Tasks**:
- [ ] Create `lib/platform/recycle_bin_linux.dart`
- [ ] Implement move to `~/.local/share/Trash/files/`
- [ ] Create `.trashinfo` file in `~/.local/share/Trash/info/`
- [ ] Handle errors: permission denied, disk full, etc.
- [ ] Test on Ubuntu, Fedora, Arch Linux
- [ ] Write platform tests

**Dependencies**: None  
**Estimated Time**: 6 hours

---

### 6.3 Android Direct Deletion 🔴
**Status**: 📋 Planned  
**Description**: Implement direct file deletion for Android (MVP).

**Tasks**:
- [ ] Create `lib/platform/recycle_bin_android.dart`
- [ ] Implement `deleteFile(String path)` using Dart `File.delete()`
- [ ] Handle errors: file not found, permission denied, etc.
- [ ] Test on Android 10, 11, 12, 13
- [ ] Write platform tests

**Dependencies**: None  
**Estimated Time**: 3 hours

---

### 6.4 Platform Abstraction 🔴
**Status**: 📋 Planned  
**Description**: Create platform-agnostic interface for deletion.

**Tasks**:
- [ ] Create `lib/platform/recycle_bin.dart` with abstract class
- [ ] Implement factory pattern to select platform implementation
- [ ] Create `lib/services/deletion_service.dart` using platform abstraction
- [ ] Implement batch deletion with progress reporting
- [ ] Handle partial failures (some files deleted, some failed)
- [ ] Write unit tests with mock platform implementations

**Dependencies**: 6.1, 6.2, 6.3  
**Estimated Time**: 4 hours

---

### 6.5 Android Permissions 🔴
**Status**: 📋 Planned  
**Description**: Handle Android runtime permissions.

**Tasks**:
- [ ] Add permissions to `android/app/src/main/AndroidManifest.xml`
- [ ] Create `lib/services/permission_service.dart`
- [ ] Implement `requestStoragePermission()` for Android < 11
- [ ] Implement `requestManageExternalStorage()` for Android 11+
- [ ] Show permission rationale dialog
- [ ] Handle permission denied scenarios
- [ ] Test on Android 10, 11, 12, 13

**Dependencies**: None  
**Estimated Time**: 5 hours

---

## Phase 7: Integration & Testing (M5)

### 7.1 End-to-End Integration Tests 🔴
**Status**: 📋 Planned  
**Description**: Test complete workflows from UI to database.

**Tasks**:
- [ ] Set up integration test environment
- [ ] Test workflow: Add whitelist item → Scan → Verify item not in results
- [ ] Test workflow: Scan → Add to whitelist → Verify removed from results
- [ ] Test workflow: Scan → Delete → Verify file deleted
- [ ] Test workflow: Create group → Add items → Move items
- [ ] Test workflow: Export whitelist → Clear data → Import whitelist
- [ ] Test error scenarios: permission denied, disk full, etc.
- [ ] Run tests on all platforms

**Dependencies**: All previous phases  
**Estimated Time**: 12 hours

---

### 7.2 Performance Optimization 🟡
**Status**: 📋 Planned  
**Description**: Optimize app performance to meet requirements.

**Tasks**:
- [ ] Profile app startup time (target < 2s)
- [ ] Profile scan speed (target > 10K files/s on SSD)
- [ ] Profile Trie query time (target < 1μs)
- [ ] Profile UI frame rate during scan (target 60 FPS)
- [ ] Optimize database queries with indexes
- [ ] Optimize Trie memory usage
- [ ] Reduce widget rebuilds with proper Riverpod usage
- [ ] Run performance tests on low-end devices

**Dependencies**: 7.1  
**Estimated Time**: 10 hours

---

### 7.3 UI/UX Polish 🟡
**Status**: 📋 Planned  
**Description**: Improve user experience and visual design.

**Tasks**:
- [ ] Add loading indicators for all async operations
- [ ] Add success/error snackbars for user actions
- [ ] Improve error messages with actionable suggestions
- [ ] Add animations for list insertions/deletions
- [ ] Add haptic feedback for mobile (optional)
- [ ] Improve accessibility: screen reader support, contrast ratios
- [ ] Test on different screen sizes and orientations
- [ ] Gather user feedback and iterate

**Dependencies**: 5.2, 5.3, 5.4  
**Estimated Time**: 8 hours

---

### 7.4 Bug Fixes 🔴
**Status**: 📋 Planned  
**Description**: Fix all critical and high-priority bugs.

**Tasks**:
- [ ] Set up bug tracking system (GitHub Issues)
- [ ] Triage all reported bugs by severity
- [ ] Fix all critical bugs (crashes, data loss)
- [ ] Fix all high-priority bugs (major functionality broken)
- [ ] Verify fixes with regression tests
- [ ] Update documentation for known issues

**Dependencies**: 7.1  
**Estimated Time**: Variable (reserve 1 week)

---

## Phase 8: Documentation & Release (M6)

### 8.1 User Guide 🔴
**Status**: 📋 Planned  
**Description**: Write comprehensive user documentation.

**Tasks**:
- [ ] Create `docs/user-guide.md`
- [ ] Document first-time setup process
- [ ] Document how to add/manage whitelist items
- [ ] Document how to create/manage groups
- [ ] Document how to configure scan roots
- [ ] Document how to perform scans
- [ ] Document how to delete files
- [ ] Document how to export/import whitelist
- [ ] Add screenshots for each major feature
- [ ] Translate to Simplified Chinese

**Dependencies**: None  
**Estimated Time**: 6 hours

---

### 8.2 Developer Documentation 🔴
**Status**: 📋 Planned  
**Description**: Write technical documentation for developers.

**Tasks**:
- [ ] Create `docs/architecture.md` with architecture diagrams
- [ ] Create `docs/database-schema.sql` with complete schema
- [ ] Create `docs/api-documentation.md` with service APIs
- [ ] Document build and deployment process
- [ ] Document testing strategy and how to run tests
- [ ] Document contribution guidelines
- [ ] Generate dartdoc API documentation

**Dependencies**: None  
**Estimated Time**: 8 hours

---

### 8.3 Packaging & Signing 🔴
**Status**: 📋 Planned  
**Description**: Package app for distribution.

**Tasks**:
- [ ] Configure Android app signing (keystore)
- [ ] Build Android APK: `flutter build apk --release`
- [ ] Build Android AAB: `flutter build appbundle --release`
- [ ] Build Windows executable: `flutter build windows --release`
- [ ] Build Linux AppImage or deb package
- [ ] Test all builds on target platforms
- [ ] Create installation instructions for each platform

**Dependencies**: 7.4  
**Estimated Time**: 6 hours

---

### 8.4 Release Testing 🔴
**Status**: 📋 Planned  
**Description**: Final testing before release.

**Tasks**:
- [ ] Perform smoke tests on all platforms
- [ ] Test installation process on clean systems
- [ ] Verify all MVP features work correctly
- [ ] Check for memory leaks and performance issues
- [ ] Verify internationalization works correctly
- [ ] Test on various devices and OS versions
- [ ] Create release notes

**Dependencies**: 8.3  
**Estimated Time**: 8 hours

---

## Post-MVP Features (Future Versions)

### F1. Android Recycle Bin 🟢
**Status**: 📋 Planned  
**Description**: Implement recycle bin functionality for Android using isolation directory.

**Tasks**:
- [ ] Design isolation directory structure
- [ ] Implement move to isolation directory
- [ ] Implement restore from isolation directory
- [ ] Implement permanent deletion from isolation directory
- [ ] Add UI for managing isolated files
- [ ] Add auto-cleanup of old isolated files (configurable retention period)

**Dependencies**: MVP complete  
**Estimated Time**: 2 weeks

---

### F2. Incremental Scanning 🟢
**Status**: 📋 Planned  
**Description**: Monitor filesystem changes and perform incremental scans.

**Tasks**:
- [ ] Implement inotify wrapper for Linux
- [ ] Implement FSEvents wrapper for macOS (if supported in future)
- [ ] Implement FileSystemWatcher for Windows
- [ ] Implement FileObserver for Android
- [ ] Handle event coalescing and debouncing
- [ ] Update scan results incrementally
- [ ] Add UI toggle for enabling/disabling monitoring

**Dependencies**: MVP complete  
**Estimated Time**: 3 weeks

---

### F3. Duplicate File Detection 🟢
**Status**: 📋 Planned  
**Description**: Find and manage duplicate files based on content hash.

**Tasks**:
- [ ] Implement file hashing (SHA-256) with progress reporting
- [ ] Implement duplicate detection algorithm
- [ ] Add UI for viewing duplicate groups
- [ ] Add smart deletion suggestions (keep newest, largest, etc.)
- [ ] Implement batch deletion of duplicates
- [ ] Add option to automatically add duplicates to whitelist

**Dependencies**: MVP complete  
**Estimated Time**: 3 weeks

---

### F4. Scheduled Auto-Scan 🟢
**Status**: 📋 Planned  
**Description**: Schedule automatic scans at specified intervals.

**Tasks**:
- [ ] Implement background task scheduling (WorkManager for Android, Task Scheduler for Windows)
- [ ] Add UI for configuring scan schedule
- [ ] Implement notification system for scan results
- [ ] Add option to auto-delete files matching certain criteria
- [ ] Implement scan history and logs

**Dependencies**: MVP complete  
**Estimated Time**: 2 weeks

---

### F5. Cloud Whitelist Sync 🟢
**Status**: 📋 Planned  
**Description**: Synchronize whitelist across multiple devices via cloud.

**Tasks**:
- [ ] Design cloud sync protocol
- [ ] Implement backend API (Firebase, custom server, etc.)
- [ ] Implement conflict resolution strategy
- [ ] Add UI for enabling/disabling sync
- [ ] Implement end-to-end encryption for privacy
- [ ] Add device management UI

**Dependencies**: MVP complete  
**Estimated Time**: 4 weeks

---

### F6. Advanced Filtering 🟢
**Status**: 📋 Planned  
**Description**: Add advanced filtering options for scan results.

**Tasks**:
- [ ] Implement file type filtering (by extension)
- [ ] Implement size range filtering
- [ ] Implement date range filtering (created, modified, accessed)
- [ ] Implement regular expression matching for paths
- [ ] Add UI for filter builder
- [ ] Save and load filter presets

**Dependencies**: MVP complete  
**Estimated Time**: 2 weeks

---

### F7. Statistics and Visualization 🟢
**Status**: 📋 Planned  
**Description**: Visualize disk usage and cleanup history.

**Tasks**:
- [ ] Implement disk usage analysis
- [ ] Create pie chart for file type distribution
- [ ] Create bar chart for largest directories
- [ ] Implement cleanup history tracking
- [ ] Create timeline chart for cleanup history
- [ ] Add export statistics to CSV/PDF

**Dependencies**: MVP complete  
**Estimated Time**: 3 weeks

---

### F8. Automation Rules 🟢
**Status**: 📋 Planned  
**Description**: Create rules for automatic cleanup based on patterns.

**Tasks**:
- [ ] Design rule engine architecture
- [ ] Implement pattern matching (wildcards, regex)
- [ ] Implement rule conditions (file age, size, type, etc.)
- [ ] Implement rule actions (delete, move, whitelist)
- [ ] Add UI for rule builder
- [ ] Implement rule testing and preview
- [ ] Add rule import/export

**Dependencies**: MVP complete  
**Estimated Time**: 4 weeks

---

## Summary

**Total MVP Tasks**: ~80 tasks  
**Estimated MVP Time**: 10 weeks (as per milestones)  
**Post-MVP Features**: 8 major features  
**Estimated Post-MVP Time**: ~23 weeks

**Critical Path**: 0.1 → 0.3 → 1.1 → 1.3 → 1.4 → 2.3 → 3.1 → 3.2 → 3.3 → 4.1 → 4.2 → 5.1 → 5.2 → 6.4 → 7.1 → 7.4 → 8.3 → 8.4

---

## Notes

- All tasks should be tracked in GitHub Issues with appropriate labels
- Each completed task should have associated tests
- Code reviews are required before merging to main branch
- Follow AGENTS.md guidelines for all code contributions
- Update this TODO list as new tasks are identified or priorities change
