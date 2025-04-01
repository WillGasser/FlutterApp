import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../sidebar.dart';
import '../theme.dart';

class CBTScreen extends StatefulWidget {
  const CBTScreen({Key? key}) : super(key: key);

  @override
  State<CBTScreen> createState() => _CBTScreenState();
}

class _CBTScreenState extends State<CBTScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = isDark ? Colors.tealAccent : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CBT Training'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Learn'),
            Tab(text: 'Practice'),
            Tab(text: 'Progress'),
          ],
        ),
      ),
      drawer: const SideBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLearnTab(context, isDark, primaryColor),
          _buildPracticeTab(context, isDark, primaryColor),
          _buildProgressTab(context, isDark, primaryColor),
        ],
      ),
    );
  }

  // Learn tab content with CBT concepts
  Widget _buildLearnTab(BuildContext context, bool isDark, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is CBT?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Cognitive Behavioral Therapy (CBT) is a proven approach that helps you identify and change negative thought patterns that influence your emotions and behavior.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          // Core concepts card
          _buildConceptCard(
            context,
            'The CBT Triangle',
            'Understanding the relationship between thoughts, feelings, and behaviors',
            Icons.psychology,
            isDark ? Colors.purple.shade700 : Colors.purple.shade500,
          ),

          _buildConceptCard(
            context,
            'Identifying Thought Patterns',
            'Learn to recognize common cognitive distortions and unhelpful thinking styles',
            Icons.lightbulb_outline,
            isDark ? Colors.amber.shade700 : Colors.amber.shade600,
          ),

          _buildConceptCard(
            context,
            'Challenge Negative Thoughts',
            'Techniques to question and reframe negative automatic thoughts',
            Icons.remove_red_eye_outlined,
            isDark ? Colors.green.shade700 : Colors.green.shade600,
          ),

          _buildConceptCard(
            context,
            'Behavior Activation',
            'Break the cycle of low mood by engaging in positive activities',
            Icons.directions_walk,
            isDark ? Colors.red.shade700 : Colors.red.shade500,
          ),

          // Course modules section
          const SizedBox(height: 32),

          Text(
            'Course Modules',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          _buildCourseModule(
            context,
            'Introduction to CBT',
            'Foundational concepts and principles',
            '1',
            true, // Unlocked
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Module content coming soon!')),
              );
            },
          ),

          _buildCourseModule(
            context,
            'Identifying Thought Patterns',
            'Recognize common cognitive distortions',
            '2',
            true, // Unlocked
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Module content coming soon!')),
              );
            },
          ),

          _buildCourseModule(
            context,
            'Challenging Negative Thoughts',
            'Learn to question and reframe thoughts',
            '3',
            false, // Locked
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Complete previous modules to unlock')),
              );
            },
          ),

          _buildCourseModule(
            context,
            'Behavior Activation',
            'Breaking the cycle of low mood',
            '4',
            false, // Locked
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Complete previous modules to unlock')),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Practice tab content with exercises
  Widget _buildPracticeTab(
      BuildContext context, bool isDark, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Exercises',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Apply CBT techniques with guided exercises',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
          ),
          const SizedBox(height: 24),

          // Exercises list
          _buildExerciseCard(
            context,
            'Thought Record',
            'Document and analyze your thoughts',
            Icons.note_alt_outlined,
            '10 min',
            isDark ? Colors.teal.shade700 : Colors.teal.shade500,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exercise coming soon!')),
              );
            },
          ),

          _buildExerciseCard(
            context,
            'Cognitive Distortions Quiz',
            'Test your knowledge of thinking patterns',
            Icons.quiz_outlined,
            '5 min',
            isDark ? Colors.deepPurple.shade700 : Colors.deepPurple.shade500,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exercise coming soon!')),
              );
            },
          ),

          _buildExerciseCard(
            context,
            'Behavioral Experiment',
            'Test your beliefs in real situations',
            Icons.science_outlined,
            '15 min',
            isDark ? Colors.orange.shade700 : Colors.orange.shade600,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exercise coming soon!')),
              );
            },
          ),

          _buildExerciseCard(
            context,
            'Reframing Practice',
            'Transform negative thoughts',
            Icons.refresh_outlined,
            '8 min',
            isDark ? Colors.green.shade700 : Colors.green.shade600,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exercise coming soon!')),
              );
            },
          ),

          const SizedBox(height: 32),

          // Daily challenge
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.deepPurple.shade700, Colors.deepPurple.shade900]
                    : [Colors.purple.shade400, Colors.purple.shade700],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Daily Challenge',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Notice and write down three negative thoughts you have today, and try to identify the cognitive distortion in each one.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Challenge accepted!')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Accept Challenge'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Challenge will reset tomorrow')),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                      ),
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Progress tab with achievements and stats
  Widget _buildProgressTab(
      BuildContext context, bool isDark, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your CBT Journey',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Track your progress and achievements',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
          ),
          const SizedBox(height: 24),

          // Progress stats
          Row(
            children: [
              Expanded(
                child: _buildProgressStat(
                  context,
                  'Exercises',
                  '3',
                  'Complete',
                  isDark ? Colors.teal.shade700 : Colors.teal.shade500,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProgressStat(
                  context,
                  'Concepts',
                  '7',
                  'Learned',
                  isDark ? Colors.purple.shade700 : Colors.purple.shade500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildProgressStat(
                  context,
                  'Streak',
                  '5',
                  'Days',
                  isDark ? Colors.orange.shade700 : Colors.orange.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProgressStat(
                  context,
                  'Progress',
                  '25%',
                  'Complete',
                  isDark ? Colors.green.shade700 : Colors.green.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Achievements section
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Achievement cards
          _buildAchievementCard(
            context,
            'First Steps',
            'Completed your first CBT exercise',
            Icons.emoji_events,
            true, // Unlocked
            Colors.amber,
          ),

          _buildAchievementCard(
            context,
            'Consistent Learner',
            'Completed 3 days in a row',
            Icons.calendar_month,
            true, // Unlocked
            Colors.teal,
          ),

          _buildAchievementCard(
            context,
            'Thought Master',
            'Identified 10 cognitive distortions',
            Icons.psychology,
            false, // Locked
            Colors.purple,
          ),

          _buildAchievementCard(
            context,
            'CBT Expert',
            'Complete all modules in the basic course',
            Icons.school,
            false, // Locked
            Colors.blue,
          ),

          const SizedBox(height: 32),

          // Next recommended activity
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
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
                Text(
                  'Recommended Next Steps',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: primaryColor,
                    ),
                  ),
                  title: const Text('Complete "Identifying Thought Patterns"'),
                  subtitle: const Text('Module 2 • 15 minutes'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _tabController.animateTo(0); // Switch to Learn tab
                    },
                    child: const Text('Start'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Helper method to build concept cards
  Widget _buildConceptCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Concept details coming soon!')),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build course module cards
  Widget _buildCourseModule(
    BuildContext context,
    String title,
    String description,
    String number,
    bool isUnlocked,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? (isDark ? Colors.teal : Colors.blue)
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
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
                          color: isUnlocked
                              ? (isDark ? Colors.white : Colors.black87)
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isUnlocked
                              ? (isDark ? Colors.white70 : Colors.black54)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isUnlocked ? Icons.play_circle_outline : Icons.lock_outline,
                  color: isUnlocked
                      ? (isDark ? Colors.teal : Colors.blue)
                      : Colors.grey,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build exercise cards
  Widget _buildExerciseCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    String duration,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build progress stat cards
  Widget _buildProgressStat(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
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
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build achievement cards
  Widget _buildAchievementCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    bool isUnlocked,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? color.withOpacity(0.1)
                  : (isDark ? Colors.grey[800] : Colors.grey[200]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isUnlocked ? color : Colors.grey,
              size: 24,
            ),
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
                    color: isUnlocked
                        ? (isDark ? Colors.white : Colors.black87)
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUnlocked
                        ? (isDark ? Colors.white70 : Colors.black54)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            )
          else
            Icon(
              Icons.lock_outline,
              color: Colors.grey,
              size: 20,
            ),
        ],
      ),
    );
  }
}
