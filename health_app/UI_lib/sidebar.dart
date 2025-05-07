// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'screens/settings_screen.dart';
// import 'screens/profile_screen.dart';
// import 'screens/my_journey/my_journey_screen.dart';
// import 'theme.dart';
//
// class SideBar extends StatelessWidget {
//   const SideBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final bool isGuest = user == null;
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     // 创建菜单项列表
//     final List<Widget> menuItems = [
//       _buildMenuItem(
//         context,
//         'Home',
//         Icons.home_outlined,
//             () {
//           Navigator.pop(context);
//           if (ModalRoute.of(context)?.settings.name != '/') {
//             Navigator.pushNamedAndRemoveUntil(
//                 context, '/', (route) => false);
//           }
//         },
//       ),
//       _buildMenuItem(
//         context,
//         'Profile',
//         Icons.person_outline,
//             () {
//           Navigator.pop(context);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const ProfileScreen(),
//             ),
//           );
//         },
//       ),
//       _buildMenuItem(
//         context,
//         '3min CBT Training',
//         Icons.school_outlined,
//             () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("CBT Training page coming soon!"),
//             ),
//           );
//         },
//       ),
//       _buildMenuItem(
//         context,
//         '1min Journal Writing',
//         Icons.edit_note_outlined,
//             () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Journal page coming soon!"),
//             ),
//           );
//         },
//       ),
//       _buildMenuItem(
//         context,
//         'Your Data',
//         Icons.data_usage_outlined,
//             () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Your data page coming soon!"),
//             ),
//           );
//         },
//       ),
//       // 确保添加Your Badges选项
//       _buildMenuItem(
//         context,
//         'Your Badges',
//         Icons.military_tech_outlined, // 更换了图标，使其更像勋章/徽章
//             () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Your badges page coming soon!"),
//             ),
//           );
//         },
//       ),
//     ];
//
//     return Drawer(
//       backgroundColor: Colors.grey[50],
//       elevation: 0,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         children: [
//           // 顶部用户信息区域
//           Container(
//             padding: const EdgeInsets.all(20.0),
//             width: double.infinity,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // 用户头像和欢迎信息
//                     Row(
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.grey[300]!, width: 1),
//                           ),
//                           child: Icon(
//                             Icons.person_outline,
//                             size: 25,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Hello,",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//                             Text(
//                               isGuest ? "Guest User" : (user?.displayName ?? user?.email?.split('@')[0] ?? "User"),
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.grey[600],
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     // 关闭按钮
//                     IconButton(
//                       icon: Icon(Icons.close, color: Colors.grey[700]),
//                       onPressed: () => Navigator.pop(context),
//                       padding: EdgeInsets.zero,
//                       constraints: BoxConstraints(),
//                       iconSize: 20,
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // 分隔线
//                 Divider(color: Colors.grey[300], height: 1),
//
//                 const SizedBox(height: 16),
//
//                 // 主题切换部分
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Theme",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         // 浅色主题按钮
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               if (isDarkMode) themeProvider.toggleTheme();
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 6),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: isDarkMode ? Colors.grey[400]! : colorScheme.primary,
//                                   width: 1,
//                                 ),
//                                 borderRadius: const BorderRadius.horizontal(
//                                   left: Radius.circular(6),
//                                 ),
//                                 color: isDarkMode ? Colors.transparent : colorScheme.primary.withOpacity(0.1),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.light_mode_outlined,
//                                     size: 16,
//                                     color: isDarkMode ? Colors.grey[600] : colorScheme.primary,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     "Light",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: isDarkMode ? FontWeight.normal : FontWeight.w500,
//                                       color: isDarkMode ? Colors.grey[600] : colorScheme.primary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         // 深色主题按钮
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () {
//                               if (!isDarkMode) themeProvider.toggleTheme();
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 6),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: !isDarkMode ? Colors.grey[400]! : colorScheme.primary,
//                                   width: 1,
//                                 ),
//                                 borderRadius: const BorderRadius.horizontal(
//                                   right: Radius.circular(6),
//                                 ),
//                                 color: !isDarkMode ? Colors.transparent : colorScheme.primary.withOpacity(0.1),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.dark_mode_outlined,
//                                     size: 16,
//                                     color: !isDarkMode ? Colors.grey[600] : colorScheme.primary,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     "Dark",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: !isDarkMode ? FontWeight.normal : FontWeight.w500,
//                                       color: !isDarkMode ? Colors.grey[600] : colorScheme.primary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // 菜单项列表 - 使用Column而不是ListView，确保所有项目显示
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children: menuItems,
//                 ),
//               ),
//             ),
//           ),
//
//           // 底部登出按钮
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: _buildMenuItem(
//               context,
//               'Logout',
//               Icons.logout_outlined,
//                   () async {
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.pop(context);
//                 Navigator.pushReplacementNamed(context, '/login');
//               },
//               isLogout: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 构建菜单项的帮助方法
//   Widget _buildMenuItem(
//       BuildContext context,
//       String title,
//       IconData icon,
//       VoidCallback onTap, {
//         bool isLogout = false,
//       }) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//       leading: Icon(
//         icon,
//         size: 20,
//         color: Colors.grey[700],
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: Colors.grey[800],
//         ),
//       ),
//       onTap: onTap,
//       minLeadingWidth: 20,
//       horizontalTitleGap: 8,
//     );
//   }
// }

//version 2
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'screens/settings_screen.dart';
// import 'screens/profile_screen.dart';
// import 'screens/my_journey/my_journey_screen.dart';
// import 'theme.dart';
//
// class SideBar extends StatelessWidget {
//   const SideBar({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final bool isGuest = user == null;
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDarkMode = themeProvider.isDarkMode;
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//
//     // 获取屏幕宽度，用于计算侧边栏宽度
//     final screenWidth = MediaQuery.of(context).size.width;
//     // 设置侧边栏宽度为屏幕宽度的70%，这样能看到部分主页面
//     final drawerWidth = screenWidth * 0.7;
//
//     // 创建菜单项列表
//     final List<Widget> menuItems = [
//       _buildMenuItem(
//         context,
//         'Home',
//         Icons.home_outlined,
//             () {
//           Navigator.pop(context);
//           if (ModalRoute.of(context)?.settings.name != '/') {
//             Navigator.pushNamedAndRemoveUntil(
//                 context, '/', (route) => false);
//           }
//         },
//       ),
//       _buildMenuItem(
//         context,
//         'Profile',
//         Icons.person_outline,
//             () {
//           Navigator.pop(context);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const ProfileScreen(),
//             ),
//           );
//         },
//       ),
//       _buildMenuItem(
//         context,
//         '3min CBT Training',
//         Icons.school_outlined,
//             () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("CBT Training page coming soon!"),
//             ),
//           );
//         },
//       ),
//       _buildMenuItem(
//         context,
//         '1min Journal Writing',
//         Icons.edit_note_outlined,
//             () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Journal page coming soon!"),
//             ),
//           );
//         },
//       ),
//       _buildMenuItem(
//         context,
//         'Your Data',
//         Icons.data_usage_outlined,
//             () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Your data page coming soon!"),
//             ),
//           );
//         },
//       ),
//       _buildMenuItem(
//         context,
//         'Your Badges',
//         Icons.military_tech_outlined,
//             () {
//           Navigator.pop(context);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("Your badges page coming soon!"),
//             ),
//           );
//         },
//       ),
//     ];
//
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topRight: Radius.circular(20),
//         bottomRight: Radius.circular(20),
//       ),
//       child: Container(
//         width: drawerWidth, // 设置自定义宽度
//         child: Drawer(
//           backgroundColor: Colors.grey[50],
//           elevation: 0,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               // 顶部用户信息区域
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 width: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // 用户头像和欢迎信息
//                         Row(
//                           children: [
//                             Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: Colors.grey[300]!, width: 1),
//                               ),
//                               child: Icon(
//                                 Icons.person_outline,
//                                 size: 20,
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Hello,",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.grey[800],
//                                   ),
//                                 ),
//                                 Text(
//                                   isGuest ? "Guest User" : (user?.displayName ?? user?.email?.split('@')[0] ?? "User"),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         // 关闭按钮
//                         IconButton(
//                           icon: Icon(Icons.close, color: Colors.grey[700]),
//                           onPressed: () => Navigator.pop(context),
//                           padding: EdgeInsets.zero,
//                           constraints: BoxConstraints(),
//                           iconSize: 18,
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 12),
//
//                     // 分隔线
//                     Divider(color: Colors.grey[300], height: 1),
//
//                     const SizedBox(height: 12),
//
//                     // 主题切换部分
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Theme",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Row(
//                           children: [
//                             // 浅色主题按钮
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   if (isDarkMode) themeProvider.toggleTheme();
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 6),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: isDarkMode ? Colors.grey[400]! : colorScheme.primary,
//                                       width: 1,
//                                     ),
//                                     borderRadius: const BorderRadius.horizontal(
//                                       left: Radius.circular(6),
//                                     ),
//                                     color: isDarkMode ? Colors.transparent : colorScheme.primary.withOpacity(0.1),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.light_mode_outlined,
//                                         size: 14,
//                                         color: isDarkMode ? Colors.grey[600] : colorScheme.primary,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         "Light",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: isDarkMode ? FontWeight.normal : FontWeight.w500,
//                                           color: isDarkMode ? Colors.grey[600] : colorScheme.primary,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // 深色主题按钮
//                             Expanded(
//                               child: GestureDetector(
//                                 onTap: () {
//                                   if (!isDarkMode) themeProvider.toggleTheme();
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 6),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: !isDarkMode ? Colors.grey[400]! : colorScheme.primary,
//                                       width: 1,
//                                     ),
//                                     borderRadius: const BorderRadius.horizontal(
//                                       right: Radius.circular(6),
//                                     ),
//                                     color: !isDarkMode ? Colors.transparent : colorScheme.primary.withOpacity(0.1),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.dark_mode_outlined,
//                                         size: 14,
//                                         color: !isDarkMode ? Colors.grey[600] : colorScheme.primary,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         "Dark",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: !isDarkMode ? FontWeight.normal : FontWeight.w500,
//                                           color: !isDarkMode ? Colors.grey[600] : colorScheme.primary,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               // 菜单项列表
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Column(
//                       children: menuItems,
//                     ),
//                   ),
//                 ),
//               ),
//
//               // 底部登出按钮
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
//                 child: _buildMenuItem(
//                   context,
//                   'Logout',
//                   Icons.logout_outlined,
//                       () async {
//                     await FirebaseAuth.instance.signOut();
//                     Navigator.pop(context);
//                     Navigator.pushReplacementNamed(context, '/login');
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // 构建菜单项的帮助方法
//   Widget _buildMenuItem(
//       BuildContext context,
//       String title,
//       IconData icon,
//       VoidCallback onTap, {
//         bool isLogout = false,
//       }) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
//       leading: Icon(
//         icon,
//         size: 18,
//         color: Colors.grey[700],
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//           color: Colors.grey[800],
//         ),
//       ),
//       onTap: onTap,
//       minLeadingWidth: 16,
//       horizontalTitleGap: 6,
//       visualDensity: VisualDensity.compact,
//     );
//   }
// }
//
// //version 3 with upgrade background blur
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:provider/provider.dart';
// // import 'dart:ui';
// // import 'screens/settings_screen.dart';
// // import 'screens/profile_screen.dart';
// // import 'screens/my_journey/my_journey_screen.dart';
// // import 'theme.dart';
// //
// // class SideBar extends StatelessWidget {
// //   const SideBar({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return CustomDrawer();
// //   }
// // }
// //
// // class CustomDrawer extends StatefulWidget {
// //   const CustomDrawer({Key? key}) : super(key: key);
// //
// //   @override
// //   _CustomDrawerState createState() => _CustomDrawerState();
// // }
// //
// // class _CustomDrawerState extends State<CustomDrawer> with SingleTickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   late Animation<double> _animation;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 250),
// //     );
// //     _animation = CurvedAnimation(
// //       parent: _animationController,
// //       curve: Curves.easeInOut,
// //     );
// //     _animationController.forward();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }
// //
// //   void _closeDrawer() {
// //     _animationController.reverse().then((value) {
// //       Navigator.of(context).pop();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final user = FirebaseAuth.instance.currentUser;
// //     final bool isGuest = user == null;
// //     final themeProvider = Provider.of<ThemeProvider>(context);
// //     final isDarkMode = themeProvider.isDarkMode;
// //     final theme = Theme.of(context);
// //     final colorScheme = theme.colorScheme;
// //
// //     // 获取屏幕尺寸
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final drawerWidth = screenWidth * 0.7; // 设置侧边栏宽度为屏幕宽度的70%
// //
// //     // 创建菜单项列表
// //     final List<Widget> menuItems = [
// //       _buildMenuItem(
// //         context,
// //         'Home',
// //         Icons.home_outlined,
// //             () {
// //           _closeDrawer();
// //           if (ModalRoute.of(context)?.settings.name != '/') {
// //             Navigator.pushNamedAndRemoveUntil(
// //                 context, '/', (route) => false);
// //           }
// //         },
// //       ),
// //       _buildMenuItem(
// //         context,
// //         'Profile',
// //         Icons.person_outline,
// //             () {
// //           _closeDrawer();
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (context) => const ProfileScreen(),
// //             ),
// //           );
// //         },
// //       ),
// //       _buildMenuItem(
// //         context,
// //         '3min CBT Training',
// //         Icons.school_outlined,
// //             () {
// //           _closeDrawer();
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("CBT Training page coming soon!"),
// //             ),
// //           );
// //         },
// //       ),
// //       _buildMenuItem(
// //         context,
// //         '1min Journal Writing',
// //         Icons.edit_note_outlined,
// //             () {
// //           _closeDrawer();
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("Journal page coming soon!"),
// //             ),
// //           );
// //         },
// //       ),
// //       _buildMenuItem(
// //         context,
// //         'Your Data',
// //         Icons.data_usage_outlined,
// //             () {
// //           _closeDrawer();
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("Your data page coming soon!"),
// //             ),
// //           );
// //         },
// //       ),
// //       _buildMenuItem(
// //         context,
// //         'Your Badges',
// //         Icons.military_tech_outlined,
// //             () {
// //           _closeDrawer();
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("Your badges page coming soon!"),
// //             ),
// //           );
// //         },
// //       ),
// //     ];
// //
// //     return AnimatedBuilder(
// //       animation: _animation,
// //       builder: (context, child) {
// //         return Stack(
// //           children: [
// //             // 半透明背景遮罩，点击可关闭抽屉
// //             GestureDetector(
// //               onTap: _closeDrawer,
// //               child: Container(
// //                 width: screenWidth,
// //                 height: double.infinity,
// //                 color: Colors.black.withOpacity(0.3 * _animation.value),
// //               ),
// //             ),
// //             // 侧边栏
// //             Transform.translate(
// //               offset: Offset((1 - _animation.value) * -drawerWidth, 0),
// //               child: SizedBox(
// //                 width: drawerWidth,
// //                 height: double.infinity,
// //                 child: Stack(
// //                   children: [
// //                     // 高斯模糊背景效果
// //                     Positioned.fill(
// //                       child: BackdropFilter(
// //                         filter: ImageFilter.blur(
// //                           sigmaX: 10.0 * _animation.value,
// //                           sigmaY: 10.0 * _animation.value,
// //                         ),
// //                         child: Container(
// //                           decoration: BoxDecoration(
// //                             color: (isDarkMode ? Colors.black : Colors.white).withOpacity(0.85),
// //                             borderRadius: const BorderRadius.only(
// //                               topRight: Radius.circular(20),
// //                               bottomRight: Radius.circular(20),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     // 侧边栏内容
// //                     ClipRRect(
// //                       borderRadius: const BorderRadius.only(
// //                         topRight: Radius.circular(20),
// //                         bottomRight: Radius.circular(20),
// //                       ),
// //                       child: Column(
// //                         children: [
// //                           // 顶部用户信息区域
// //                           Container(
// //                             padding: const EdgeInsets.all(16.0),
// //                             width: double.infinity,
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Row(
// //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     // 用户头像和欢迎信息
// //                                     Row(
// //                                       children: [
// //                                         Container(
// //                                           width: 40,
// //                                           height: 40,
// //                                           decoration: BoxDecoration(
// //                                             shape: BoxShape.circle,
// //                                             border: Border.all(color: Colors.grey[300]!, width: 1),
// //                                           ),
// //                                           child: Icon(
// //                                             Icons.person_outline,
// //                                             size: 20,
// //                                             color: Colors.grey[700],
// //                                           ),
// //                                         ),
// //                                         const SizedBox(width: 10),
// //                                         Column(
// //                                           crossAxisAlignment: CrossAxisAlignment.start,
// //                                           children: [
// //                                             Text(
// //                                               "Hello,",
// //                                               style: TextStyle(
// //                                                 fontSize: 14,
// //                                                 fontWeight: FontWeight.w600,
// //                                                 color: Colors.grey[800],
// //                                               ),
// //                                             ),
// //                                             Text(
// //                                               isGuest ? "Guest User" : (user?.displayName ?? user?.email?.split('@')[0] ?? "User"),
// //                                               style: TextStyle(
// //                                                 fontSize: 12,
// //                                                 color: Colors.grey[600],
// //                                               ),
// //                                               overflow: TextOverflow.ellipsis,
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ],
// //                                     ),
// //                                     // 关闭按钮
// //                                     IconButton(
// //                                       icon: Icon(Icons.close, color: Colors.grey[700]),
// //                                       onPressed: _closeDrawer,
// //                                       padding: EdgeInsets.zero,
// //                                       constraints: const BoxConstraints(),
// //                                       iconSize: 18,
// //                                     ),
// //                                   ],
// //                                 ),
// //
// //                                 const SizedBox(height: 12),
// //
// //                                 // 分隔线
// //                                 Divider(color: Colors.grey[300], height: 1),
// //
// //                                 const SizedBox(height: 12),
// //
// //                                 // 主题切换部分
// //                                 Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text(
// //                                       "Theme",
// //                                       style: TextStyle(
// //                                         fontSize: 12,
// //                                         fontWeight: FontWeight.w500,
// //                                         color: Colors.grey[700],
// //                                       ),
// //                                     ),
// //                                     const SizedBox(height: 6),
// //                                     Row(
// //                                       children: [
// //                                         // 浅色主题按钮
// //                                         Expanded(
// //                                           child: GestureDetector(
// //                                             onTap: () {
// //                                               if (isDarkMode) themeProvider.toggleTheme();
// //                                             },
// //                                             child: Container(
// //                                               padding: const EdgeInsets.symmetric(vertical: 6),
// //                                               decoration: BoxDecoration(
// //                                                 border: Border.all(
// //                                                   color: isDarkMode ? Colors.grey[400]! : colorScheme.primary,
// //                                                   width: 1,
// //                                                 ),
// //                                                 borderRadius: const BorderRadius.horizontal(
// //                                                   left: Radius.circular(6),
// //                                                 ),
// //                                                 color: isDarkMode ? Colors.transparent : colorScheme.primary.withOpacity(0.1),
// //                                               ),
// //                                               child: Row(
// //                                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                                 children: [
// //                                                   Icon(
// //                                                     Icons.light_mode_outlined,
// //                                                     size: 14,
// //                                                     color: isDarkMode ? Colors.grey[600] : colorScheme.primary,
// //                                                   ),
// //                                                   const SizedBox(width: 4),
// //                                                   Text(
// //                                                     "Light",
// //                                                     style: TextStyle(
// //                                                       fontSize: 12,
// //                                                       fontWeight: isDarkMode ? FontWeight.normal : FontWeight.w500,
// //                                                       color: isDarkMode ? Colors.grey[600] : colorScheme.primary,
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ),
// //                                         // 深色主题按钮
// //                                         Expanded(
// //                                           child: GestureDetector(
// //                                             onTap: () {
// //                                               if (!isDarkMode) themeProvider.toggleTheme();
// //                                             },
// //                                             child: Container(
// //                                               padding: const EdgeInsets.symmetric(vertical: 6),
// //                                               decoration: BoxDecoration(
// //                                                 border: Border.all(
// //                                                   color: !isDarkMode ? Colors.grey[400]! : colorScheme.primary,
// //                                                   width: 1,
// //                                                 ),
// //                                                 borderRadius: const BorderRadius.horizontal(
// //                                                   right: Radius.circular(6),
// //                                                 ),
// //                                                 color: !isDarkMode ? Colors.transparent : colorScheme.primary.withOpacity(0.1),
// //                                               ),
// //                                               child: Row(
// //                                                 mainAxisAlignment: MainAxisAlignment.center,
// //                                                 children: [
// //                                                   Icon(
// //                                                     Icons.dark_mode_outlined,
// //                                                     size: 14,
// //                                                     color: !isDarkMode ? Colors.grey[600] : colorScheme.primary,
// //                                                   ),
// //                                                   const SizedBox(width: 4),
// //                                                   Text(
// //                                                     "Dark",
// //                                                     style: TextStyle(
// //                                                       fontSize: 12,
// //                                                       fontWeight: !isDarkMode ? FontWeight.normal : FontWeight.w500,
// //                                                       color: !isDarkMode ? Colors.grey[600] : colorScheme.primary,
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //
// //                           // 菜单项列表
// //                           Expanded(
// //                             child: SingleChildScrollView(
// //                               child: Padding(
// //                                 padding: const EdgeInsets.symmetric(horizontal: 12),
// //                                 child: Column(
// //                                   children: menuItems,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //
// //                           // 底部登出按钮
// //                           Padding(
// //                             padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
// //                             child: _buildMenuItem(
// //                               context,
// //                               'Logout',
// //                               Icons.logout_outlined,
// //                                   () async {
// //                                 _closeDrawer();
// //                                 await FirebaseAuth.instance.signOut();
// //                                 Navigator.pushReplacementNamed(context, '/login');
// //                               },
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //
// //                     // 添加向左滑动关闭侧边栏的手势
// //                     Positioned.fill(
// //                       child: GestureDetector(
// //                         onHorizontalDragUpdate: (details) {
// //                           if (details.delta.dx < -6) {
// //                             _closeDrawer();
// //                           }
// //                         },
// //                         behavior: HitTestBehavior.translucent,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   // 构建菜单项的帮助方法
// //   Widget _buildMenuItem(
// //       BuildContext context,
// //       String title,
// //       IconData icon,
// //       VoidCallback onTap,
// //       ) {
// //     return ListTile(
// //       contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
// //       leading: Icon(
// //         icon,
// //         size: 18,
// //         color: Colors.grey[700],
// //       ),
// //       title: Text(
// //         title,
// //         style: TextStyle(
// //           fontSize: 14,
// //           fontWeight: FontWeight.w400,
// //           color: Colors.grey[800],
// //         ),
// //       ),
// //       onTap: onTap,
// //       minLeadingWidth: 16,
// //       horizontalTitleGap: 6,
// //       visualDensity: VisualDensity.compact,
// //     );
// //   }
// // }
// //
// // // 在应用程序中使用方法
// // // Scaffold(
// // //   drawer: SideBar(),
// // //   ...
// // // )


//version 3
//version 3
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'screens/profile_screen.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("CBT Training page coming soon!"),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Journal page coming soon!"),
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
        //Icons.star_outline,
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
                                      : (user?.displayName ?? user?.email?.split('@')[0] ?? "User"),
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
                            color: colorScheme.primaryContainer.withOpacity(0.7),
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
                        color: isDarkMode
                            ? Color(0xFF353530)
                            : Colors.white,
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
                                padding: const EdgeInsets.symmetric(vertical: 12),
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
                                padding: const EdgeInsets.symmetric(vertical: 12),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16), // 减少垂直间距
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