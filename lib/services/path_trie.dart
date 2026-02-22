class _TrieNode {
  final Map<String, _TrieNode> children = {};
  bool isTerminal = false;
}

class PathTrie {
  final _TrieNode _root = _TrieNode();
  int _size = 0;

  int get size => _size;

  static String normalizePath(String path) {
    var result = path.trim();
    if (result.isEmpty) return '/';
    result = result.replaceAll('\\', '/');
    result = result.replaceAll(RegExp(r'/+'), '/');
    if (result.length > 1 && result.endsWith('/')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }

  List<String> _segments(String normalizedPath) {
    if (normalizedPath == '/') return const [];
    final p = normalizedPath.startsWith('/')
        ? normalizedPath.substring(1)
        : normalizedPath;
    return p.split('/');
  }

  void insert(String path, {bool isDirectory = false}) {
    final normalized = normalizePath(path);
    final segments = _segments(normalized);

    var node = _root;
    for (final segment in segments) {
      node = node.children.putIfAbsent(segment, _TrieNode.new);
    }
    if (!node.isTerminal) {
      node.isTerminal = true;
      _size++;
    }
  }

  bool contains(String path) {
    final normalized = normalizePath(path);
    final segments = _segments(normalized);

    var node = _root;
    for (final segment in segments) {
      final child = node.children[segment];
      if (child == null) return false;
      node = child;
    }
    return node.isTerminal;
  }

  bool isWhitelisted(String path) {
    final normalized = normalizePath(path);
    if (_root.isTerminal) return true;

    final segments = _segments(normalized);
    var node = _root;
    for (final segment in segments) {
      final child = node.children[segment];
      if (child == null) return false;
      node = child;
      if (node.isTerminal) return true;
    }
    return false;
  }

  void remove(String path) {
    final normalized = normalizePath(path);
    final segments = _segments(normalized);

    final nodes = <_TrieNode>[_root];
    var node = _root;
    for (final segment in segments) {
      final child = node.children[segment];
      if (child == null) return;
      nodes.add(child);
      node = child;
    }

    if (!node.isTerminal) return;
    node.isTerminal = false;
    _size--;

    for (var i = segments.length - 1; i >= 0; i--) {
      final current = nodes[i + 1];
      if (current.children.isEmpty && !current.isTerminal) {
        nodes[i].children.remove(segments[i]);
      } else {
        break;
      }
    }
  }

  void clear() {
    _root.children.clear();
    _root.isTerminal = false;
    _size = 0;
  }
}
