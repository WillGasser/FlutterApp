import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/profile_screen.dart';
import 'screens/CBT_Training.dart';
import 'screens/thought_log.dart';
import 'screens/my_journey/my_journey_screen.dart';
import 'theme.dart';

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

    // 获取屏幕宽度，用于计算侧边栏宽度
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth * 0.75;

    // 创建菜单项列表 - 注意：移除了Home选项
    final List<Widget> menuItems = [
      // Account 标题
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), // 减少了垂直间距
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

      // Activity 标题
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4), // 减少了垂直间距
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
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CBTScreen(),
            ),
          );
        },
      ),
      _buildMenuItem(
        context,
        '1min Journal Writing',
        Icons.edit_outlined,
        () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ThoughtLogScreen(),
            ),
          );
        },
      ),
      _buildMenuItem(
        context,
        'Your Data',
        Icons.bar_chart,
        () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyJourneyScreen(),
            ),
          );
        },
      ),
      _buildMenuItem(
        context,
        'Your Badges',
        //Icons.star_outline,
        Icons.military_tech,
        () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CBTScreen(initialTabIndex: 2),
            ),
          );
        },
      ),
      // 移动Logout按钮到Your Badges下面
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
              // 顶部用户信息区域
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
                        // 用户头像和欢迎信息
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

                        // 关闭按钮 - 使用primaryContainer作为背景色
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // 使用与欢迎卡片相同的背景色
                            color:
                                colorScheme.primaryContainer?.withOpacity(0.7),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              // 图标颜色使用primaryContainer对应的前景色
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

                    const SizedBox(height: 16), // 减少垂直间距

                    // 主题切换部分
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
                          // 浅色主题按钮
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

                          // 深色主题按钮
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

              // 菜单项列表
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 10), // 减少顶部间距
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: menuItems,
                  ),
                ),
              ),

              // 移除底部的登出按钮，因为已经添加到菜单项列表中了
            ],
          ),
        ),
      ),
    );
  }

  // 构建菜单项的帮助方法
  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 2, horizontal: 16), // 减少垂直间距
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
      dense: true, // 使ListTile更加紧凑
      visualDensity: VisualDensity(vertical: -1), // 进一步减少垂直间距
    );
  }
}
