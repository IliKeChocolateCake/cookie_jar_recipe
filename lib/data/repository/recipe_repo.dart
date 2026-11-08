import 'package:hive/hive.dart';
import 'package:cookie_jar_recipe/data/model/recipe_model.dart';

class RecipeRepository {
  final Box<RecipeModel> _box;
  RecipeRepository(this._box);
  RecipeModel? getById(String id) => _box.get(id);



//all recipes in the box


  List<RecipeModel> getAll() => _box.values.toList();

  

//filter recipes by typeId

  List<RecipeModel> filterByType(int typeId) =>
      _box.values.where((r) => r.typeId == typeId).toList();

  // add and update are the same call: same key overwrites Current value
  Future<void> save(RecipeModel recipe) => _box.put(recipe.id, recipe);

//delete a recipe by id
  Future<void> delete(String id) => _box.delete(id);

  Future<void> seed(List<RecipeModel> samples) async {
    for (final r in samples) {
      await _box.put(r.id, r);
    }
  }
}