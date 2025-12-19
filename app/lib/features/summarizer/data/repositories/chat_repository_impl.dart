import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> sendFollowUpQuestion(
    String fileId,
    String userId,
    String question,
  ) async {
    try {
      return await remoteDataSource.sendFollowUpQuestion(
        fileId,
        userId,
        question,
      );
    } catch (e) {
      throw Exception('Failed to get follow-up answer: $e');
    }
  }
}
