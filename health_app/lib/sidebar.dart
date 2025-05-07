import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/profile_screen.dart';
import 'theme.dart';
import 'home_page.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user == null;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get the screen width for calculating the drawer width
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth * 0.75;

    // Create menu items list
    final List<Widget> menuItems = [
      // Account title
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          "Account",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Color(0xFF4A4A40),
          ),
        ),
      ),

      _buildMenuItem(
        context,
        'Profile',
        Icons.person_outline,
        () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          );
        },
      ),

      // Activity title
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(
          "Activity",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Color(0xFF4A4A40),
          ),
        ),
      ),

      _buildMenuItem(
        context,
        '3min CBT Training',
        Icons.lightbulb_outline,
        () {
          // Close the drawer first
          Navigator.pop(context);

          // Navigate using the bottom bar navigation
          final HomePageState? homePageState =
              context.findAncestorStateOfType<HomePageState>();
          if (homePageState != null) {
            homePageState.onItemTapped(0); // 0 is the index for CBT
          } else {
            // Fallback if can't find HomePage state
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const HomePage(isNewLogin: false, type: 'returning_user'),
              ),
            );
          }
        },
      ),

      _buildMenuItem(
        context,
        '1min Journal Writing',
        Icons.edit_outlined,
        () {
          // Close the drawer first
          Navigator.pop(context);

          // Navigate using the bottom bar navigation
          final HomePageState? homePageState =
              context.findAncestorStateOfType<HomePageState>();
          if (homePageState != null) {
            homePageState.onItemTapped(2); // 2 is the index for Thought Log
          } else {
            // Fallback if can't find HomePage state
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const HomePage(isNewLogin: false, type: 'returning_user'),
              ),
            );
          }
        },
      ),

      _buildMenuItem(
        context,
        'Your Data',
        Icons.bar_chart,
        () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your data page coming soon!"),
            ),
          );
        },
      ),

      _buildMenuItem(
        context,
        'Your Badges',
        Icons.military_tech,
        () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Your badges page coming soon!"),
            ),
          );
        },
      ),

      // Logout button
      _buildMenuItem(
        context,
        'Logout',
        Icons.logout,
        () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/login');
        },
        isLogout: true,
      ),
    ];

    return Container(
      width: drawerWidth,
      child: Drawer(
        backgroundColor: isDarkMode
            ? ThemeProvider.darkBackgroundColor
            : ThemeProvider.lightBackgroundColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top user info area
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User avatar and welcome info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                              child: Icon(
                                Icons.person_outline,
                                size: 32,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello,",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isGuest
                                      ? "Friend"
                                      : (user?.displayName ??
                                          user?.email?.split('@')[0] ??
                                          "User"),
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Color(0xFF4A4A40),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Close button
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                colorScheme.primaryContainer.withOpacity(0.7),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: colorScheme.onPrimaryContainer,
                              size: 24,
                            ),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(),
                            tooltip: "Close menu",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Theme switcher
                    Container(
                      decoration: BoxDecoration(
                        color: isDarkMode ? Color(0xFF353530) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(4),
                      child: Row(
                        children: [
                          // Light theme button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (isDarkMode) themeProvider.toggleTheme();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isDarkMode
                                      ? Colors.transparent
                                      : colorScheme.primary.withOpacity(0.1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.light_mode,
                                      size: 20,
                                      color: isDarkMode
                                          ? Colors.grey[500]
                                          : colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Light",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isDarkMode
                                            ? FontWeight.normal
                                            : FontWeight.w500,
                                        color: isDarkMode
                                            ? Colors.grey[500]
                                            : colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Dark theme button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!isDarkMode) themeProvider.toggleTheme();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: !isDarkMode
                                      ? Colors.transparent
                                      : colorScheme.primary.withOpacity(0.2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.dark_mode,
                                      size: 20,
                                      color: !isDarkMode
                                          ? Colors.grey[500]
                                          : colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Dark",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: !isDarkMode
                                            ? FontWeight.normal
                                            : FontWeight.w500,
                                        color: !isDarkMode
                                            ? Colors.grey[500]
                                            : colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Menu items list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: menuItems,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      leading: Icon(
        icon,
        size: 24,
        color: isLogout
            ? (isDarkMode ? Colors.red[300] : Colors.red[700])
            : (isDarkMode ? Colors.white : Colors.grey[800]),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isLogout
              ? (isDarkMode ? Colors.red[300] : Colors.red[700])
              : (isDarkMode ? Colors.white : Colors.grey[800]),
        ),
      ),
      onTap: onTap,
      minLeadingWidth: 24,
      horizontalTitleGap: 12,
      dense: true,
      visualDensity: VisualDensity(vertical: -1),
    );
  }
}
