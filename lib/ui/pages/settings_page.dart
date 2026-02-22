import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers/providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final scanRootsAsync = ref.watch(scanRootsProvider);

    return scanRootsAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Center(child: Text('Error: $error')),
      ),
      data: (scanRoots) => Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          children: [
            _buildScanRootsSection(context, scanRoots),
            const Divider(),
            _buildWhitelistSection(context),
            const Divider(),
            _buildLanguageSection(context),
            const Divider(),
            _buildDangerZoneSection(context),
            const Divider(),
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScanRootsSection(
    BuildContext context,
    List<ScanRoot> scanRoots,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Scan Root Directories',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ...scanRoots.map(
          (root) => Dismissible(
            key: Key('scan_root_${root.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Scan Root'),
                  content: Text('Remove "${root.path}" from scan roots?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) async {
              await ref.read(scanRootServiceProvider).deleteScanRoot(root.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Removed ${root.path}')),
                );
              }
            },
            child: SwitchListTile(
              title: Text(root.path),
              subtitle: Text(root.enabled ? 'Enabled' : 'Disabled'),
              value: root.enabled,
              onChanged: (value) {
                ref.read(scanRootServiceProvider).toggleScanRoot(
                      root.id,
                      enabled: value,
                    );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: FilledButton.tonalIcon(
            onPressed: () => _showAddScanRootDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Scan Root'),
          ),
        ),
      ],
    );
  }

  Widget _buildWhitelistSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Whitelist Management',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.upload_file),
          title: const Text('Export Whitelist'),
          subtitle: const Text('Save whitelist to file'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _exportWhitelist(context),
        ),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Import Whitelist'),
          subtitle: const Text('Load whitelist from file'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _importWhitelist(context),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Preferences',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: const Text('English'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(context),
        ),
      ],
    );
  }

  Widget _buildDangerZoneSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Danger Zone',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.delete_forever,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            'Clear All Data',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          subtitle: const Text('Delete all whitelist items and settings'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showClearDataDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'About',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('Final Cleanner'),
          subtitle: Text('Version 1.0.0'),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'A whitelist-driven file management tool for power users to maintain complete control over their systems.',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
  void _showLanguageDialog(BuildContext context) {
    var selectedLanguage = 'en';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Select Language'),
          content: RadioGroup<String>(
            groupValue: selectedLanguage,
            onChanged: (value) {
              if (value != null) {
                setDialogState(() => selectedLanguage = value);
              }
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(title: Text('English'), value: 'en'),
                RadioListTile<String>(title: Text('简体中文'), value: 'zh'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, selectedLanguage),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete all whitelist items, groups, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _clearAllData(context),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _showAddScanRootDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Scan Root'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Directory Path',
            hintText: '/path/to/directory',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final path = controller.text.trim();
              if (path.isEmpty) return;
              Navigator.pop(context);
              try {
                await ref.read(scanRootServiceProvider).addScanRoot(path);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added scan root: $path')),
                  );
                }
              } on ArgumentError catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportWhitelist(BuildContext context) async {
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Whitelist',
        fileName: 'whitelist.json',
      );
      if (result != null) {
        await ref.read(exportImportServiceProvider).exportToFile(result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Whitelist exported successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _importWhitelist(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (result != null && result.files.single.path != null) {
        await ref
            .read(exportImportServiceProvider)
            .importFromFile(result.files.single.path!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Whitelist imported successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _clearAllData(BuildContext context) async {
    Navigator.pop(context);
    try {
      final scanRoots =
          await ref.read(scanRootServiceProvider).getAllScanRoots();
      for (final root in scanRoots) {
        await ref.read(scanRootServiceProvider).deleteScanRoot(root.id);
      }
      final items = await ref.read(whitelistServiceProvider).getAllItems();
      for (final item in items) {
        await ref.read(whitelistServiceProvider).deleteItem(item.id);
      }
      final groups = await ref.read(groupServiceProvider).getRootGroups();
      for (final group in groups) {
        await ref
            .read(groupServiceProvider)
            .deleteGroupAndChildren(group.id);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data cleared')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Clear failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
