import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class AppTheme extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

const primaryColor = Color.fromRGBO(255, 76, 27, 1);

final lightTheme = MacosThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  iconTheme: const MacosIconThemeData(
    color: primaryColor,
    size: 20,
  ),
);

final darkTheme = MacosThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  iconTheme: const MacosIconThemeData(
    color: primaryColor,
    size: 20,
  ),
);
