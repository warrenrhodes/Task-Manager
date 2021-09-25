import 'package:flutter/material.dart';
import 'package:task_manager2/theme/share_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  ManagerThemeAndTemporellVar darkThemePreference =
      ManagerThemeAndTemporellVar();
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  set setdarkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
