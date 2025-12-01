import 'package:flutter/material.dart';

import '../widgets/course_progress_card.dart';
import '../widgets/daily_task_card.dart';

import '../../../learningJourneys/data/models/learning_journey_model.dart';
import '../../../learningJourneys/data/repositories/learning_repository.dart';
import './daily_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String userId = "cmieugm7s0000uye0jzmwhgut"; // ✅ TEMP USER
  final LearningRepository repository = LearningRepository();

  Future<List<LearningJourney>>? _journeysFuture;

  @override
  void initState() {
    super.initState();
    _loadJourneys();
  }

  /// ✅ Reload dashboard data
  void _loadJourneys() {
    setState(() {
      _journeysFuture = repository.getAllJourneys(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),

      body: FutureBuilder<List<LearningJourney>>(
        future: _journeysFuture,
        builder: (context, snapshot) {

          /// ✅ LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ✅ ERROR
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

          /// ✅ EMPTY STATE
          if (journeys.isEmpty) {
            return const Center(child: Text("No learning journeys found."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ✅ HEADER
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),

                /// ✅ LOOP THROUGH ALL COURSES ✅
                ...journeys.map((course) {

                  final int totalTasks = course.subTopics?.length ?? 0;
                  final int completedTasks =
                      course.subTopics
                              ?.where((e) => e.videoResources.isNotEmpty)
                              .length ??
                          0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ✅ COURSE TITLE
                      Text(
                        course.topicName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// ✅ PROGRESS CARD
                      CourseProgressCard(
                        courseName: course.topicName,
                        completed: completedTasks,
                        total: totalTasks == 0 ? 1 : totalTasks, // ✅ Prevent NaN
                        streak: 5,
                      ),

                      const SizedBox(height: 18),

                      /// ✅ DAILY TASKS
                      if (course.subTopics == null ||
                          course.subTopics!.isEmpty)
                        const Text("No tasks available.")
                      else
                        ...course.subTopics!.map(
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
                                      onCompleted: _loadJourneys, // ✅ refresh dashboard
                                    ),
                                  ),
                                );

                                /// ✅ Refresh again after returning
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
