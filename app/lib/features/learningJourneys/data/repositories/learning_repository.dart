import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/learning_journey_model.dart';

class LearningRepository {
  /// ✅ Use 10.0.2.2 for Android Emulator | localhost for Web/Desktop
  final String baseUrl = "http://localhost:5000/api";

  LearningRepository();

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // ✅ 1. FETCH ALL JOURNEYS FOR USER (DASHBOARD)
  Future<List<LearningJourney>> getAllJourneys(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/learning-journeys?userId=$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true &&
            jsonResponse['data'] is List) {
          return (jsonResponse['data'] as List)
              .map((item) => LearningJourney.fromJson(item))
              .toList();
        }

        return [];
      } else {
        throw Exception('Failed to load journeys: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // ✅ 2. FETCH JOURNEY DETAILS WITH SUBTOPICS
  Future<LearningJourney> getJourneyDetails({
    required String userId,
    required String journeyId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/learning-journeys?userId=$userId&learningJourneyId=$journeyId',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return LearningJourney.fromJson(jsonResponse['data']);
        }

        throw Exception('API Error: $jsonResponse');
      } else {
        throw Exception('Failed to load journey details');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // ✅ 3. CREATE A NEW LEARNING JOURNEY (ONBOARDING)
  Future<String> createJourney({
    required String userId,
    required String topicName,
    required String skillLevel,
    required String language,
    required int hoursPerDay,
    required int monthsToComplete,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/learning-journeys'),
        headers: _headers,
        body: json.encode({
          'userId': userId,
          'topicName': topicName,
          'skillLevel': skillLevel,
          'language': language,
          'hoursPerDay': hoursPerDay,
          'monthsToComplete': monthsToComplete,
        }),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return jsonResponse['data']['id'] as String;
        }

        throw Exception('API Error: $jsonResponse');
      } else {
        throw Exception('Failed to create journey: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Journey Creation Error: $e');
    }
  }

  // ✅ ✅ ✅ 4. MARK SUBTOPIC AS COMPLETE (REAL PRISMA SYNC)
  /// 🔥 This is what powers:
  /// ✅ Progress bar
  /// ✅ Locked tasks
  /// ✅ Dashboard auto-refresh
  /// ✅ Streak updates
  Future<void> markSubTopicComplete({
    required String learningJourneyId,
    required String subTopicId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/learning-journeys/update-progress'),
        headers: _headers,
        body: json.encode({
          'learningJourneyId': learningJourneyId,
          'subTopicId': subTopicId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update progress");
      }
    } catch (e) {
      throw Exception("Completion Error: $e");
    }
  }
}
