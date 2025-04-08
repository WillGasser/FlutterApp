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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          // Replace standard DrawerHeader with a custom header container
          // to fix the overflow issue
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer ??
                      colorScheme.primary.withOpacity(0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // This ensures it takes only needed space
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8), // Add some padding at the top
                  Container(
                    width: 75, // Slightly smaller to save space
                    height: 75, // Slightly smaller to save space
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white70, width: 2),
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      size: 55, // Slightly smaller icon
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced space
                  Text(
                    isGuest ? "Guest User" : (user?.email ?? "User"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Handles long emails gracefully
                  ),
                  if (!isGuest)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4.0), // Reduced padding
                      child: Chip(
                        label: const Text('Active'),
                        backgroundColor: Colors.green.withOpacity(0.3),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero, // Minimizes internal padding
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: theme.scaffoldBackgroundColor,
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
                  ),
                  _buildListTile(
                    context,
                    'About HOOM',
                    Icons.info_outline,
                    () {
                      Navigator.pop(context); // Close the drawer
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Logout button at the bottom
          Container(
            color: theme.cardColor,
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text(
                isGuest ? 'Back to Login' : 'Log Out',
                style: TextStyle(
                  color: Colors.red,
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
            color: theme.cardColor,
            child: Text(
              'HOOM v1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
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
  ) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      horizontalTitleGap: 12, // Added space between icon and text
      minLeadingWidth: 24, // Slightly increased for better spacing
    );
  }

  // Show about dialog
  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'HOOM',
        applicationVersion: 'v1.0.0',
        applicationIcon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
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
