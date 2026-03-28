import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const _boxName = 'app';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static String? get token => _box.get('token') as String?;
  static Future<void> setToken(String? value) async {
    if (value == null) {
      await _box.delete('token');
      return;
    }
    await _box.put('token', value);
  }

  static String? get pendingPhone => _box.get('pendingPhone') as String?;
  static Future<void> setPendingPhone(String? value) async {
    if (value == null) {
      await _box.delete('pendingPhone');
      return;
    }
    await _box.put('pendingPhone', value);
  }

  static Future<void> clear() async {
    await _box.clear();
  }
}

