import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;

abstract class ChatRemoteDataSource {
  Future<String> sendFollowUpQuestion(
    String fileId,
    String userId,
    String question,
  );
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ChatRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'http://localhost:5000/api',
  });

  @override
  /// Sends a follow-up question to the backend
  /// Returns: Markdown-formatted answer from the AI agent
  Future<String> sendFollowUpQuestion(
    String fileId,
    String userId,
    String question,
  ) async {
    try {
      debugPrint('Sending follow-up question for fileId: $fileId');
      debugPrint('Question: $question');

      final response = await client.post(
        Uri.parse('$baseUrl/summary/follow-up?fileId=$fileId&userId=$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': question}),
      );

      debugPrint('Follow-up response status: ${response.statusCode}');
      debugPrint('Follow-up response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['success'] == true) {
          // Backend returns markdown-formatted answer
          return jsonResponse['response'] as String;
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Failed to get follow-up answer',
          );
        }
      } else {
        throw Exception(
          'Failed to send follow-up question: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Follow-up question error: $e');
      throw Exception('Follow-up question error: $e');
    }
  }
}