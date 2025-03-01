class Food {
  final int foodId;
  final String foodName;
  final String? mealType;
  final String? imageUrl;
  final String? foodType;
  final String? description;
  final String? servingSize;
  final int? calories; // Sửa thành int?
  final int? protein; // Sửa thành int?
  final int? carbs; // Sửa thành int?
  final int? fat; // Sửa thành int?
  final int? glucid; // Sửa thành int?
  final int? fiber; // Sửa thành int?
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
      servingSize: json['servingSize']
          ?.toString(), // Chuyển servingSize thành String nếu cần
      calories: json['calories'] as int?, // Sửa lại kiểu dữ liệu
      protein: json['protein'] as int?, // Sửa lại kiểu dữ liệu
      carbs: json['carbs'] as int?, // Sửa lại kiểu dữ liệu
      fat: json['fat'] as int?, // Sửa lại kiểu dữ liệu
      glucid: json['glucid'] as int?, // Sửa lại kiểu dữ liệu
      fiber: json['fiber'] as int?, // Sửa lại kiểu dữ liệu
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
