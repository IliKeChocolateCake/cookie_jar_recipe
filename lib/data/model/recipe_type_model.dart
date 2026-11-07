


class RecipeType {
  final int id;
  final String name;

  RecipeType({required this.name, required this.id});

  factory RecipeType.fromJson(Map<String, dynamic> json) {
    return RecipeType(
      id: json['id'],
      name: json['name'],
    );
  }
}