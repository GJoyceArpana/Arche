import 'package:flutter/material.dart';
import '../../data/repositories/learning_repository.dart';
import '../../data/models/learning_journey_model.dart';
import 'generated_roadmap_screen.dart';
import '../../../auth/presentation/bloc/auth_local.dart';

class CourseListScreen extends StatefulWidget {
  final LearningRepository repository;

  // ✅ DO NOT USE const here because repository is runtime injected
  const CourseListScreen({super.key, required this.repository});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  String userId = ''; // initialize to avoid LateInitializationError
  Future<List<LearningJourney>>? _journeysFuture; // start as null

  @override
  void initState() {
    super.initState();
    _init(); // only async init
  }

  Future<void> _init() async {
    final uid = await AuthLocal.getUserId() ?? '';
    if (!mounted) return;
    setState(() {
      userId = uid;
      _journeysFuture = widget.repository.getAllJourneys(
        userId,
      ); // set future now
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _journeysFuture = widget.repository.getAllJourneys(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loader until future is ready
    if (_journeysFuture == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Ongoing Courses"), centerTitle: true),
      body: FutureBuilder<List<LearningJourney>>(
        future: _journeysFuture,
        builder: (context, snapshot) {
          // ✅ LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ ERROR STATE
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load courses\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final journeys = snapshot.data ?? [];

          // ✅ EMPTY STATE
          if (journeys.isEmpty) {
            return const Center(child: Text("No courses yet"));
          }

          // ✅ COURSE LIST
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: journeys.length,
              itemBuilder: (context, index) {
                final journey = journeys[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.school, color: Colors.deepPurple),
                    title: Text(
                      journey.topicName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Created on ${journey.createdAt}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),

                    // ✅ OPEN BACKEND-POWERED ROADMAP
                    onTap: () async {
                      try {
                        final detailed = await widget.repository
                            .getJourneyDetails(userId, journey.id);

                        if (!mounted) return;

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GeneratedRoadmapScreen(
                              journey: detailed,
                              repository: widget.repository,
                              userId: userId,
                            ),
                          ),
                        );

                        // ✅ AUTO REFRESH AFTER MARKING TASKS COMPLETE
                        _refresh();
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to open course: $e")),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
