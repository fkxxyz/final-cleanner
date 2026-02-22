abstract class RecycleBin {
  Future<bool> moveToTrash(String path);
  Future<List<String>> moveMultipleToTrash(List<String> paths);
  bool get isSupported;
}
