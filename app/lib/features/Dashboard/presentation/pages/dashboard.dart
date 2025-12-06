import 'package:flutter/material.dart';
import '../widgets/course_progress_card.dart';
import '../widgets/daily_task_card.dart';
import '../../../learningJourneys/data/models/learning_journey_model.dart';
import '../../../learningJourneys/data/repositories/learning_repository.dart';
import './daily_task_screen.dart';
import '../../../auth/presentation/bloc/auth_local.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userId = ''; // initialize to avoid LateInitializationError
  final LearningRepository repository = LearningRepository();

  Future<List<LearningJourney>>? _journeysFuture; // start as null

  @override
  void initState() {
    super.initState();
    _init(); // only call async init, do NOT call _loadJourneys() here
  }

  Future<void> _init() async {
    final uid = await AuthLocal.getUserId() ?? '';
    if (!mounted) return;
    setState(() {
      userId = uid;
      _journeysFuture = repository.getAllJourneys(userId); // set future here
    });
  }

  /// ✅ Reload dashboard data
  void _loadJourneys() {
    setState(() {
      _journeysFuture = repository.getAllJourneys(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loader until future is ready
    if (_journeysFuture == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4FF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<LearningJourney>>(
        future: _journeysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Dashboard Error:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final journeys = snapshot.data ?? [];
          if (journeys.isEmpty) {
            return const Center(child: Text("No learning journeys found."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),

                ...journeys.map((course) {
                  final int totalTasks = course.subTopics.length;
                  final int completedTasks =
                      course.subTopics
                          .where((e) => e.videoResources.isNotEmpty)
                          .length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.topicName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CourseProgressCard(
                        courseName: course.topicName,
                        completed: completedTasks,
                        total: totalTasks == 0 ? 1 : totalTasks,
                        streak: 5,
                      ),
                      const SizedBox(height: 18),

                      if (course.subTopics.isEmpty)
                        const Text("No tasks available.")
                      else
                        ...course.subTopics.map(
                          (task) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: DailyTaskCard(
                              title: task.description,
                              description: task.videoResources.isNotEmpty
                                  ? "Watch ${task.videoResources.first.title}"
                                  : "Practice Task",
                              completed: false,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DailyTaskScreen(
                                      subTopic: task,
                                      onCompleted: _loadJourneys,
                                    ),
                                  ),
                                );
                                _loadJourneys();
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                    ],
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
