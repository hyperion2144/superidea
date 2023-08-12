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

// final lightTheme = MacosThemeData(
//   brightness: Brightness.light,
//   primaryColor: primaryColor,
//   iconTheme: const MacosIconThemeData(
//     color: primaryColor,
//     size: 20,
//   ),
//   pulldownButtonTheme: const MacosPulldownButtonThemeData(
//     iconColor: primaryColor,
//   ),
// );
final lightTheme = MacosThemeData.light().copyWith(
  primaryColor: primaryColor,
  iconTheme: const MacosIconThemeData().copyWith(color: primaryColor),
  pushButtonTheme: const PushButtonThemeData().copyWith(
    color: primaryColor,
  ),
  pulldownButtonTheme: const MacosPulldownButtonThemeData().copyWith(
    iconColor: primaryColor,
  ),
);

final darkTheme = MacosThemeData.dark().copyWith(
  primaryColor: primaryColor,
  iconTheme: const MacosIconThemeData().copyWith(color: primaryColor),
  pushButtonTheme: const PushButtonThemeData().copyWith(
    color: primaryColor,
  ),
  pulldownButtonTheme: const MacosPulldownButtonThemeData().copyWith(
    iconColor: primaryColor,
  ),
);
