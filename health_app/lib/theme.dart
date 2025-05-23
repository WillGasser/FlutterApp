import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // 默认为浅色模式

  bool get isDarkMode => _isDarkMode; // Getter

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Get the currently active theme
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Authentication page constants
  static const double authBorderRadius =
      12.0; // Authentication page border radius

  // Light theme color constants
  static const Color lightPrimaryColor = Color(0xFFB5BBA1);
  static const Color lightBackgroundColor = Color(0xFFE8E8DD);
  static const Color lightTextColor = Color(0xFF4A4A40);
  static const Color lightHintColor = Color(0xFF9E9E8E);
  static const Color lightDividerColor = Color(0xFFE0DFD5);
  static const Color lightInputBoxColor = Colors.white;

  // Dark theme color constants
  static const Color darkPrimaryColor = Color(0xFF8E9579);
  static const Color darkBackgroundColor = Color(0xFF2A2A25);
  static const Color darkTextColor = Colors.white;
  static const Color darkHintColor = Color(0xFF8E8E80);
  static const Color darkDividerColor = Color(0xFF4A4A45);
  static const Color darkInputBoxColor = Color(0xFF3A3A35);
  static const Color darkSecondaryButtonBg = Color(0xFF2D2D2D);

  // Light theme - using the improved UI elements
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Color(0xFFB5BBA1),
    primaryColorLight: Color(0xFFC7CDB9),
    primaryColorDark: Color(0xFFA5AB91),
    scaffoldBackgroundColor: Color(0xFFE8E8DD),
    cardColor: Color(0xFFF4F2E9),
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFFB5BBA1),
      secondary: Color(0xFFCCC5B3),
      tertiary: Color(0xFFB3AC8C),
      onPrimary: Colors.white,
      background: Color(0xFFE8E8DD),
      surface: Color(0xFFF4F2E9),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFFE8E8DD),
      foregroundColor: Color(0xFF4A4A40),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Color(0xFF4A4A40),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF4A4A40)),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: Color(0xFFF4F2E9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFB5BBA1),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(0xFF4A4A40),
        backgroundColor: Colors.white,
        side: BorderSide(color: Color(0xFFE0DFD5), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF4A4A40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFE0DFD5), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFB5BBA1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red[200]!, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      prefixIconColor: Color(0xFF9E9E8E),
      suffixIconColor: Color(0xFF9E9E8E),
      labelStyle: TextStyle(
        color: Color(0xFF9E9E8E),
        fontSize: 16,
      ),
      hintStyle: TextStyle(
        color: Color(0xFFBBBBAF),
        fontSize: 16,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Color(0xFFE0DFD5),
      thickness: 1,
      space: 32,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFB5BBA1),
      unselectedItemColor: Color(0xFF9E9E8E),
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: Color(0xFF4A4A40),
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(color: Color(0xFF4A4A40)),
      bodyMedium: TextStyle(color: Color(0xFF4A4A40)),
      bodySmall: TextStyle(color: Color(0xFF9E9E8E)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF4A4A40),
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF9E9E8E),
    ),
  );

  // Dark theme - using the improved UI elements
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Color(0xFF7D8469), // Deeper olive green
    primaryColorLight: Color(0xFF8E9579), // Slightly lighter version
    primaryColorDark: Color(0xFF6A7156), // Deeper version
    scaffoldBackgroundColor: Color(0xFF2A2A25),
    cardColor: Color(0xFF353530),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF8E9579), // Neutral olive green
      secondary: Color(0xFFACA489), // Light brown
      tertiary: Color(0xFF9E967A), // Medium brown
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
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: Color(0xFF353530),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF8E9579),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Color(0xFFACA489),
        backgroundColor: Color(0xFF2A2A25),
        side: BorderSide(color: Color(0xFF4A4A40), width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFFACA489),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF3A3A35),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF4A4A45)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFACA489), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      prefixIconColor: Color(0xFF8E8E80),
      suffixIconColor: Color(0xFF8E8E80),
      labelStyle: TextStyle(
        color: Color(0xFF8E8E80),
        fontSize: 16,
      ),
      hintStyle: TextStyle(
        color: Color(0xFF6E6E65),
        fontSize: 16,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Color(0xFF4A4A45),
      thickness: 1,
      space: 32,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF353530),
      selectedItemColor: Color(0xFFACA489),
      unselectedItemColor: Color(0xFF8E8E80),
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
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
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF8E8E80),
    ),
  );

  // Helper methods for authentication page colors
  static Color getAuthInputBoxColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkInputBoxColor
        : lightInputBoxColor;
  }

  static Color getAuthTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextColor
        : lightTextColor;
  }

  static Color getAuthHintColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkHintColor
        : lightHintColor;
  }

  static Color getAuthPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryColor
        : lightPrimaryColor;
  }
}
