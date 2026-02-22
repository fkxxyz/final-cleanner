import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WhitelistItem {
  final String path;
  final String? name;
  final bool isDirectory;
  final String? groupId;

  const WhitelistItem({
    required this.path,
    this.name,
    required this.isDirectory,
    this.groupId,
  });
}

class WhitelistGroup {
  final String id;
  final String name;
  final String? note;
  final bool isExpanded;

  const WhitelistGroup({
    required this.id,
    required this.name,
    this.note,
    this.isExpanded = true,
  });
}

class WhitelistPage extends ConsumerStatefulWidget {
  const WhitelistPage({super.key});

  @override
  ConsumerState<WhitelistPage> createState() => _WhitelistPageState();
}

class _WhitelistPageState extends ConsumerState<WhitelistPage> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final Map<String, bool> _expandedGroups = {};

  final List<WhitelistGroup> _mockGroups = const [
    WhitelistGroup(
      id: 'g1',
      name: 'System Files',
      note: 'Critical system directories',
    ),
    WhitelistGroup(id: 'g2', name: 'Development', note: 'Project directories'),
    WhitelistGroup(id: 'g3', name: 'Personal'),
  ];

  final List<WhitelistItem> _mockItems = const [
    WhitelistItem(
      path: '/usr/bin',
      name: 'System binaries',
      isDirectory: true,
      groupId: 'g1',
    ),
    WhitelistItem(
      path: '/etc',
      name: 'Configuration files',
      isDirectory: true,
      groupId: 'g1',
    ),
    WhitelistItem(
      path: '/home/user/projects',
      isDirectory: true,
      groupId: 'g2',
    ),
    WhitelistItem(
      path: '/home/user/workspace',
      name: 'Work projects',
      isDirectory: true,
      groupId: 'g2',
    ),
    WhitelistItem(
      path: '/home/user/documents/important.txt',
      isDirectory: false,
      groupId: 'g3',
    ),
    WhitelistItem(
      path: '/home/user/downloads/keep.zip',
      name: 'Archive to keep',
      isDirectory: false,
    ),
    WhitelistItem(path: '/tmp/persistent', isDirectory: true),
  ];

  @override
  void initState() {
    super.initState();
    for (final group in _mockGroups) {
      _expandedGroups[group.id] = group.isExpanded;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WhitelistItem> _getFilteredItems() {
    if (_searchQuery.isEmpty) {
      return _mockItems;
    }
    return _mockItems.where((item) {
      final pathMatch = item.path.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final nameMatch =
          item.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
          false;
      return pathMatch || nameMatch;
    }).toList();
  }

  List<WhitelistItem> _getItemsForGroup(String? groupId) {
    return _getFilteredItems()
        .where((item) => item.groupId == groupId)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _getFilteredItems();
    final hasItems = _mockItems.isNotEmpty;

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
      body: hasItems
          ? _buildWhitelistContent(filteredItems)
          : _buildEmptyState(),
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

  Widget _buildWhitelistContent(List<WhitelistItem> filteredItems) {
    return ListView(
      children: [
        for (final group in _mockGroups)
          _buildGroupSection(group, filteredItems),
        _buildUngroupedSection(filteredItems),
      ],
    );
  }

  Widget _buildGroupSection(
    WhitelistGroup group,
    List<WhitelistItem> filteredItems,
  ) {
    final items = _getItemsForGroup(group.id);
    if (items.isEmpty && _searchQuery.isNotEmpty) {
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: group.note != null ? Text(group.note!) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${items.length} items',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              IconButton(
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expandedGroups[group.id] = !isExpanded;
                  });
                },
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _expandedGroups[group.id] = !isExpanded;
            });
          },
        ),
        if (isExpanded) ...items.map((item) => _buildWhitelistItemTile(item)),
        const Divider(),
      ],
    );
  }

  Widget _buildUngroupedSection(List<WhitelistItem> filteredItems) {
    final items = _getItemsForGroup(null);
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.folder_off),
          title: Text(
            'Ungrouped',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            '${items.length} items',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        ...items.map((item) => _buildWhitelistItemTile(item)),
      ],
    );
  }

  Widget _buildWhitelistItemTile(WhitelistItem item) {
    return Dismissible(
      key: Key(item.path),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {},
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.create_new_folder),
              title: const Text('Add Group'),
              onTap: () {
                Navigator.pop(context);
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move),
              title: const Text('Move to Group'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
