import '../entities/document.dart';
import '../entities/upload_result.dart';

abstract class DocumentRepository {
  Future<UploadResult> uploadDocument(
    dynamic file,
    String fileName,
    String userId,
  );
  Future<String> generateSummary(String fileId, String userId);
  Future<String> getSummary(String fileId, String userId);
  Future<List<Document>> getDocumentHistory(String userId);
}
