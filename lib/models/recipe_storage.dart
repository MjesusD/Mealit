import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../entity/recipe_model.dart';

class RecipeStorage {
  static const _key = 'user_recipes';

  static Future<List<Recipe>> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Recipe.fromJson(e)).toList();
  }

  static Future<void> saveRecipes(List<Recipe> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(recipes.map((r) => r.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  static Future<void> addOrUpdateRecipe(Recipe recipe) async {
    final recipes = await loadRecipes();
    final index = recipes.indexWhere((r) => r.id == recipe.id);
    if (index >= 0) {
      recipes[index] = recipe; // actualizar
    } else {
      recipes.add(recipe); // agregar nuevo
    }
    await saveRecipes(recipes);
  }

  static Future<void> deleteRecipe(String id) async {
    final recipes = await loadRecipes();
    recipes.removeWhere((r) => r.id == id);
    await saveRecipes(recipes);
  }
}
