import 'package:flutter/material.dart';

class CourseProgressCard extends StatelessWidget {
  final String courseName;
  final int completed;
  final int total;
  final int streak;

  const CourseProgressCard({
    super.key,
    required this.courseName,
    required this.completed,
    required this.total,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    /// ✅ SAFE PROGRESS CALCULATION (NO NaN)
    final double progress =
        total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF9B4CFF)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ COURSE NAME
          Text(
            courseName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          /// ✅ PROGRESS BAR (NOW SAFE)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress, // ✅ NEVER NaN NOW
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),

          const SizedBox(height: 12),

          /// ✅ STATS ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$completed / $total Lessons",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "🔥 $streak Day Streak",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
