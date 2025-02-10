import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Default to light mode

  bool get isDarkMode => _isDarkMode; // Getter

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to rebuild UI
  }
}
