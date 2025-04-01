import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/my_journey/my_journey_screen.dart';
import 'theme.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user == null;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? Colors.tealAccent : Colors.blue;

    return Drawer(
      elevation: 16.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.teal.shade700, Colors.teal.shade900]
                    : [Colors.blue.shade500, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isGuest ? "Guest User" : (user?.email ?? "User"),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isGuest)
                  Chip(
                    label: const Text('Active'),
                    backgroundColor: Colors.green.withOpacity(0.3),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: isDark ? Colors.grey[900] : Colors.grey[50],
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildListTile(
                    context,
                    'Home',
                    Icons.home_outlined,
                    () {
                      Navigator.pop(context); // Close the drawer
                      // If not on home page, navigate to it
                      if (ModalRoute.of(context)?.settings.name != '/') {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      }
                    },
                    primaryColor,
                  ),
                  _buildListTile(
                    context,
                    'My Journey',
                    Icons.timeline_outlined,
                    () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyJourneyScreen(),
                        ),
                      );
                    },
                    primaryColor,
                  ),
                  if (!isGuest)
                    _buildListTile(
                      context,
                      'Profile',
                      Icons.person_outline,
                      () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      primaryColor,
                    ),
                  _buildListTile(
                    context,
                    'Settings',
                    Icons.settings_outlined,
                    () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    primaryColor,
                  ),
                  const Divider(),
                  _buildListTile(
                    context,
                    'Help & Support',
                    Icons.help_outline,
                    () {
                      Navigator.pop(context); // Close the drawer
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Help & Support coming soon!"),
                        ),
                      );
                    },
                    primaryColor,
                  ),
                  _buildListTile(
                    context,
                    'About HOOM',
                    Icons.info_outline,
                    () {
                      Navigator.pop(context); // Close the drawer
                      _showAboutDialog(context);
                    },
                    primaryColor,
                  ),
                ],
              ),
            ),
          ),

          // Logout button at the bottom
          Container(
            color: isDark ? Colors.grey[850] : Colors.white,
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: isDark ? Colors.redAccent : Colors.red,
              ),
              title: Text(
                isGuest ? 'Back to Login' : 'Log Out',
                style: TextStyle(
                  color: isDark ? Colors.redAccent : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),

          // App version at the bottom
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Text(
              'HOOM v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build consistent list tiles
  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
    Color primaryColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      horizontalTitleGap: 0,
      minLeadingWidth: 20,
    );
  }

  // Show about dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'HOOM',
        applicationVersion: 'v1.0.0',
        applicationIcon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.health_and_safety_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
        children: [
          const SizedBox(height: 24),
          const Text(
            'HOOM is a mental wellness app designed to help you track your thoughts and learn CBT techniques.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2025 HOOM Mental Wellness',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
