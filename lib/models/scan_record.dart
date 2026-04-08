import 'prediction_result.dart';

class ScanRecord {
  final String id;
  final String imagePath;
  final String fileName;
  final int fileSize;
  final DateTime scannedAt;
  final PredictionResult result;

  const ScanRecord({
    required this.id,
    required this.imagePath,
    required this.fileName,
    required this.fileSize,
    required this.scannedAt,
    required this.result,
  });

  factory ScanRecord.fromJson(Map<String, dynamic> json) {
    return ScanRecord(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      fileName: json['fileName'] as String,
      fileSize: json['fileSize'] as int,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      result: PredictionResult.fromJson(json['result'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagePath': imagePath,
        'fileName': fileName,
        'fileSize': fileSize,
        'scannedAt': scannedAt.toIso8601String(),
        'result': result.toJson(),
      };
}
