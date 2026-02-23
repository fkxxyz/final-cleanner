class WhitelistItem {
  final int? id;
  final String path;
  final String? name;
  final String? note;
  final bool isDirectory;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? groupId;

  const WhitelistItem({
    this.id,
    required this.path,
    this.name,
    this.note,
    required this.isDirectory,
    required this.createdAt,
    required this.updatedAt,
    this.groupId,
  });

  WhitelistItem copyWith({
    int? id,
    String? path,
    String? name,
    String? note,
    bool? isDirectory,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? groupId,
  }) {
    return WhitelistItem(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      note: note ?? this.note,
      isDirectory: isDirectory ?? this.isDirectory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'note': note,
      'isDirectory': isDirectory,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'groupId': groupId,
    };
  }

  factory WhitelistItem.fromJson(Map<String, dynamic> json) {
    return WhitelistItem(
      id: json['id'] as int?,
      path: json['path'] as String,
      name: json['name'] as String?,
      note: json['note'] as String?,
      isDirectory: json['isDirectory'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      groupId: json['groupId'] as int?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WhitelistItem &&
        other.id == id &&
        other.path == path &&
        other.name == name &&
        other.note == note &&
        other.isDirectory == isDirectory &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.groupId == groupId;
  }

  @override
  int get hashCode {
    return Object.hash(id, path, name, note, isDirectory, createdAt, updatedAt, groupId);
  }

  @override
  String toString() {
    return 'WhitelistItem(id: $id, path: $path, name: $name, note: $note, isDirectory: $isDirectory, createdAt: $createdAt, updatedAt: $updatedAt, groupId: $groupId)';
  }
}
