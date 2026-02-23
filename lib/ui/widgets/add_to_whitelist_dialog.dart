import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/group.dart';
import '../../providers/providers.dart';

class WhitelistItemData {
  final String path;
  final String name;
  final String? description;
  final int? groupId;

  const WhitelistItemData({
    required this.path,
    required this.name,
    this.description,
    this.groupId,
  });
}

class AddToWhitelistDialog extends ConsumerStatefulWidget {
  final String path;

  const AddToWhitelistDialog({super.key, required this.path});

  static Future<WhitelistItemData?> show(BuildContext context, String path) {
    return showDialog<WhitelistItemData>(
      context: context,
      builder: (context) => AddToWhitelistDialog(path: path),
    );
  }

  @override
  ConsumerState<AddToWhitelistDialog> createState() =>
      _AddToWhitelistDialogState();
}

class _AddToWhitelistDialogState extends ConsumerState<AddToWhitelistDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  int? _selectedGroupId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: p.basename(widget.path));
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    setState(() {
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.whitelistErrorNameEmpty;
      });
      return;
    }

    final description = _descriptionController.text.trim();
    final data = WhitelistItemData(
      path: widget.path,
      name: name,
      description: description.isEmpty ? null : description,
      groupId: _selectedGroupId,
    );

    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.whitelistAddToWhitelist),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: TextEditingController(text: widget.path),
              decoration: const InputDecoration(
                labelText: AppLocalizations.of(context)!.fieldPath,
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.fieldName,
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: AppLocalizations.of(context)!.whitelistDescription,
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            groupsAsync.when(
              data: (groups) {
                return DropdownButtonFormField<int?>(
                  value: _selectedGroupId,
                  decoration: const InputDecoration(
                    labelText: AppLocalizations.of(context)!.whitelistGroup,
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text(
                        AppLocalizations.of(context)!.whitelistNoGroup,
                      ),
                    ),
                    ...groups.map((group) {
                      return DropdownMenuItem<int?>(
                        value: group.id,
                        child: Text(group.name),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGroupId = value;
                    });
                  },
                );
              },
              loading: () => DropdownButtonFormField<int?>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.whitelistGroup,
                  border: OutlineInputBorder(),
                ),
                items: [],
                onChanged: null,
              ),
              error: (error, stack) => DropdownButtonFormField<int?>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.whitelistGroup,
                  border: const OutlineInputBorder(),
                  errorText: AppLocalizations.of(
                    context,
                  )!.whitelistErrorLoadGroups,
                ),
                items: const [],
                onChanged: null,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.dialogCancel),
        ),
        FilledButton(
          onPressed: _handleSave,
          child: Text(AppLocalizations.of(context)!.dialogSave),
        ),
      ],
    );
  }
}
