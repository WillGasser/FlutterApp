import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './theme.dart';
import 'sidebar.dart';
import 'screens/thought_log.dart';
import 'screens/CBT_Training.dart';
import 'welcome_overlay.dart';
import 'data/user_stats.dart';

class HomePage extends StatefulWidget {
  final bool isNewLogin;
  final String type;
  const HomePage({Key? key, required this.isNewLogin, required this.type})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 1; // Home is the default selected index.
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final UserStatsService _statsService = UserStatsService();

  // Data for charts and metrics
  int _thoughtLogCount = 0;
  int _cbtExerciseCount = 0;
  int _daysStreak = 0;
  List<int> _weeklyActivityData = List.filled(7, 0); // Activity data for 7 days

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize loading state
      setState(() {
        _isLoading = true;
      });

      // Show welcome overlay for new login
      if (widget.isNewLogin) {
        print('Showing welcome overlay for new login.');
        await WelcomeManager.showWelcomeIfNeeded(context, widget.type);

        // Update the user's login streak
        await _statsService.updateLoginStreak();
      }

      // Fetch user data
      await _fetchUserData();

      // Start animation after data is loaded
      _animationController.forward();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing app: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user == null) {
        // Generate mock data for guest users
        _generateMockData();
        return;
      }

      // Update all stats and get the latest values
      final stats = await _statsService.updateAllStats();

      setState(() {
        _thoughtLogCount = stats.thoughtLogCount;
        _cbtExerciseCount = stats.cbtExerciseCount;
        _daysStreak = stats.daysStreak;
        _weeklyActivityData = stats.weeklyActivityData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      // Fallback to mock data if there's an error
      _generateMockData();
    }
  }

  // Generate mock data for demos and guest users
  void _generateMockData() {
    setState(() {
      _thoughtLogCount = 0;
      _cbtExerciseCount = 0;
      _daysStreak = 0;

      // Generate random weekly activity data
      final random = DateTime.now().millisecondsSinceEpoch;
      _weeklyActivityData = List.generate(7, (i) {
        return (((random + i * 17) % 3)); // Less random activity for guest mode
      });
    });
  }

  void _onItemTapped(int index) {
    // Do nothing if tapping the already-selected item.
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the appropriate screen based on the selected index.
    if (index == 0) {
      // Navigate to CBT training screen.
      Navigator.of(context)
          .push(
            MaterialPageRoute(builder: (context) => const CBTScreen()),
          )
          .then((_) => _fetchUserData()); // Refresh data when returning
    } else if (index == 2) {
      // Navigate to Thought log screen.
      Navigator.of(context)
          .push(
            MaterialPageRoute(builder: (context) => const ThoughtLogScreen()),
          )
          .then((_) => _fetchUserData()); // Refresh data when returning
    }
    // If index == 1, it's Home, so we remain on the current page.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'HOOM',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      drawer: const SideBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _fetchUserData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome section
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              colorScheme.primary,
                              colorScheme.primaryContainer ??
                                  colorScheme.primary.withOpacity(0.7)
                            ]
                          : [
                              colorScheme.primary,
                              colorScheme.primaryContainer ??
                                  colorScheme.primary.withOpacity(0.7)
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'How are you today?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: isDark ? 0.5 : 0.3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ThoughtLogScreen(),
                                      ),
                                    )
                                    .then((_) => _fetchUserData());
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Start Thought Log'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.psychology_outlined,
                          size: 50,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Quick stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Thought Logs',
                        _thoughtLogCount.toString(),
                        Icons.edit_note,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'CBT Exercises',
                        _cbtExerciseCount.toString(),
                        Icons.lightbulb_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Day Streak',
                        _daysStreak.toString(),
                        Icons.local_fire_department_outlined,
                        isStreak: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Weekly activity chart section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weekly Activity',
                            style: theme.textTheme.titleLarge,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.grey[800] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'This Week',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 180,
                        child: _buildSimpleWeeklyActivityChart(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Features quick access
                Text(
                  'Quick Access',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureButton(
                        context,
                        'Record Thoughts',
                        Icons.edit_note,
                        colorScheme.primary,
                        () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ThoughtLogScreen(),
                                ),
                              )
                              .then((_) => _fetchUserData());
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFeatureButton(
                        context,
                        'CBT Training',
                        Icons.lightbulb_outline,
                        colorScheme.secondary,
                        () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => const CBTScreen(),
                                ),
                              )
                              .then((_) => _fetchUserData());
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildFeatureButton(
                        context,
                        'View Progress',
                        Icons.insights,
                        colorScheme.tertiary,
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Progress tracking coming soon!')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFeatureButton(
                        context,
                        'Meditation',
                        Icons.self_improvement,
                        isDark ? Colors.green.shade700 : Colors.green.shade600,
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Meditation features coming soon!')),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: theme,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              activeIcon: Icon(Icons.lightbulb),
              label: 'CBT',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_outlined),
              activeIcon: Icon(Icons.edit_note),
              label: 'Thoughts',
            ),
          ],
        ),
      ),
    );
  }

  // Build custom weekly activity chart without using fl_chart
  Widget _buildSimpleWeeklyActivityChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodySmall?.color;
    final primaryColor = theme.colorScheme.primary;
    final now = DateTime.now();

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final day = now.subtract(Duration(days: 6 - index));
              final dayAbbr = DateFormat('E').format(day)[0];
              final value = _weeklyActivityData[index];
              final maxValue =
                  _weeklyActivityData.reduce((a, b) => a > b ? a : b);
              final height = maxValue > 0 ? (value / maxValue) * 0.8 : 0.0;

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800 + (index * 100)),
                      height: height * 120, // Max height is 120
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.8),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
                      ),
                      child: Center(
                        child: value > 0
                            ? Text(
                                value.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dayAbbr,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Thought log entries',
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Build statistics card
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool isStreak = false,
  }) {
    final theme = Theme.of(context);
    final iconColor = isStreak ? Colors.orange : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  // Build feature quick access button
  Widget _buildFeatureButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
