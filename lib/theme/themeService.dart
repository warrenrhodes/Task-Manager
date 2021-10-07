import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isLightMode';

  /// Get isLightMode info from local storage and return ThemeMode
  ThemeMode get theme =>
      _loadThemeFromBox() == false ? ThemeMode.dark : ThemeMode.light;

  /// Load isLightMode from local storage and if it's empty, returns false (that means default theme is Dark)
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  /// Save isLight to local storage
  _saveThemeToBox(bool isLightMode) => _box.write(_key, isLightMode);

  /// Switch theme and save to local storage
  void switchTheme() {
    Get.changeThemeMode(
        _loadThemeFromBox() == false ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  bool getdefaultTheme() {
    return _loadThemeFromBox();
  }
}
