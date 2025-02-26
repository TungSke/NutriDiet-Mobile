class Allergy {
  final int allergyId;
  final String allergyName;
  final String? notes;

  Allergy({required this.allergyId, required this.allergyName, this.notes});

  factory Allergy.fromJson(Map<String, dynamic> json) {
    return Allergy(
      allergyId: json['allergyId'] as int,
      allergyName: json['allergyName'] as String,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allergyId': allergyId,
      'allergyName': allergyName,
      'notes': notes,
    };
  }
}
