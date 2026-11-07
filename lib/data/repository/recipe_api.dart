import 'package:cookie_jar_recipe/data/model/recipe_model.dart';
import 'package:flutter/services.dart';
import 'dart:convert';


class RecipeApi  {
   Future<List<RecipeModel>> load() async {
    final raw = await rootBundle.loadString('assets/data/recipetypes.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return (data['recipes'] as List)
        .map((e) => RecipeModel.fromJson(e))
        .toList();
  }
}