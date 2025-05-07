import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserStats {
  final int thoughtLogCount;
  final int cbtExerciseCount;
  final int daysStreak;
  final List<int> weeklyActivityData;
  final DateTime lastActiveDate;

  UserStats({
    this.thoughtLogCount = 0,
    this.cbtExerciseCount = 0,
    this.daysStreak = 0,
    required this.weeklyActivityData,
    required this.lastActiveDate,
  });

  // Create a UserStats object from a Firestore document
  factory UserStats.fromFirestore(Map<String, dynamic> data) {
    return UserStats(
      thoughtLogCount: data['thought_log_count'] ?? 0,
      cbtExerciseCount: data['cbt_exercise_count'] ?? 0,
      daysStreak: data['days_streak'] ?? 0,
      weeklyActivityData:
          List<int>.from(data['weekly_activity_data'] ?? List.filled(7, 0)),
      lastActiveDate:
          (data['last_active_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert UserStats to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'thought_log_count': thoughtLogCount,
      'cbt_exercise_count': cbtExerciseCount,
      'days_streak': daysStreak,
      'weekly_activity_data': weeklyActivityData,
      'last_active_date': Timestamp.fromDate(lastActiveDate),
    };
  }

  // Create a copy of UserStats with updated values
  UserStats copyWith({
    int? thoughtLogCount,
    int? cbtExerciseCount,
    int? daysStreak,
    List<int>? weeklyActivityData,
    DateTime? lastActiveDate,
  }) {
    return UserStats(
      thoughtLogCount: thoughtLogCount ?? this.thoughtLogCount,
      cbtExerciseCount: cbtExerciseCount ?? this.cbtExerciseCount,
      daysStreak: daysStreak ?? this.daysStreak,
      weeklyActivityData: weeklyActivityData ?? this.weeklyActivityData,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}

class UserStatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get a reference to the user's stats document
  DocumentReference? get _userStatsRef {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('user_data')
        .doc('stats');
  }

  // Get a reference to the user's thought logs collection
  CollectionReference? get _thoughtLogsRef {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('thought_logs');
  }

  // Get a reference to the user's CBT exercises collection
  CollectionReference? get _cbtExercisesRef {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cbt_exercises');
  }

  // Get user stats from Firestore or create if doesn't exist
  Future<UserStats> getUserStats() async {
    final statsRef = _userStatsRef;
    if (statsRef == null) {
      // Return default stats for guest users
      return UserStats(
        weeklyActivityData: List.filled(7, 0),
        lastActiveDate: DateTime.now(),
      );
    }

    try {
      final doc = await statsRef.get();
      if (doc.exists && doc.data() != null) {
        return UserStats.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        // Create default stats document if it doesn't exist
        final defaultStats = UserStats(
          weeklyActivityData: List.filled(7, 0),
          lastActiveDate: DateTime.now(),
        );
        await statsRef.set(defaultStats.toFirestore());
        return defaultStats;
      }
    } catch (e) {
      print('Error getting user stats: $e');
      // Return default stats on error
      return UserStats(
        weeklyActivityData: List.filled(7, 0),
        lastActiveDate: DateTime.now(),
      );
    }
  }

  // Update user stats in Firestore
  Future<void> updateUserStats(UserStats stats) async {
    final statsRef = _userStatsRef;
    if (statsRef == null) return;

    try {
      await statsRef.set(stats.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating user stats: $e');
    }
  }

  // Calculate user streak based on thought logs
  Future<int> calculateStreak() async {
    final logsRef = _thoughtLogsRef;
    if (logsRef == null) return 0;

    try {
      // Get logs ordered by timestamp in descending order
      final snapshot =
          await logsRef.orderBy('timestamp', descending: true).get();

      if (snapshot.docs.isEmpty) return 0;

      // Calculate streak
      int streak = 1;
      DateTime? lastDate;

      for (final doc in snapshot.docs) {
        final timestamp = doc['timestamp'] as Timestamp?;
        if (timestamp == null) continue;

        final currentDate = DateTime(
          timestamp.toDate().year,
          timestamp.toDate().month,
          timestamp.toDate().day,
        );

        if (lastDate == null) {
          // First log, initialize lastDate
          lastDate = currentDate;

          // Check if the most recent log is from today or yesterday
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = DateTime(now.year, now.month, now.day - 1);

          if (currentDate.isBefore(yesterday)) {
            // The most recent log is older than yesterday, streak is broken
            return 0;
          }
        } else {
          // Check if this log is from the day before the previous log
          final expectedDate = DateTime(
            lastDate.year,
            lastDate.month,
            lastDate.day - 1,
          );

          if (currentDate.isAtSameMomentAs(expectedDate)) {
            // This log is from the day before, increment streak
            streak++;
            lastDate = currentDate;
          } else if (currentDate.isAtSameMomentAs(lastDate)) {
            // Same day, continue checking
            continue;
          } else {
            // Streak is broken
            break;
          }
        }
      }

      return streak;
    } catch (e) {
      print('Error calculating streak: $e');
      return 0;
    }
  }

  // Count thought logs
  Future<int> countThoughtLogs() async {
    final logsRef = _thoughtLogsRef;
    if (logsRef == null) return 0;

    try {
      final snapshot = await logsRef.count().get();
      return snapshot.count ?? 0; // Added null check with default value
    } catch (e) {
      print('Error counting thought logs: $e');
      return 0;
    }
  }

  // Count CBT exercises
  Future<int> countCBTExercises() async {
    final exercisesRef = _cbtExercisesRef;
    if (exercisesRef == null) return 0;

    try {
      final snapshot = await exercisesRef.count().get();
      return snapshot.count ?? 0; // Added null check with default value
    } catch (e) {
      print('Error counting CBT exercises: $e');
      return 0;
    }
  }

  // Generate weekly activity data based on thought logs
  Future<List<int>> generateWeeklyActivityData() async {
    final logsRef = _thoughtLogsRef;
    if (logsRef == null) return List.filled(7, 0);

    try {
      // Get current date
      final now = DateTime.now();

      // Generate dates for the last 7 days (today and 6 previous days)
      final weekDays = List<DateTime>.generate(7, (i) {
        return DateTime(now.year, now.month, now.day - i);
      }).reversed.toList();

      // Initialize counts for each day
      final counts = List<int>.filled(7, 0);

      // Get logs from the last 7 days
      final startDate = DateTime(
          weekDays.first.year, weekDays.first.month, weekDays.first.day);
      final endDate = DateTime(weekDays.last.year, weekDays.last.month,
          weekDays.last.day, 23, 59, 59);

      final snapshot = await logsRef
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      // Count logs per day
      for (final doc in snapshot.docs) {
        final timestamp = doc['timestamp'] as Timestamp?;
        if (timestamp == null) continue;

        final logDate = timestamp.toDate();
        final logDay = DateTime(logDate.year, logDate.month, logDate.day);

        for (int i = 0; i < weekDays.length; i++) {
          final weekDay = weekDays[i];
          if (logDay.year == weekDay.year &&
              logDay.month == weekDay.month &&
              logDay.day == weekDay.day) {
            counts[i]++;
            break;
          }
        }
      }

      return counts;
    } catch (e) {
      print('Error generating weekly activity data: $e');
      return List.filled(7, 0);
    }
  }

  // Update all stats at once
  Future<UserStats> updateAllStats() async {
    try {
      final thoughtLogCount = await countThoughtLogs();
      final cbtExerciseCount = await countCBTExercises();
      final daysStreak = await calculateStreak();
      final weeklyActivityData = await generateWeeklyActivityData();

      final stats = UserStats(
        thoughtLogCount: thoughtLogCount,
        cbtExerciseCount: cbtExerciseCount,
        daysStreak: daysStreak,
        weeklyActivityData: weeklyActivityData,
        lastActiveDate: DateTime.now(),
      );

      // Update stats in Firestore
      await updateUserStats(stats);

      return stats;
    } catch (e) {
      print('Error updating all stats: $e');
      return UserStats(
        weeklyActivityData: List.filled(7, 0),
        lastActiveDate: DateTime.now(),
      );
    }
  }

  // Log a completed CBT exercise
  Future<void> logCBTExercise({
    required String title,
    required String exerciseType,
    String? notes,
  }) async {
    final exercisesRef = _cbtExercisesRef;
    if (exercisesRef == null) return;

    try {
      // Add exercise to Firestore
      await exercisesRef.add({
        'userId': _auth.currentUser?.uid,
        'title': title,
        'exerciseType': exerciseType,
        'notes': notes,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update stats
      final stats = await getUserStats();
      final updatedStats = stats.copyWith(
        cbtExerciseCount: stats.cbtExerciseCount + 1,
        lastActiveDate: DateTime.now(),
      );

      await updateUserStats(updatedStats);
    } catch (e) {
      print('Error logging CBT exercise: $e');
    }
  }

  // Handle daily login to update streak
  Future<void> updateLoginStreak() async {
    try {
      final stats = await getUserStats();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final lastActive = DateTime(
        stats.lastActiveDate.year,
        stats.lastActiveDate.month,
        stats.lastActiveDate.day,
      );

      int newStreak = stats.daysStreak;

      if (lastActive.isAtSameMomentAs(today)) {
        // Already logged in today, no change to streak
      } else if (lastActive.isAtSameMomentAs(yesterday)) {
        // Logged in yesterday, increment streak
        newStreak += 1;
      } else {
        // Streak broken, reset to 1 for today
        newStreak = 1;
      }

      final updatedStats = stats.copyWith(
        daysStreak: newStreak,
        lastActiveDate: now,
      );

      await updateUserStats(updatedStats);
    } catch (e) {
      print('Error updating login streak: $e');
    }
  }
}
