class UploadResult {
  final bool success;
  final String? fileId;
  final String? fileName;
  final String? mimeType;
  final int? size;
  final String? status;
  final String? message;
  final String? error;

  UploadResult({
    required this.success,
    this.fileId,
    this.fileName,
    this.mimeType,
    this.size,
    this.status,
    this.message,
    this.error,
  });
}
