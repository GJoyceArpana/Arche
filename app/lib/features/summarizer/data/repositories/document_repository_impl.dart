import '../../domain/entities/document.dart';
import '../../domain/entities/upload_result.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_remote_datasource.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource remoteDataSource;

  DocumentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UploadResult> uploadDocument(
    dynamic file,
    String fileName,
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.uploadDocument(
        file,
        fileName,
        userId,
      );

      return UploadResult(
        success: true,
        fileId: result['id'] as String?,
        fileName: result['fileName'] as String?,
        mimeType: result['mimeType'] as String?,
        size: result['size'] as int?,
        status: result['status'] as String?,
        message: 'Document uploaded successfully',
      );
    } catch (e) {
      return UploadResult(success: false, error: e.toString());
    }
  }

  @override
  /// Generates a summary for the uploaded document
  /// Returns markdown-formatted text from the AI summarizer agent
  Future<String> generateSummary(String fileId, String userId) async {
    try {
      return await remoteDataSource.generateSummary(fileId, userId);
    } catch (e) {
      throw Exception('Failed to generate summary: $e');
    }
  }

  @override
  /// Retrieves a previously generated summary
  /// Returns markdown-formatted text
  Future<String> getSummary(String fileId, String userId) async {
    try {
      return await remoteDataSource.getSummary(fileId, userId);
    } catch (e) {
      throw Exception('Failed to get summary: $e');
    }
  }

  @override
  Future<List<Document>> getDocumentHistory(String userId) async {
    try {
      return await remoteDataSource.getDocumentHistory(userId);
    } catch (e) {
      return [];
    }
  }
}
