import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/document_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http_parser/http_parser.dart';

abstract class DocumentRemoteDataSource {
  Future<Map<String, dynamic>> uploadDocument(
    dynamic file,
    String fileName,
    String userId,
  );
  Future<String> generateSummary(String fileId, String userId);
  Future<String> getSummary(String fileId, String userId);
  Future<List<DocumentModel>> getDocumentHistory(String userId);
}

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  DocumentRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'http://localhost:5000/api',
  });

  // Helper method to determine MIME type from file extension
  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Future<Map<String, dynamic>> uploadDocument(
    dynamic file,
    String fileName,
    String userId,
  ) async {
    try {
      debugPrint('Starting upload for file: $fileName');
      debugPrint('User ID: $userId');
      debugPrint('Upload URL: $baseUrl/summary/upload');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/summary/upload'),
      );

      final mimeType = _getMimeType(fileName);
      debugPrint('MIME Type: $mimeType');
      final mediaType = MediaType.parse(mimeType);

      // Handle file differently for web and mobile/desktop
      if (kIsWeb) {
        final bytes = file as List<int>;
        debugPrint('File size (web): ${bytes.length} bytes');
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
            contentType: mediaType,
          ),
        );
      } else {
        final fileObj = file as File;
        final fileSize = await fileObj.length();
        debugPrint('File size (mobile): $fileSize bytes');
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            fileObj.path,
            filename: fileName,
            contentType: mediaType,
          ),
        );
      }

      request.fields['userId'] = userId;
      debugPrint('Sending request...');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'] as Map<String, dynamic>;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Upload failed');
        }
      } else {
        // Try to parse error response
        try {
          final errorResponse =
              json.decode(response.body) as Map<String, dynamic>;
          final errorMessage = errorResponse['message'] ?? 'Unknown error';
          final errorDetail = errorResponse['error'] ?? '';
          throw Exception('$errorMessage: $errorDetail');
        } catch (e) {
          throw Exception(
            'Failed to upload document: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      throw Exception('Upload error: $e');
    }
  }

  @override
  /// Calls the backend API to generate a summary for the document
  /// Returns: Markdown-formatted summary text from the AI agent
  Future<String> generateSummary(String fileId, String userId) async {
    try {
      debugPrint('Generating summary for fileId: $fileId, userId: $userId');

      final response = await client.get(
        Uri.parse('$baseUrl/summary/generate?fileId=$fileId&userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Generate summary response status: ${response.statusCode}');
      debugPrint('Generate summary response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return data['summary'] as String;
        } else {
          throw Exception(
            jsonResponse['message'] ?? 'Failed to generate summary',
          );
        }
      } else {
        throw Exception(
          'Failed to generate summary: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Generate summary error: $e');
      throw Exception('Generate summary error: $e');
    }
  }

  @override
  /// Retrieves a previously generated summary from the backend
  /// Returns: Markdown-formatted summary text
  Future<String> getSummary(String fileId, String userId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/summary?fileId=$fileId&userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['success'] == true) {
          final data = jsonResponse['data'] as Map<String, dynamic>;
          return data['summary'] as String;
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to get summary');
        }
      } else {
        throw Exception('Failed to get summary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get summary error: $e');
    }
  }

  @override
  Future<List<DocumentModel>> getDocumentHistory(String userId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/summary/list?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        if (jsonResponse['success'] == true) {
          final List<dynamic> jsonList = jsonResponse['data'] as List;
          return jsonList
              .map(
                (json) => DocumentModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to get history');
        }
      } else {
        throw Exception('Failed to get history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get history error: $e');
    }
  }
}
