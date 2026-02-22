class ScanResult {
  final String path;
  final int sizeBytes;
  final DateTime modifiedAt;
  final bool isDirectory;
  final String? extension;

  const ScanResult({
    required this.path,
    required this.sizeBytes,
    required this.modifiedAt,
    required this.isDirectory,
    this.extension,
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

  ScanResult copyWith({
    String? path,
    int? sizeBytes,
    DateTime? modifiedAt,
    bool? isDirectory,
    String? extension,
  }) {
    return ScanResult(
      path: path ?? this.path,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isDirectory: isDirectory ?? this.isDirectory,
      extension: extension ?? this.extension,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'sizeBytes': sizeBytes,
      'modifiedAt': modifiedAt.toIso8601String(),
      'isDirectory': isDirectory,
      'extension': extension,
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      path: json['path'] as String,
      sizeBytes: json['sizeBytes'] as int,
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      isDirectory: json['isDirectory'] as bool,
      extension: json['extension'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanResult &&
        other.path == path &&
        other.sizeBytes == sizeBytes &&
        other.modifiedAt == modifiedAt &&
        other.isDirectory == isDirectory &&
        other.extension == extension;
  }

  @override
  int get hashCode {
    return Object.hash(path, sizeBytes, modifiedAt, isDirectory, extension);
  }

  @override
  String toString() {
    return 'ScanResult(path: $path, sizeBytes: $sizeBytes, modifiedAt: $modifiedAt, isDirectory: $isDirectory, extension: $extension)';
  }
}
