class ScanRoot {
  final int? id;
  final String path;
  final bool enabled;

  const ScanRoot({this.id, required this.path, this.enabled = true});

  ScanRoot copyWith({int? id, String? path, bool? enabled}) {
    return ScanRoot(
      id: id ?? this.id,
      path: path ?? this.path,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'path': path, 'enabled': enabled};
  }

  factory ScanRoot.fromJson(Map<String, dynamic> json) {
    return ScanRoot(
      id: json['id'] as int?,
      path: json['path'] as String,
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanRoot &&
        other.id == id &&
        other.path == path &&
        other.enabled == enabled;
  }

  @override
  int get hashCode {
    return Object.hash(id, path, enabled);
  }

  @override
  String toString() {
    return 'ScanRoot(id: $id, path: $path, enabled: $enabled)';
  }
}
