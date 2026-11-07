

class RecipeModel {
  final String id;
  final String title;
  final int typeId;
  final String? imagePath;
  final List<String> ingredients;
  final List<String> steps;

  RecipeModel({
    required this.id,
    required this.title,
    required this.typeId,
    required this.imagePath,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      title: json['title'],
      typeId: json['typeId'],
      imagePath: json['imagePath'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'typeId': typeId,
      'imagePath': imagePath,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}