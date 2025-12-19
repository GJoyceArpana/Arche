class Document {
  final String id;
  final String fileName;
  final String mimeType;
  final int size;
  final DateTime createdAt;

  /// Summary text in markdown format from the backend AI agent
  final String? summary;

  Document({
    required this.id,
    required this.fileName,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    this.summary,
  });
}
