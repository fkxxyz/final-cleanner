import 'file_node.dart';
import 'folder_node.dart';

class DirectoryNode {
  final String path;
  final List<FileNode> files;
  final List<FolderNode> folders;

  const DirectoryNode({
    required this.path,
    required this.files,
    required this.folders,
  });

  DirectoryNode copyWith({
    String? path,
    List<FileNode>? files,
    List<FolderNode>? folders,
  }) {
    return DirectoryNode(
      path: path ?? this.path,
      files: files ?? this.files,
      folders: folders ?? this.folders,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'files': files.map((f) => f.toJson()).toList(),
      'folders': folders.map((f) => f.toJson()).toList(),
    };
  }

  factory DirectoryNode.fromJson(Map<String, dynamic> json) {
    return DirectoryNode(
      path: json['path'] as String,
      files: (json['files'] as List<dynamic>)
          .map((e) => FileNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      folders: (json['folders'] as List<dynamic>)
          .map((e) => FolderNode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DirectoryNode &&
        other.path == path &&
        _listEquals(other.files, files) &&
        _listEquals(other.folders, folders);
  }

  @override
  int get hashCode {
    return Object.hash(path, Object.hashAll(files), Object.hashAll(folders));
  }

  @override
  String toString() {
    return 'DirectoryNode(path: $path, files: $files, folders: $folders)';
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
