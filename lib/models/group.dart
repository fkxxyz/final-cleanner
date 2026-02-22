class Group {
  final int? id;
  final String name;
  final String? note;
  final DateTime createdAt;

  const Group({
    this.id,
    required this.name,
    this.note,
    required this.createdAt,
  });

  Group copyWith({int? id, String? name, String? note, DateTime? createdAt}) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as int?,
      name: json['name'] as String,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Group &&
        other.id == id &&
        other.name == name &&
        other.note == note &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, note, createdAt);
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, note: $note, createdAt: $createdAt)';
  }
}
