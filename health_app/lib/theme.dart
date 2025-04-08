import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Default to light mode

  bool get isDarkMode => _isDarkMode; // Getter

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Get the currently active theme
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Light theme - using the lighter sage greens
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Color(0xFFB5BBA1), // Light sage green (top color)
    primaryColorLight: Color(0xFFC5CBBB), // Lighter version
    primaryColorDark: Color(0xFF9CA38A), // Darker version
    scaffoldBackgroundColor: Color(0xFFF5F5F0),
    cardColor: Colors.white,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFFB5BBA1), // Light sage green
      secondary: Color(0xFFA7AE97), // Second sage green
      tertiary: Color(0xFFB3AC8C), // Tan color (fourth color)
      background: Color(0xFFF5F5F0),
      surface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFFB5BBA1),
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFB5BBA1),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(0xFFB5BBA1),
        side: BorderSide(color: Color(0xFFB5BBA1), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFFB5BBA1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFB5BBA1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[300]!, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey[300],
      thickness: 1,
      space: 32,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFB5BBA1),
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: TextTheme(
      displayLarge:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      displayMedium:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      displaySmall:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      headlineLarge:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      headlineMedium:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      headlineSmall:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      titleMedium:
          TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[800],
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // Dark theme - using the olive green and brown tones
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Color(0xFF5B612E), // Olive green (middle color)
    primaryColorLight: Color(0xFF6E7439), // Lighter version
    primaryColorDark: Color(0xFF494F25), // Darker version
    scaffoldBackgroundColor: Color(0xFF2A2A25),
    cardColor: Color(0xFF353530),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF5B612E), // Olive green
      secondary: Color(0xFFB3AC8C), // Tan/light brown (fourth color)
      tertiary: Color(0xFF9E967A), // Medium brown (bottom color)
      background: Color(0xFF2A2A25),
      surface: Color(0xFF353530),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF2A2A25),
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      elevation: 4,
      color: Color(0xFF353530),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF5B612E),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(0xFFB3AC8C),
        side: BorderSide(color: Color(0xFFB3AC8C), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFFB3AC8C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF3A3A35),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFF4A4A45)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFB3AC8C), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    dividerTheme: DividerThemeData(
      color: Color(0xFF4A4A45),
      thickness: 1,
      space: 32,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF353530),
      selectedItemColor: Color(0xFFB3AC8C),
      unselectedItemColor: Colors.grey[500],
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      displayMedium:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headlineLarge:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      headlineMedium:
          TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      headlineSmall:
          TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white70),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF2A2A25),
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
