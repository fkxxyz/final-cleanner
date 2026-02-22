import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../../models/scan_result.dart';

class ScanResultTile extends StatelessWidget {
  final ScanResult result;
  final bool isSelected;
  final VoidCallback onToggle;

  const ScanResultTile({
    super.key,
    required this.result,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: isSelected, onChanged: (_) => onToggle()),
      title: Text(
        path.basename(result.path),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        result.path,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            result.isDirectory ? Icons.folder : Icons.insert_drive_file,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            result.formattedSize,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      onTap: onToggle,
    );
  }
}
