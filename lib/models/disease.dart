class Disease {
  final String key;
  final String name;
  final String scientificName;
  final String type;
  final String severity;
  final String description;
  final String treatment;
  final String prevention;

  const Disease({
    required this.key,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.severity,
    required this.description,
    required this.treatment,
    required this.prevention,
  });
}
