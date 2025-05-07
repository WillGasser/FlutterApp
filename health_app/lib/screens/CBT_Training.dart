import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../sidebar.dart';
import '../theme.dart';
import '../data/user_stats.dart';
import '../data/cbt_exercise.dart';
import '../services/exercise_service.dart';
import '../screens/detailed_exercise_screen.dart';

class CBTScreen extends StatefulWidget {
  final int initialTabIndex;

  const CBTScreen({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  State<CBTScreen> createState() => _CBTScreenState();
}

class _CBTScreenState extends State<CBTScreen>
    with SingleTickerProviderStateMixin {
  final UserStatsService _statsService = UserStatsService();
  bool _isLoading = true;
  List<CBTExercise> _completedExercises = [];
  List<String> _completedExerciseIds = [];
  int _userProgressIndex = 0;
  Map<String, dynamic>? _nextExercise;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = widget.initialTabIndex;
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      // Load completed exercises
      await _loadCompletedExercises();

      // Determine user's progress in the learning path
      _calculateUserProgress();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading CBT data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          // For guest mode, mark first exercise as available
          _nextExercise = ExerciseService.getLearningPath().first;
        });
      }
    }
  }

  Future<void> _loadCompletedExercises() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get completed exercises from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cbt_exercises')
          .get();

      if (mounted) {
        final exercises = snapshot.docs.map((doc) {
          final data = doc.data();
          return CBTExercise(
            id: doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            type: data['exerciseType'] ?? '',
            durationMinutes: 15, // Default value
            completedDate: (data['completedDate'] as Timestamp?)?.toDate(),
            notes: data['notes'],
          );
        }).toList();

        setState(() {
          _completedExercises = exercises;

          // Extract the exercise IDs that have been completed
          _completedExerciseIds = exercises
              .map((e) {
                // Extract the exercise ID from the title or description
                for (var availableExercise
                    in ExerciseService.availableExercises) {
                  if (e.title.contains(availableExercise['title'] ?? '')) {
                    return availableExercise['id'];
                  }
                }
                return null;
              })
              .whereType<String>()
              .toList();
        });
      }
    } else {
      // For guest users, start with empty completed exercises
      if (mounted) {
        setState(() {
          _completedExercises = [];
          _completedExerciseIds = [];
        });
      }
    }
  }

  void _calculateUserProgress() {
    final learningPath = ExerciseService.getLearningPath();

    // Find the highest completed exercise index
    int highestCompletedIndex = -1;

    for (int i = 0; i < learningPath.length; i++) {
      if (_completedExerciseIds.contains(learningPath[i]['id'])) {
        highestCompletedIndex = i;
      }
    }

    // The next exercise is the one after the highest completed one
    int nextExerciseIndex = highestCompletedIndex + 1;

    // If we're at the end of the path, recommend the last exercise again
    if (nextExerciseIndex >= learningPath.length) {
      nextExerciseIndex = learningPath.length - 1;
    }

    setState(() {
      _userProgressIndex = highestCompletedIndex + 1;
      _nextExercise = learningPath[nextExerciseIndex];
    });
  }

  void _launchExercise(String id, String title, String type) {
    // Find the correct path for the exercise
    final exerciseInfo = ExerciseService.availableExercises.firstWhere(
      (e) => e['id'] == id,
      orElse: () => {'path': ''},
    );

    if (exerciseInfo['path']!.isEmpty) {
      _showErrorDialog('Exercise not found',
          'Sorry, the exercise content could not be found.');
      return;
    }

    // Check if exercise is unlocked based on learning path
    if (!ExerciseService.isExerciseUnlocked(id, _completedExerciseIds)) {
      _showErrorDialog('Exercise Locked',
          'You need to complete previous exercises in the learning path first.');
      return;
    }

    // Launch the detailed exercise screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedExerciseScreen(
          exerciseJsonPath: exerciseInfo['path']!,
          exerciseTitle: title,
          exerciseType: type,
        ),
      ),
    ).then((_) {
      // Refresh data when returning to this screen
      _loadUserData();
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Column(
      children: [
        Container(
          color: theme.primaryColor,
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            isScrollable:
                isSmallScreen, // Make tabs scrollable on small screens
            labelStyle: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
            ),
            tabs: const [
              Tab(text: 'Lessons'),
              Tab(text: 'Progress'),
              Tab(text: 'Badges'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLessonsTab(),
              _buildProgressTab(),
              _buildAchievementsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLessonsTab() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Get screen width for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0;
    final spacing = screenWidth < 400 ? 16.0 : 24.0;

    return RefreshIndicator(
      onRefresh: _loadUserData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroductionSection(context, isDark),
            SizedBox(height: spacing),
            _buildLearningPathProgress(context, isDark),
            SizedBox(height: spacing),
            if (_nextExercise != null) _buildNextExerciseCard(context, isDark),
            if (_nextExercise != null) SizedBox(height: spacing),
            _buildAllExercisesSection(context, isDark),
            // Add bottom padding for better scrolling experience
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0;
    final spacing = screenWidth < 400 ? 12.0 : 16.0;
    final isSmallScreen = screenWidth < 400;

    return RefreshIndicator(
      onRefresh: _loadUserData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isSmallScreen ? 20 : 24,
                  ),
            ),
            SizedBox(height: spacing),
            FutureBuilder<UserStats>(
              future: _statsService.getUserStats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stats = snapshot.data ??
                    UserStats(
                      weeklyActivityData: List.filled(7, 0),
                      lastActiveDate: DateTime.now(),
                    );

                final totalExercises = ExerciseService.getLearningPath().length;
                final completedCount = _completedExerciseIds.length;
                final percentComplete =
                    (completedCount * 100 / totalExercises).round();

                // For very small screens, stack the stats vertically
                if (isSmallScreen) {
                  return Column(
                    children: [
                      _buildProgressStat(
                        context,
                        'Modules',
                        '$completedCount',
                        'Completed',
                        isDark ? Colors.teal : Colors.teal,
                      ),
                      SizedBox(height: spacing),
                      _buildProgressStat(
                        context,
                        'Completion',
                        '$percentComplete%',
                        'Complete',
                        isDark ? Colors.blue : Colors.blue,
                      ),
                      SizedBox(height: spacing),
                      _buildProgressStat(
                        context,
                        'Streak',
                        '${stats.daysStreak}',
                        'Days',
                        isDark ? Colors.orange : Colors.orange,
                      ),
                      SizedBox(height: spacing),
                      _buildProgressStat(
                        context,
                        'Time Spent',
                        '${completedCount * 15}',
                        'Minutes',
                        isDark ? Colors.purple : Colors.purple,
                      ),
                    ],
                  );
                }

                // For larger screens, use the 2x2 grid
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildProgressStat(
                            context,
                            'Modules',
                            '$completedCount',
                            'Completed',
                            isDark ? Colors.teal : Colors.teal,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: _buildProgressStat(
                            context,
                            'Completion',
                            '$percentComplete%',
                            'Complete',
                            isDark ? Colors.blue : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing),
                    Row(
                      children: [
                        Expanded(
                          child: _buildProgressStat(
                            context,
                            'Streak',
                            '${stats.daysStreak}',
                            'Days',
                            isDark ? Colors.orange : Colors.orange,
                          ),
                        ),
                        SizedBox(width: spacing),
                        Expanded(
                          child: _buildProgressStat(
                            context,
                            'Time Spent',
                            '${completedCount * 15}',
                            'Minutes',
                            isDark ? Colors.purple : Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            // Add extra content - User Tips section
            SizedBox(height: spacing * 1.5),
            Text(
              'Tips to Improve Your Practice',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isSmallScreen ? 20 : 24,
                  ),
            ),
            SizedBox(height: spacing),
            _buildTipCard(
              context,
              'Consistent Practice',
              'Try to complete at least one CBT exercise daily for maximum benefit.',
              Icons.calendar_today,
              isDark ? Colors.teal.shade300 : Colors.teal,
            ),
            SizedBox(height: spacing),
            _buildTipCard(
              context,
              'Apply in Real Life',
              'Use the techniques you learn when facing challenging situations.',
              Icons.psychology,
              isDark ? Colors.amber.shade300 : Colors.amber,
            ),
            // Add bottom padding for better scrolling experience
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsTab() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 12.0 : 16.0;
    final spacing = screenWidth < 400 ? 12.0 : 16.0;
    final isSmallScreen = screenWidth < 400;

    final totalExercises = ExerciseService.getLearningPath().length;
    final completedCount = _completedExerciseIds.length;
    final percentComplete = (completedCount * 100 / totalExercises).round();

    return RefreshIndicator(
      onRefresh: _loadUserData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Badges',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isSmallScreen ? 20 : 24,
                  ),
            ),
            SizedBox(height: spacing),
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Badges earned: ${_getUnlockedAchievementsCount(completedCount, percentComplete)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAchievementCard(
              context,
              'CBT Beginner',
              'Completed your first CBT module',
              Icons.emoji_events,
              completedCount >= 1,
              Colors.amber,
            ),
            _buildAchievementCard(
              context,
              'Thought Detective',
              'Completed cognitive distortions module',
              Icons.psychology,
              _completedExerciseIds.contains('cd001'),
              Colors.purple,
            ),
            _buildAchievementCard(
              context,
              'Mindfulness Master',
              'Completed the mindfulness exercise',
              Icons.self_improvement,
              _completedExerciseIds.contains('mf001'),
              Colors.indigo,
            ),
            _buildAchievementCard(
              context,
              'CBT Champion',
              'Completed 50% of all CBT modules',
              Icons.military_tech,
              percentComplete >= 50,
              Colors.red,
            ),
            _buildAchievementCard(
              context,
              'CBT Master',
              'Completed all CBT modules',
              Icons.workspace_premium,
              percentComplete >= 100,
              Colors.green,
            ),

            // New achievements
            _buildAchievementCard(
              context,
              'Anxiety Manager',
              'Completed the anxiety management module',
              Icons.healing,
              _completedExerciseIds.contains('anx001'),
              Colors.blue,
            ),
            _buildAchievementCard(
              context,
              'Core Belief Explorer',
              'Challenged negative core beliefs',
              Icons.lightbulb,
              _completedExerciseIds.contains('cb001'),
              Colors.deepOrange,
            ),
            _buildAchievementCard(
              context,
              'Self-Compassion Practitioner',
              'Learned self-compassion techniques',
              Icons.favorite,
              _completedExerciseIds.contains('sc001'),
              Colors.pink,
            ),
            // Add bottom padding for better scrolling experience
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  int _getUnlockedAchievementsCount(int completedCount, int percentComplete) {
    int count = 0;
    if (completedCount >= 1) count++;
    if (_completedExerciseIds.contains('cd001')) count++;
    if (_completedExerciseIds.contains('mf001')) count++;
    if (percentComplete >= 50) count++;
    if (percentComplete >= 100) count++;
    if (_completedExerciseIds.contains('anx001')) count++;
    if (_completedExerciseIds.contains('cb001')) count++;
    if (_completedExerciseIds.contains('sc001')) count++;
    return count;
  }

  Widget _buildProgressStat(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    bool isUnlocked,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUnlocked
              ? color.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      color: isUnlocked
          ? (isDark ? Colors.grey[800] : Colors.white)
          : (isDark ? Colors.grey[850] : Colors.grey[100]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isUnlocked
                ? color.withOpacity(isDark ? 0.2 : 0.1)
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isUnlocked ? color : Colors.grey,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked
                ? (isDark ? Colors.white : Colors.black87)
                : Colors.grey,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: isUnlocked
                ? (isDark ? Colors.white70 : Colors.black54)
                : Colors.grey,
          ),
        ),
        trailing: isUnlocked
            ? Icon(Icons.check_circle, color: color)
            : Icon(Icons.lock, color: Colors.grey),
      ),
    );
  }

  Widget _buildIntroductionSection(BuildContext context, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  size: isSmallScreen ? 24 : 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Cognitive Behavioral Therapy',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: isSmallScreen ? 18 : 22,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'CBT helps you identify and change negative thought patterns and behaviors that affect your mood and wellbeing.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
            ),
            const SizedBox(height: 16),
            // Make chips wrap on small screens
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip('Evidence-based', Icons.verified_outlined),
                _buildInfoChip('Self-paced', Icons.timer_outlined),
                _buildInfoChip('Interactive', Icons.touch_app_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Chip(
      avatar: Icon(
        icon,
        size: isSmallScreen ? 14 : 16,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        label,
        style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 4 : 8, vertical: isSmallScreen ? 2 : 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildLearningPathProgress(BuildContext context, bool isDark) {
    final learningPath = ExerciseService.getLearningPath();
    final progress = (_userProgressIndex / learningPath.length).clamp(0.0, 1.0);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your CBT Journey',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
        ),
        const SizedBox(height: 8),
        // Make the progress labels responsive
        isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress: ${(_userProgressIndex * 100 ~/ learningPath.length)}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${_userProgressIndex}/${learningPath.length} modules',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress: ${(_userProgressIndex * 100 ~/ learningPath.length)}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${_userProgressIndex}/${learningPath.length} modules',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildNextExerciseCard(BuildContext context, bool isDark) {
    if (_nextExercise == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue Your Learning',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => _launchExercise(
              _nextExercise!['id'],
              _nextExercise!['title'],
              _nextExercise!['type'],
            ),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${_nextExercise!['order']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nextExercise!['title'],
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _nextExercise!['description'],
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => _launchExercise(
                          _nextExercise!['id'],
                          _nextExercise!['title'],
                          _nextExercise!['type'],
                        ),
                        icon: const Icon(Icons.play_arrow, size: 18),
                        label: Text(
                          'Start Now',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12 : 20,
                              vertical: isSmallScreen ? 8 : 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAllExercisesSection(BuildContext context, bool isDark) {
    final learningPath = ExerciseService.getLearningPath();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All CBT Modules',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: learningPath.length,
          itemBuilder: (context, index) {
            final exercise = learningPath[index];
            final exerciseId = exercise['id'];
            final isCompleted = _completedExerciseIds.contains(exerciseId);
            final isUnlocked = ExerciseService.isExerciseUnlocked(
                exerciseId, _completedExerciseIds);

            return _buildExerciseListItem(
              context,
              exercise['title'],
              exercise['description'],
              exercise['type'],
              exercise['order'].toString(),
              isDark,
              isCompleted,
              isUnlocked,
              () {
                if (isUnlocked) {
                  _launchExercise(
                    exerciseId,
                    exercise['title'],
                    exercise['type'],
                  );
                } else {
                  _showErrorDialog('Module Locked',
                      'You need to complete previous modules first.');
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildExerciseListItem(
    BuildContext context,
    String title,
    String description,
    String type,
    String order,
    bool isDark,
    bool isCompleted,
    bool isUnlocked,
    VoidCallback onTap,
  ) {
    Color getExerciseColor() {
      switch (type) {
        case 'cbt_basics':
          return Colors.blue;
        case 'cognitive_restructuring':
          return Colors.purple;
        case 'thought_record':
          return Colors.teal;
        case 'anxiety_management':
          return Colors.orange;
        case 'behavior_activation':
          return Colors.green;
        case 'mindfulness':
          return Colors.indigo;
        case 'core_beliefs':
          return Colors.red;
        case 'self_compassion':
          return Colors.pink;
        default:
          return Theme.of(context).colorScheme.primary;
      }
    }

    final exerciseColor = isCompleted
        ? Colors.green
        : (isUnlocked ? getExerciseColor() : Colors.grey);

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise number/order indicator
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: exerciseColor.withOpacity(0.2),
                ),
                child: Text(
                  order,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: exerciseColor,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              // Exercise content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        color: isUnlocked
                            ? (isDark ? Colors.white : Colors.black87)
                            : Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: isUnlocked
                            ? (isDark ? Colors.white70 : Colors.black54)
                            : Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Status indicator
              SizedBox(width: isSmallScreen ? 8 : 12),
              Icon(
                isCompleted
                    ? Icons.check_circle
                    : (isUnlocked ? Icons.play_circle_filled : Icons.lock),
                color: exerciseColor,
                size: isSmallScreen ? 20 : 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
