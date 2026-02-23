import 'package:flutter/material.dart';
import '../../models/directory_node.dart';
import '../../models/file_node.dart';
import '../../models/folder_node.dart';

class TreeNodeWidget extends StatefulWidget {
  final FolderNode? folder;
  final FileNode? file;
  final bool isSelected;
  final Function(String path, bool selected) onSelectionChanged;
  final Function(String path) onAddToWhitelist;
  final Function(String path) onExpand;
  final int depth;
  final DirectoryNode? directoryContent;

  const TreeNodeWidget({
    super.key,
    this.folder,
    this.file,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.onAddToWhitelist,
    required this.onExpand,
    this.depth = 0,
    this.directoryContent,
  }) : assert(folder != null || file != null);

  @override
  State<TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand folders that have the autoExpand flag
    if (widget.folder?.autoExpand == true) {
      _isExpanded = true;
    }
  }

  String get _path => widget.folder?.path ?? widget.file!.path;
  String get _name => widget.folder?.name ?? widget.file!.name;
  String? get _size => widget.folder?.formattedSize ?? widget.file?.formattedSize;
  bool get _isFolder => widget.folder != null;

  void _toggleExpansion() {
    if (!_isFolder) return;
    
    setState(() {
      _isExpanded = !_isExpanded;
    });

    // Trigger expansion callback if expanding for the first time
    if (_isExpanded && widget.directoryContent == null) {
      widget.onExpand(_path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indentation = widget.depth * 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main row
        InkWell(
          onTap: _isFolder ? _toggleExpansion : null,
          child: Container(
            height: 48,
            padding: EdgeInsets.only(left: indentation),
            child: Row(
              children: [
                // Checkbox
                Checkbox(
                  value: widget.isSelected,
                  onChanged: (value) {
                    widget.onSelectionChanged(_path, value ?? false);
                  },
                ),
                
                // Chevron icon (only for folders)
                if (_isFolder)
                  Icon(
                    _isExpanded ? Icons.expand_more : Icons.chevron_right,
                    color: theme.colorScheme.onSurface,
                  )
                else
                  const SizedBox(width: 24),
                
                const SizedBox(width: 8),
                
                // Folder/File icon
                Icon(
                  _isFolder ? Icons.folder : Icons.insert_drive_file,
                  color: _isFolder 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                
                const SizedBox(width: 8),
                
                // Name and size
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          _name,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_size != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '($_size)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Add to whitelist button
                IconButton(
                  icon: const Icon(Icons.add),
                  iconSize: 20,
                  tooltip: 'Add to whitelist',
                  onPressed: () => widget.onAddToWhitelist(_path),
                ),
              ],
            ),
          ),
        ),
        
        // Children (only for expanded folders)
        if (_isFolder && _isExpanded && widget.directoryContent != null)
          ..._buildChildren(widget.directoryContent!),
      ],
    );
  }

  List<Widget> _buildChildren(DirectoryNode content) {
    final children = <Widget>[];
    
    // Add folders first
    for (final folder in content.folders) {
      children.add(
        TreeNodeWidget(
          folder: folder,
          isSelected: widget.isSelected, // Inherit selection state
          onSelectionChanged: widget.onSelectionChanged,
          onAddToWhitelist: widget.onAddToWhitelist,
          onExpand: widget.onExpand,
          depth: widget.depth + 1,
        ),
      );
    }
    
    // Then add files
    for (final file in content.files) {
      children.add(
        TreeNodeWidget(
          file: file,
          isSelected: widget.isSelected, // Inherit selection state
          onSelectionChanged: widget.onSelectionChanged,
          onAddToWhitelist: widget.onAddToWhitelist,
          onExpand: widget.onExpand,
          depth: widget.depth + 1,
        ),
      );
    }
    
    return children;
  }
}
