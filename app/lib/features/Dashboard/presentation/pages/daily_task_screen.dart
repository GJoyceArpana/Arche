import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../learningJourneys/data/models/learning_journey_model.dart';

class DailyTaskScreen extends StatelessWidget {
  final SubTopic subTopic;
  final VoidCallback onCompleted;

  const DailyTaskScreen({
    super.key,
    required this.subTopic,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final parts = subTopic.description.split(':');
    final String title = parts.isNotEmpty ? parts[0] : "Daily Task";
    final String subtitle =
        parts.length > 1 ? parts[1].trim() : subTopic.description;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FF),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF6A5AE0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          const Text(
            "Today's Learning Goals 🔥",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Text(
            subtitle,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),

          const SizedBox(height: 25),

          // ✅ VIDEO LIST
          if (subTopic.videoResources.isEmpty)
            const Center(child: Text("No videos found."))
          else
            ...subTopic.videoResources.map(
              (video) => _taskCard(
                title: video.title,
                subtitle: "${video.duration} mins • Video Lesson",
                url: video.url,
              ),
            ),

          const SizedBox(height: 30),

          /// ✅ COMPLETE BUTTON
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("✅ Day marked as complete!"),
                ),
              );

              onCompleted(); // ✅ REFRESH DASHBOARD
              Navigator.pop(context);
            },
            child: Container(
              height: 52,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A8CFF), Color(0xFF9B4CFF)],
                ),
              ),
              child: const Center(
                child: Text(
                  "Mark Day as Complete",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ OPENS YOUTUBE LINK
  Widget _taskCard({
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Row(
          children: [
            const Icon(Icons.play_circle_fill, size: 40, color: Colors.deepPurple),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
