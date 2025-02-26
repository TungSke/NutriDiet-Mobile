class Disease {
  final int diseaseId;
  final String diseaseName;
  final String? description;

  Disease(
      {required this.diseaseId, required this.diseaseName, this.description});

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['diseaseId'] as int,
      diseaseName: json['diseaseName'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseaseId': diseaseId,
      'diseaseName': diseaseName,
      'description': description,
    };
  }
}
