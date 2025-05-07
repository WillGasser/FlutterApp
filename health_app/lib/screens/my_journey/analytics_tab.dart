import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../data/user_stats.dart';
import '../../theme.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({Key? key}) : super(key: key);

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  bool _isLoading = true;
  final UserStatsService _statsService = UserStatsService();

  // User stats data
  int _thoughtLogCount = 0;
  int _cbtExerciseCount = 0;
  int _daysStreak = 0;
  List<int> _weeklyActivityData = List.filled(7, 0);
  DateTime? _lastActiveDate;

  // Additional analytics
  Map<String, int> _exerciseTypeDistribution = {};
  List<Map<String, dynamic>> _monthlyProgress = [];
  double _completionRate = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAnalyticsData();
  }

  Future<void> _fetchAnalyticsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get basic user stats
      final stats = await _statsService.getUserStats();

      // Get additional analytics data
      await _fetchAdditionalAnalytics();

      if (mounted) {
        setState(() {
          _thoughtLogCount = stats.thoughtLogCount;
          _cbtExerciseCount = stats.cbtExerciseCount;
          _daysStreak = stats.daysStreak;
          _weeklyActivityData = stats.weeklyActivityData;
          _lastActiveDate = stats.lastActiveDate;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching analytics data: $e');
      if (mounted) {
        setState(() {
          // Generate mock data for demo purposes
          _generateMockData();
          _isLoading = false;
        });
      }
    }
  }

  void _generateMockData() {
    // Basic stats
    _thoughtLogCount = 7;
    _cbtExerciseCount = 5;
    _daysStreak = 3;
    _weeklyActivityData = [0, 1, 2, 1, 3, 0, 2];
    _lastActiveDate = DateTime.now();

    // Additional analytics
    _exerciseTypeDistribution = {
      'Thought Record': 3,
      'CBT Basics': 2,
      'Mindfulness': 2,
      'Challenging Beliefs': 1,
      'Managing Anxiety': 1,
    };

    _monthlyProgress = [
      {'month': 'Jan', 'count': 4},
      {'month': 'Feb', 'count': 6},
      {'month': 'Mar', 'count': 5},
      {'month': 'Apr', 'count': 8},
      {'month': 'May', 'count': 10},
    ];

    _completionRate = 0.65;
  }

  Future<void> _fetchAdditionalAnalytics() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Get exercise type distribution
      final exercisesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('completed_cbt_exercises')
          .get();

      final exerciseTypes = <String, int>{};
      for (var doc in exercisesSnapshot.docs) {
        final type = doc.data()['exerciseTitle'] as String? ?? 'Unknown';
        exerciseTypes[type] = (exerciseTypes[type] ?? 0) + 1;
      }

      // Generate monthly progress data (last 5 months)
      final now = DateTime.now();
      final monthlyData = <Map<String, dynamic>>[];

      for (int i = 4; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        final monthName = DateFormat('MMM').format(month);

        // This would ideally use real data from Firestore with a query
        // Here we're just generating sample data
        final count = 4 + i + (i % 3); // Sample increasing pattern

        monthlyData.add({
          'month': monthName,
          'count': count,
        });
      }

      // Calculate completion rate (completed / started)
      // This is just a mock calculation for demonstration
      final completionRate = _cbtExerciseCount > 0
          ? _cbtExerciseCount / (_cbtExerciseCount + 3)
          : 0.0;

      if (mounted) {
        setState(() {
          _exerciseTypeDistribution = exerciseTypes;
          _monthlyProgress = monthlyData;
          _completionRate = completionRate;
        });
      }
    } catch (e) {
      print('Error fetching additional analytics: $e');
      // Fallback to mock data if there's an error
      _exerciseTypeDistribution = {
        'Thought Record': 2,
        'CBT Basics': 1,
        'Mindfulness': 1,
      };

      _monthlyProgress = [
        {'month': 'Jan', 'count': 2},
        {'month': 'Feb', 'count': 3},
        {'month': 'Mar', 'count': 4},
        {'month': 'Apr', 'count': 3},
        {'month': 'May', 'count': 5},
      ];

      _completionRate = 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAnalyticsData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: 'Thought Logs',
                    value: _thoughtLogCount.toString(),
                    icon: Icons.edit_note,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: 'CBT Exercises',
                    value: _cbtExerciseCount.toString(),
                    icon: Icons.lightbulb_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: 'Day Streak',
                    value: _daysStreak.toString(),
                    icon: Icons.local_fire_department,
                    isHighlighted: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: 'Completion Rate',
                    value: '${(_completionRate * 100).toInt()}%',
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Weekly Activity',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Weekly activity chart
            Container(
              height: 200,
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
              child: _buildWeeklyActivityChart(context),
            ),

            const SizedBox(height: 24),
            Text(
              'Exercise Types',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Exercise type distribution
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
              child: _exerciseTypeDistribution.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No exercise data yet',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : Column(
                      children: _exerciseTypeDistribution.entries.map((entry) {
                        return _buildProgressBar(
                          context,
                          label: entry.key,
                          value: entry.value,
                          total: _exerciseTypeDistribution.values
                              .fold(0, (sum, value) => sum + value),
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 24),
            Text(
              'Monthly Progress',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Monthly progress chart
            Container(
              height: 220,
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
              child: _buildMonthlyProgressChart(context),
            ),

            const SizedBox(height: 24),

            if (_lastActiveDate != null)
              Center(
                child: Text(
                  'Last activity: ${DateFormat('MMMM d, yyyy').format(_lastActiveDate!)}',
                  style: theme.textTheme.bodySmall,
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    bool isHighlighted = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color iconColor =
        isHighlighted ? Colors.orange : theme.colorScheme.primary;

    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityChart(BuildContext context) {
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
                          top: Radius.circular(6),
                        ),
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
              'Total activities',
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

  Widget _buildProgressBar(
    BuildContext context, {
    required String label,
    required int value,
    required int total,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final percentage = total > 0 ? (value / total) : 0.0;

    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.green,
      Colors.amber,
      Colors.orange,
      Colors.red,
    ];

    // Choose color based on label's first character
    final colorIndex = label.isEmpty ? 0 : label.codeUnitAt(0) % colors.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '$value exercises',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              return Stack(
                children: [
                  // Background
                  Container(
                    height: 8,
                    width: width,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Foreground
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    height: 8,
                    width: width * percentage,
                    decoration: BoxDecoration(
                      color: colors[colorIndex],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyProgressChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodySmall?.color;
    final secondaryColor = theme.colorScheme.secondary;

    if (_monthlyProgress.isEmpty) {
      return Center(
        child: Text(
          'No monthly data available',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    final maxValue = _monthlyProgress
        .map((item) => item['count'] as int)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(_monthlyProgress.length, (index) {
              final item = _monthlyProgress[index];
              final month = item['month'] as String;
              final count = item['count'] as int;
              final height = maxValue > 0 ? (count / maxValue) * 0.8 : 0.0;

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 800 + (index * 100)),
                      height: height * 140, // Max height is 140
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.8),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                      child: Center(
                        child: count > 0
                            ? Text(
                                count.toString(),
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
                      month,
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
                color: secondaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Total activities by month',
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
}
