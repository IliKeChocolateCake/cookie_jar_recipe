import 'package:flutter/foundation.dart';
import 'package:cookie_jar_recipe/data/model/recipe_model.dart';
import 'package:cookie_jar_recipe/data/model/recipe_type_model.dart';
import 'package:cookie_jar_recipe/data/repository/recipe_repo.dart';
import 'package:cookie_jar_recipe/data/repository/recipe_type_api.dart';

class RecipeListViewModel extends ChangeNotifier {
  final RecipeRepository _recipeRepository;
  final RecipeTypeApi _recipeTypeApi;

  RecipeListViewModel(this._recipeRepository, this._recipeTypeApi);

  List<RecipeType> types = [];
  List<RecipeModel> recipes = [];
  int? selectedTypeId; // null = "All"
  bool isLoading = true;

  bool get isJarEmpty => _recipeRepository.getAll().isEmpty;

 DateTime? lastSynced;

Future<void> load() async {
  types = await _recipeTypeApi.load();
  _refresh();
  lastSynced = DateTime.now();
  isLoading = false;
  notifyListeners();
}

String get lastSyncedLabel {
  final t = lastSynced;
  if (t == null) return 'Not synced yet';
  String two(int n) => n.toString().padLeft(2, '0');
  return 'Last synced ${two(t.day)}/${two(t.month)}/${t.year} ${two(t.hour)}:${two(t.minute)}';
}

  void setFilter(int? typeId) {
    selectedTypeId = typeId;
    _refresh();
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await _recipeRepository.delete(id);
    _refresh();
    notifyListeners();
  }

  void reload() {
    _refresh();
    notifyListeners();
  }

  void _refresh() {
    recipes = selectedTypeId == null
        ? _recipeRepository.getAll()
        : _recipeRepository.filterByType(selectedTypeId!);
  }

Future<void> save(RecipeModel recipe) async {
  await _recipeRepository.save(recipe);
  _refresh();
  notifyListeners();
}

  String typeName(int typeId) {
    for (final t in types) {
      if (t.id == typeId) return t.name;
    }
    return 'Unknown';
  }
}