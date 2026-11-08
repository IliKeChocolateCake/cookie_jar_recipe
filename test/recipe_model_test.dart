import 'package:flutter_test/flutter_test.dart';
import 'package:cookie_jar_recipe/data/model/recipe_model.dart';

void main() {
  test('fromJson and toJson round trip', () {
    final json = {
      'id': 'r1',
      'title': 'Nasi Lemak',
      'typeId': 1,
      'imagePath': null,
      'ingredients': ['rice', 'coconut milk'],
      'steps': ['cook', 'serve'],
    };
    final recipe = RecipeModel.fromJson(json);
    expect(recipe.title, 'Nasi Lemak');
    expect(recipe.ingredients.length, 2);
    expect(recipe.toJson(), json);
  });
}