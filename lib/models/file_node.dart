class FileNode {
  final String path;
  final String name;
  final int sizeBytes;
  final DateTime modifiedAt;

  const FileNode({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.modifiedAt,
  });

  String get formattedSize {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    } else if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(2)} KB';
    } else if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (sizeBytes < 1024 * 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    } else {
      return '${(sizeBytes / (1024 * 1024 * 1024 * 1024)).toStringAsFixed(2)} TB';
    }
  }

  FileNode copyWith({
    String? path,
    String? name,
    int? sizeBytes,
    DateTime? modifiedAt,
  }) {
    return FileNode(
      path: path ?? this.path,
      name: name ?? this.name,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'sizeBytes': sizeBytes,
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  factory FileNode.fromJson(Map<String, dynamic> json) {
    return FileNode(
      path: json['path'] as String,
      name: json['name'] as String,
      sizeBytes: json['sizeBytes'] as int,
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileNode &&
        other.path == path &&
        other.name == name &&
        other.sizeBytes == sizeBytes &&
        other.modifiedAt == modifiedAt;
  }

  @override
  int get hashCode {
    return Object.hash(path, name, sizeBytes, modifiedAt);
  }

  @override
  String toString() {
    return 'FileNode(path: $path, name: $name, sizeBytes: $sizeBytes, modifiedAt: $modifiedAt)';
  }
}
