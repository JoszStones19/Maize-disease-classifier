class AlternativePrediction {
  final String label;
  final double confidence;

  const AlternativePrediction({required this.label, required this.confidence});

  factory AlternativePrediction.fromJson(Map<String, dynamic> json) {
    return AlternativePrediction(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'confidence': confidence,
      };
}

class PredictionResult {
  final String disease;
  final double confidence;
  final List<AlternativePrediction> alternatives;

  const PredictionResult({
    required this.disease,
    required this.confidence,
    required this.alternatives,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      disease: json['disease'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      alternatives: (json['alternatives'] as List<dynamic>? ?? [])
          .map((item) => AlternativePrediction.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'disease': disease,
        'confidence': confidence,
        'alternatives': alternatives.map((item) => item.toJson()).toList(),
      };
}
