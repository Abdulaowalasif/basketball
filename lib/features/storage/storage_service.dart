import 'package:get_storage/get_storage.dart';

class StorageService {
  final storage = GetStorage();

  Future<void> init() async {
    await GetStorage.init();
  }

  Future<void> write(String key, dynamic value) async {
    await storage.write(key, value);
  }

  dynamic read(String key) {
    return storage.read(key);
  }

  Future<void> remove(String key) async {
    await storage.remove(key);
  }

  Future<void> clear() async {
    await storage.erase();
  }

  bool hasData(String key) {
    return storage.hasData(key);
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) async {
    await storage.write(key, value);
  }
}
