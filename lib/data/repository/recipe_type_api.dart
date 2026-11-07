
import 'package:cookie_jar_recipe/data/model/recipe_type_model.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


class RecipeTypeApi  {
   Future<List<RecipeType>> load() async {
    final raw = await rootBundle.loadString('assets/data/recipetypes.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return (data['recipeTypes'] as List)
        .map((e) => RecipeType.fromJson(e))
        .toList();
  }
}