abstract class ChatRepository {
  /// Sends a follow-up question and receives markdown-formatted answer
  Future<String> sendFollowUpQuestion(
    String fileId,
    String userId,
    String question,
  );
}
