import 'package:hive/hive.dart';

class HiveService<T> {
  final Box<T> box;

  HiveService(this.box);

  Future<void> add(String key, T value) async {
    await box.put(key, value);
  }

  T? get(String key) {
    return box.get(key);
  }

  List<T> getAll() {
    return box.values.toList();
  }

  Future<void> update(String key, T value) async {
    await box.put(key, value);
  }

  Future<void> delete(String key) async {
    await box.delete(key);
  }

  Future<void> clearAll() async {
    await box.clear();
  }
}
