import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:cookie_jar_recipe/data/model/recipe_model.dart';
import 'package:cookie_jar_recipe/data/model/recipe_model_adapter.dart';
import 'package:cookie_jar_recipe/data/repository/recipe_repo.dart';

void main() {
  late Directory tempDir;
  late Box<RecipeModel> box;
  late RecipeRepository repo;

  RecipeModel makeRecipe(String id, int typeId, {String title = 'Test'}) =>
      RecipeModel(
        id: id,
        title: title,
        typeId: typeId,
        imagePath: null,
        ingredients: ['a'],
        steps: ['b'],
      );

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('hive_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(RecipeModelAdapter());
  });

  setUp(() async {
    box = await Hive.openBox<RecipeModel>('test_recipes');
    repo = RecipeRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  tearDownAll(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('save adds a recipe and getAll returns it', () async {
    await repo.save(makeRecipe('1', 1));
    expect(repo.getAll().length, 1);
  });

  test('save with the same id updates instead of duplicating', () async {
    await repo.save(makeRecipe('1', 1, title: 'Old'));
    await repo.save(makeRecipe('1', 1, title: 'New'));
    expect(repo.getAll().length, 1);
    expect(repo.getById('1')!.title, 'New');
  });

  test('delete removes the recipe', () async {
    await repo.save(makeRecipe('1', 1));
    await repo.delete('1');
    expect(repo.getAll(), isEmpty);
  });

  test('filterByType returns only matching recipes', () async {
    await repo.save(makeRecipe('1', 1));
    await repo.save(makeRecipe('2', 2));
    await repo.save(makeRecipe('3', 2));
    expect(repo.filterByType(2).length, 2);
    expect(repo.filterByType(3), isEmpty);
  });

  test('getById returns null for a missing id', () {
    expect(repo.getById('nope'), isNull);
  });

  test('seed inserts all sample recipes', () async {
    await repo.seed([makeRecipe('1', 1), makeRecipe('2', 2)]);
    expect(repo.getAll().length, 2);
  });
}