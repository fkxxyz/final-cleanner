import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../providers/providers.dart';
import '../../services/whitelist_service.dart';


class WhitelistPage extends ConsumerStatefulWidget {
  const WhitelistPage({super.key});

  @override
  ConsumerState<WhitelistPage> createState() => _WhitelistPageState();
}

class _WhitelistPageState extends ConsumerState<WhitelistPage> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<int, bool> _expandedGroups = {};



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WhitelistItem> _filterItems(List<WhitelistItem> items) {
    if (_searchQuery.isEmpty) return items;
    return items.where((item) {
      final pathMatch = item.path.toLowerCase().contains(_searchQuery.toLowerCase());
      final nameMatch = item.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
      return pathMatch || nameMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);
    final itemsAsync = ref.watch(whitelistItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search whitelist...',
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              )
            : const Text('Whitelist'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearching = true),
            ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (allItems) {
          if (allItems.isEmpty) return _buildEmptyState();
          return groupsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (groups) => _buildWhitelistContent(groups),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMenu,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No whitelist items yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to protect them from deletion',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildWhitelistContent(List<Group> groups) {
    return ListView(
      children: [
        for (final group in groups) _buildGroupSection(group),
        _buildUngroupedSection(),
      ],
    );
  }

  Widget _buildGroupSection(Group group) {
    final itemsAsync = ref.watch(groupItemsProvider(group.id));
    return itemsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => ListTile(title: Text('Error: $err')),
      data: (items) {
        final filteredItems = _filterItems(items);
        if (filteredItems.isEmpty && _searchQuery.isNotEmpty) {
          return const SizedBox.shrink();
        }
        final isExpanded = _expandedGroups[group.id] ?? true;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(isExpanded ? Icons.folder_open : Icons.folder),
              title: Text(
                group.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: group.note != null ? Text(group.note!) : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${filteredItems.length} items', style: Theme.of(context).textTheme.bodySmall),
                  IconButton(
                    icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: () => setState(() => _expandedGroups[group.id] = !isExpanded),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deleteGroup(group),
                  ),
                ],
              ),
              onTap: () => setState(() => _expandedGroups[group.id] = !isExpanded),
            ),
            if (isExpanded) ...filteredItems.map((item) => _buildWhitelistItemTile(item)),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildUngroupedSection() {
    final itemsAsync = ref.watch(ungroupedItemsProvider);
    return itemsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => ListTile(title: Text('Error: $err')),
      data: (items) {
        final filteredItems = _filterItems(items);
        if (filteredItems.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_off),
              title: Text(
                'Ungrouped',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Text('${filteredItems.length} items', style: Theme.of(context).textTheme.bodySmall),
            ),
            ...filteredItems.map((item) => _buildWhitelistItemTile(item)),
          ],
        );
      },
    );
  }

  Widget _buildWhitelistItemTile(WhitelistItem item) {
    return Dismissible(
      key: Key(item.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteItem(item),
      child: ListTile(
        leading: Icon(
          item.isDirectory ? Icons.folder : Icons.insert_drive_file,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          item.name ?? item.path.split('/').last,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: item.name != null
            ? Text(
                item.path,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showItemMenu(item),
        ),
        onTap: () {},
      ),
    );
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Item'),
              onTap: () {
                Navigator.pop(context);
                _showAddItemDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.create_new_folder),
              title: const Text('Add Group'),
              onTap: () {
                Navigator.pop(context);
                _showAddGroupDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showItemMenu(WhitelistItem item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _showEditItemDialog(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move),
              title: const Text('Move to Group'),
              onTap: () {
                Navigator.pop(context);
                _showMoveToGroupDialog(item);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
              title: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () {
                Navigator.pop(context);
                _deleteItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddItemDialog() {
    final pathController = TextEditingController();
    final nameController = TextEditingController();
    final noteController = TextEditingController();
    bool isDirectory = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pathController,
                decoration: const InputDecoration(labelText: 'Path *'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name (optional)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Is Directory'),
                value: isDirectory,
                onChanged: (value) => setDialogState(() => isDirectory = value),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                final path = pathController.text.trim();
                if (path.isEmpty) return;
                try {
                  await ref.read(whitelistServiceProvider).addItem(
                    path: path,
                    isDirectory: isDirectory,
                    name: nameController.text.trim().isEmpty ? null : nameController.text.trim(),
                    note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                  );
                  ref.invalidate(ungroupedItemsProvider);
                  if (mounted) Navigator.pop(context);
                } on DuplicatePathException {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Path already exists in whitelist')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGroupDialog() {
    final nameController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name *'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              try {
                await ref.read(groupServiceProvider).createGroup(
                  name: name,
                  note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                );
                ref.invalidate(groupsProvider);
                if (mounted) Navigator.pop(context);
              } on ArgumentError catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(WhitelistItem item) {
    final nameController = TextEditingController(text: item.name ?? '');
    final noteController = TextEditingController(text: item.note ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name (optional)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await ref.read(whitelistServiceProvider).updateItem(
                item.id,
                name: nameController.text.trim().isEmpty ? null : nameController.text.trim(),
                note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
              );
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showMoveToGroupDialog(WhitelistItem item) {
    final groupsAsync = ref.read(groupsProvider);
    groupsAsync.whenData((groups) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Move to Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: groups.map((group) => ListTile(
              title: Text(group.name),
              subtitle: group.note != null ? Text(group.note!) : null,
              onTap: () async {
                await ref.read(whitelistServiceProvider).updateItem(item.id, groupId: group.id);
                ref.invalidate(ungroupedItemsProvider);
                ref.invalidate(groupItemsProvider);
                if (mounted) Navigator.pop(context);
              },
            )).toList(),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
        ),
      );
    });
  }

  Future<void> _deleteItem(WhitelistItem item) async {
    await ref.read(whitelistServiceProvider).deleteItem(item.id);
    ref.invalidate(ungroupedItemsProvider);
    ref.invalidate(groupItemsProvider);
  }

  Future<void> _deleteGroup(Group group) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Delete group "${group.name}" and all its items?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(groupServiceProvider).deleteGroupAndChildren(group.id);
      ref.invalidate(groupsProvider);
      ref.invalidate(ungroupedItemsProvider);
    }
}

}