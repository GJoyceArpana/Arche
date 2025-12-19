import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';
import '../../../learningJourneys/data/models/learning_journey_model.dart';
import '../../../learningJourneys/data/repositories/learning_repository.dart';
import '../../../auth/presentation/bloc/auth_local.dart';
import '../../../learningJourneys/presentation/pages/daily_task_screen.dart';
import '../widgets/course_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userId = "";
  final LearningRepository repository = LearningRepository();

  /// We will store detailed journeys here
  Future<List<LearningJourney>>? _detailedJourneysFuture;
  int _currentCourseIndex = 0;

  @override
  void initState() {
    super.initState();
    _initDashboard();
  }

  Future<void> _initDashboard() async {
    final uid = await AuthLocal.getUserId() ?? "";
    if (!mounted) return;

    userId = uid;
    setState(() {
      _detailedJourneysFuture = _loadDetailedJourneys();
    });
  }

  /// 🔥 Loads ALL journeys + fetches full details for each
  Future<List<LearningJourney>> _loadDetailedJourneys() async {
    final journeys = await repository.getAllJourneys(userId);

    List<LearningJourney> detailed = [];

    for (final j in journeys) {
      final full = await repository.getJourneyDetails(userId, j.id);
      detailed.add(full);
    }

    return detailed;
  }

  void _reloadDashboard() {
    setState(() {
      _detailedJourneysFuture = _loadDetailedJourneys();
    });
  }

  /// Check if all subtopics in a journey are completed
  bool _isJourneyCompleted(LearningJourney journey) {
    if (journey.subTopics.isEmpty) return false;
    return journey.subTopics.every((subTopic) => subTopic.isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    if (_detailedJourneysFuture == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4338CA), Colors.white],
          ),
        ),

        child: FutureBuilder<List<LearningJourney>>(
          future: _detailedJourneysFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final allJourneys = snapshot.data ?? [];

            // Filter out completed journeys
            final activeJourneys = allJourneys
                .where((journey) => !_isJourneyCompleted(journey))
                .toList();

            if (activeJourneys.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.celebration,
                      size: 80,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "All courses completed! 🎉",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Great job on finishing all your learning journeys!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CarouselSlider.builder(
                    itemCount: activeJourneys.length,
                    itemBuilder: (context, index, realIndex) {
                      final journey = activeJourneys[index];
                      return CourseCard(
                        journey: journey,
                        onContinue: (subTopic) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DailyTaskScreen(
                                subTopic: subTopic,
                                journeyId: journey.id,
                                userId: userId,
                                repository: repository,
                              ),
                            ),
                          );

                          if (result == true) {
                            _reloadDashboard();
                          }
                        },
                        onDailyTaskTapped: (subTopic) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DailyTaskScreen(
                                subTopic: subTopic,
                                journeyId: journey.id,
                                userId: userId,
                                repository: repository,
                              ),
                            ),
                          );

                          if (result == true) {
                            _reloadDashboard();
                          }
                        },
                      );
                    },
                    options: CarouselOptions(
                      height: 400, // Adjust height to fit your CourseCard
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCourseIndex = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(activeJourneys.length, (index) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentCourseIndex == index
                              ? const Color(0xFF4338CA)
                              : Colors.grey.withOpacity(0.5),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Simple streak logic
  /*int _calculateStreak(List<SubTopic> topics) {
    int streak = 0;

    for (final t in topics) {
      if (t.isCompleted) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }*/
}
