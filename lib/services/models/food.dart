class Food {
  final int foodId;
  final String foodName;
  final String? mealType;
  final String? imageUrl;
  final String? foodType;
  final String? description;
  final String? servingSize;
  final String? calories;
  final String? protein;
  final String? carbs;
  final String? fat;
  final String? glucid;
  final String? fiber;
  final String? others;
  final List<String>? allergies; // Danh sách dị ứng
  final List<String>? diseases; // Danh sách bệnh

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
      servingSize: json['servingSize'] as String?,
      calories: json['calories'] as String?,
      protein: json['protein'] as String?,
      carbs: json['carbs'] as String?,
      fat: json['fat'] as String?,
      glucid: json['glucid'] as String?,
      fiber: json['fiber'] as String?,
      others: json['others'] as String?,
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      diseases: (json['diseases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
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
