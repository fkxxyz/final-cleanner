# Final Cleaner - MVP Requirements Document

**Version**: 1.0.0-MVP  
**Date**: 2026-02-23  
**Status**: Design Phase

## Project Overview

Final Cleaner is a whitelist-driven file management tool designed for power users to maintain complete control over their Android/Windows/Linux systems by maintaining a whitelist and scanning/removing non-whitelisted files.

## Target Users

- Power users / Technical users
- Users who need complete control over system files
- Users who want to clean application residuals and junk files
- Users with high privacy and data control requirements

## Core Value Proposition

"Empower power users to take complete control of data on their phones or computers, eliminating all the crap left by applications!"

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **Database**: SQLite (sqflite + drift)
- **State Management**: Riverpod 2.x
- **Platforms**: Android, Windows, Linux

## MVP Feature Scope

### 1. Whitelist Management (Core Feature)

#### 1.1 Whitelist Item CRUD
- **Add Whitelist Item**
  - Support files and directories
  - Required: path
  - Optional: custom name, note
  - Path validation: check if path exists
  - Deduplication: same path cannot be added twice

- **Edit Whitelist Item**
  - Modify custom name
  - Modify note
  - Path modification not allowed (must delete and re-add)

- **Delete Whitelist Item**
  - Single deletion
  - Batch deletion
  - Deletion confirmation dialog

- **View Whitelist Items**
  - List view displaying all whitelist items
  - Display: path, custom name, note, type (file/directory)
  - Support search and filtering

#### 1.2 Tree-based Group Management
- **Create Group**
  - Support multi-level nested groups
  - Required: group name
  - Optional: group note

- **Edit Group**
  - Modify group name
  - Modify group note

- **Delete Group**
  - Delete empty group: direct deletion
  - Delete non-empty group: prompt user to choose (delete all children / move children to parent group / cancel)

- **Move Whitelist Items**
  - Move whitelist items to other groups
  - Support drag-and-drop (optional, desktop only)

- **Tree View**
  - Collapsible/expandable tree structure
  - Display item count for each group
  - Support multi-selection

### 2. Scan Functionality

#### 2.1 Scan Root Directory Configuration
- **Add Scan Root Directory**
  - Manual path input
  - File picker for directory selection
  - Path validation

- **Manage Scan Root Directories**
  - List all scan root directories
  - Enable/disable toggle
  - Delete scan root directory

- **Default Scan Root Directories**
  - Android: `/storage/emulated/0` (internal storage)
  - Windows: `C:\Users\{username}`
  - Linux: `/home/{username}`

#### 2.2 Filesystem Scanning
- **Scan Execution**
  - Click "Start Scan" button to initiate
  - Only scan enabled scan root directories
  - Parallel scanning of multiple root directories (using Dart Isolate)

- **Scan Strategy**
  - Iterative depth-first traversal
  - Skip entire subtree when encountering whitelisted directory
  - Skip directories without access permission (log error but continue)
  - Detect circular symbolic links

- **Progress Reporting**
  - Real-time scan progress display
  - Files scanned count
  - Non-whitelisted items found count
  - Current scanning path
  - Update UI every 1000 files

- **Error Handling**
  - Permission errors: log but don't interrupt scan
  - I/O errors: log error path, continue scanning
  - Display error log (optional view)

#### 2.3 Scan Results Display
- **Results List**
  - Display all non-whitelisted items
  - Information: path, size, modified time, type
  - Default sort by size descending
  - Support multiple sort methods (size, time, path)

- **Search and Filter**
  - Search by path
  - Filter by file type
  - Filter by size range

- **Batch Operations**
  - Select all / Deselect all
  - Multi-selection mode
  - Batch add to whitelist
  - Batch delete

### 3. Cleanup Functionality

#### 3.1 Delete Operations
- **Single Delete**
  - Click delete button from scan results list
  - Confirmation dialog displays file information

- **Batch Delete**
  - Click "Delete Selected" after selecting multiple items
  - Confirmation dialog displays: total file count, total size
  - Display deletion progress

- **Platform-Specific Implementation**
  - **Windows**: Use `IFileOperation` COM interface to move to recycle bin
  - **Linux**: Move to `~/.local/share/Trash/files/` (FreeDesktop standard)
  - **Android**: Direct deletion (no recycle bin in MVP phase)

- **Deletion Results**
  - Display successfully deleted file count
  - Display freed disk space
  - Display failed items (if any)

#### 3.2 Add to Whitelist
- **Add from Scan Results**
  - Click "Add to Whitelist" button
  - Dialog popup:
    - Auto-fill path (non-editable)
    - Input custom name (optional, defaults to file/directory name)
    - Input note (optional)
    - Select group (defaults to root group)
  - Immediately remove from scan results after confirmation

### 4. User Interface

#### 4.1 Main Interface Structure
- **Bottom Navigation Bar** (3 tabs)
  1. Scan Page (home)
  2. Whitelist Management Page
  3. Settings Page

#### 4.2 Scan Page
- **Top Section**
  - Scan root directory list (horizontal scroll)
  - Each root displays: path, enabled status
  - "Start Scan" button (large and prominent)

- **Middle Section**
  - Scan progress bar
  - Real-time statistics:
    - Files scanned count
    - Non-whitelisted items found count
    - Current scanning path

- **Bottom Section**
  - Scan results list
  - Each item displays: path, size, modified time
  - Action buttons: Add to Whitelist, Delete
  - Batch operation toolbar (shown when items selected)

#### 4.3 Whitelist Management Page
- **Top Section**
  - Search bar
  - "Add Whitelist Item" button
  - "Create Group" button

- **Main Section**
  - Tree view displaying group structure
  - Collapsible/expandable
  - Each group displays: name, note, item count
  - Each whitelist item displays: path, custom name, note

- **Action Menu**
  - Long press / right-click shows context menu
  - Group actions: Edit, Delete, Create Subgroup
  - Whitelist item actions: Edit, Delete, Move to Other Group

#### 4.4 Settings Page
- **Scan Root Directory Management**
  - List all scan root directories
  - Add / Delete / Enable / Disable

- **Data Management**
  - Export whitelist (JSON format)
  - Import whitelist (JSON format)
  - Clear all data (requires confirmation)

- **About**
  - App version
  - Open source license
  - GitHub link

### 5. Data Persistence

#### 5.1 Database Structure
- **whitelist_items table**
  - id, path, name, note, is_directory, created_at, updated_at

- **groups table**
  - id, name, note, created_at

- **group_closure table** (closure table)
  - ancestor, descendant, depth

- **item_group_relations table**
  - item_id, group_id

- **scan_roots table**
  - id, path, enabled

#### 5.2 In-Memory Trie
- Build Trie from database whitelist on startup
- Rebuild Trie after whitelist modifications
- Support prefix matching (if parent directory is whitelisted, all children are automatically whitelisted)

### 6. Permission Management

#### 6.1 Android
- `READ_EXTERNAL_STORAGE`
- `WRITE_EXTERNAL_STORAGE`
- `MANAGE_EXTERNAL_STORAGE` (Android 11+)
- Runtime permission requests

#### 6.2 Windows
- No special permissions required
- May need administrator privileges when accessing system directories (user handles)

#### 6.3 Linux
- No special permissions required
- User permissions needed when accessing protected directories

## Features NOT Included in MVP

The following features will be implemented in future versions:

1. **Android Recycle Bin Functionality**
   - Isolation directory implementation
   - Restore deleted files

2. **Incremental Scanning**
   - Filesystem monitoring (inotify/FSEvents)
   - Scan only changed portions

3. **Duplicate File Detection**
   - Hash-based duplicate file finding
   - Smart deduplication suggestions

4. **Scheduled Auto-Scan**
   - Background scheduled tasks
   - Scan result notifications

5. **Cloud Whitelist Sync**
   - Multi-device synchronization
   - Cloud backup

6. **Advanced Filtering**
   - Filter by file type
   - Filter by size range
   - Filter by time range
   - Regular expression matching

7. **Statistics and Visualization**
   - Disk usage charts
   - Cleanup history
   - File type distribution

8. **Automation Rules**
   - Rule-based auto-cleanup
   - Whitelist pattern matching (wildcards)

## Performance Requirements

- **Startup Time**: < 2 seconds (including loading 10K whitelist items)
- **Scan Speed**: > 10K files/second on SSD
- **Trie Query**: < 1μs per path query
- **UI Responsiveness**: Maintain 60 FPS during scan (use Isolates for heavy work)

## Security Requirements

1. **No Root/Admin Required** (for normal use)
2. **Confirmation Required Before Batch Deletion**
3. **Auto-backup Whitelist Before Major Operations**
4. **Path Validation to Prevent Path Traversal Attacks**

## User Experience Requirements

1. **First-time Use Guidance**
   - Guide users to add scan root directories
   - Prompt to add important directories to whitelist first

2. **Friendly Error Messages**
   - Clear error information
   - Provide solution suggestions

3. **Reversible Operations**
   - Deletion uses recycle bin (Windows/Linux)
   - Whitelist modifications recoverable (via backup)

4. **Responsive Design**
   - Adapt to different screen sizes
   - Desktop supports window resizing

## Internationalization

- **Default Language**: English
- **MVP Supported Languages**: English, Simplified Chinese
- **All User-Facing Strings Must Be Internationalized**

## Testing Requirements

1. **Unit Tests**: 100% coverage of service layer logic
2. **Widget Tests**: Critical UI components
3. **Integration Tests**: Complete scan → cleanup workflow
4. **Platform Tests**: Recycle bin operations on each platform

## Deliverables

1. **Source Code**
   - Complete Flutter project
   - Compliant with AGENTS.md specifications

2. **Executables**
   - Android APK
   - Windows executable
   - Linux AppImage/deb

3. **Documentation**
   - User guide
   - Developer documentation
   - API documentation

4. **Test Reports**
   - Unit test coverage report
   - Integration test results

## Milestones

### M1: Data Layer and Service Layer (2 weeks)
- Database design and implementation
- In-memory Trie implementation
- WhitelistService implementation
- PathMatcherService implementation
- Unit tests

### M2: Scan Engine (2 weeks)
- ScanService implementation
- Isolate parallel scanning
- Progress reporting mechanism
- Error handling
- Unit tests and integration tests

### M3: User Interface (3 weeks)
- Main interface framework
- Scan page
- Whitelist management page
- Settings page
- Widget tests

### M4: Platform-Specific Features (1 week)
- Windows recycle bin implementation
- Linux recycle bin implementation
- Android permission handling
- Platform tests

### M5: Integration and Optimization (1 week)
- End-to-end integration tests
- Performance optimization
- UI/UX optimization
- Bug fixes

### M6: Release Preparation (1 week)
- Documentation refinement
- Packaging and signing
- Release testing
- User guide

**Total**: 10 weeks

## Risks and Mitigation

### Risk 1: Android Permission Restrictions
- **Description**: Android 11+ Scoped Storage restricts file access
- **Mitigation**: Request `MANAGE_EXTERNAL_STORAGE` permission, provide clear permission explanation

### Risk 2: Insufficient Scan Performance
- **Description**: Slow scan speed with large number of files
- **Mitigation**: Use Isolate parallel scanning, optimize Trie query algorithm

### Risk 3: Accidental Deletion of Important Files
- **Description**: Users may accidentally delete important files
- **Mitigation**: Use recycle bin, confirm before batch deletion, provide first-time use guidance

### Risk 4: Cross-Platform Compatibility Issues
- **Description**: Filesystem differences across platforms
- **Mitigation**: Thorough platform testing, path normalization handling

## Success Criteria

1. **Feature Completeness**: All MVP features work properly
2. **Performance Met**: Meet performance requirements
3. **Test Coverage**: Unit test coverage > 90%
4. **User Experience**: Friendly interface, smooth operation
5. **Stability**: No critical bugs, crash rate < 0.1%

## Appendix

### A. Database Schema

See `docs/database-schema.sql`

### B. API Documentation

See `docs/api-documentation.md`

### C. User Guide

See `docs/user-guide.md`
