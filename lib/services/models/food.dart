class Food {
  final int foodId;
  final String foodName;
  final String? mealType;
  final String? imageUrl;
  final String? foodType;
  final String? description;
  final String? servingSize;
  final double? calories; // Sửa thành int?
  final double? protein; // Sửa thành int?
  final double? carbs; // Sửa thành int?
  final double? fat; // Sửa thành int?
  final double? glucid; // Sửa thành int?
  final double? fiber; // Sửa thành int?
  final String? others;
  final List<String>? allergies;
  final List<String>? diseases;

  Food({
    required this.foodId,
    required this.foodName,
    this.mealType,
    this.imageUrl,
    this.foodType,
    this.description,
    this.servingSize,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.glucid,
    this.fiber,
    this.others,
    this.allergies,
    this.diseases,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodId: json['foodId'] as int,
      foodName: json['foodName'] as String,
      mealType: json['mealType'] as String?,
      imageUrl: json['imageUrl'] as String?,
      foodType: json['foodType'] as String?,
      description: json['description'] as String?,
      servingSize: json['servingSize']?.toString(),
      calories: (json['calories'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      glucid: (json['glucid'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      others: json['others'],
      allergies: (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      diseases: (json['diseases'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'mealType': mealType,
      'imageUrl': imageUrl,
      'foodType': foodType,
      'description': description,
      'servingSize': servingSize,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'glucid': glucid,
      'fiber': fiber,
      'others': others,
      'allergies': allergies,
      'diseases': diseases,
    };
  }
}
