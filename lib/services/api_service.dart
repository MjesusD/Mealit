import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mealit/services/connectivity_service.dart';

final logger = Logger();

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<bool> _hasConnection() async {
    return ConnectivityService.instance.hasConnection;
  }

  Future<List<dynamic>?> searchMealsByName(String name) async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en searchMealsByName');
      return null;
    }

    final url = Uri.parse('$_baseUrl/search.php?s=$name');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('Búsqueda por nombre: ${data['meals']?.length ?? 0} resultados');
        return data['meals'];
      }
    } catch (e, s) {
      logger.e('Error en searchMealsByName', error: e, stackTrace: s);
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchRandomMeal() async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en fetchRandomMeal');
      return null;
    }

    final url = Uri.parse('$_baseUrl/random.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        logger.i('Comida aleatoria obtenida');
        final data = jsonDecode(response.body);
        return data['meals'][0];
      }
    } catch (e, s) {
      logger.e('Error en fetchRandomMeal', error: e, stackTrace: s);
    }
    return null;
  }

  Future<List<dynamic>?> filterByCategory(String category) async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en filterByCategory');
      return null;
    }

    final url = Uri.parse('$_baseUrl/filter.php?c=$category');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('Filtrado por categoría "$category"');
        return data['meals'];
      }
    } catch (e, s) {
      logger.e('Error en filterByCategory', error: e, stackTrace: s);
    }
    return null;
  }

  Future<List<dynamic>?> filterByArea(String area) async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en filterByArea');
      return null;
    }

    final url = Uri.parse('$_baseUrl/filter.php?a=$area');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('Filtrado por área "$area"');
        return data['meals'];
      }
    } catch (e, s) {
      logger.e('Error en filterByArea', error: e, stackTrace: s);
    }
    return null;
  }

  Future<List<dynamic>?> filterByIngredient(String ingredient) async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en filterByIngredient');
      return null;
    }

    final url = Uri.parse('$_baseUrl/filter.php?i=$ingredient');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('Filtrado por ingrediente "$ingredient"');
        return data['meals'];
      }
    } catch (e, s) {
      logger.e('Error en filterByIngredient', error: e, stackTrace: s);
    }
    return null;
  }

  Future<List<String>> getAllCategories() async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en getAllCategories');
      return [];
    }

    final url = Uri.parse('$_baseUrl/list.php?c=list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['meals'].map((e) => e['strCategory']));
      }
    } catch (e, s) {
      logger.e('Error en getAllCategories', error: e, stackTrace: s);
    }
    return [];
  }

  Future<List<String>> getAllAreas() async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en getAllAreas');
      return [];
    }

    final url = Uri.parse('$_baseUrl/list.php?a=list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['meals'].map((e) => e['strArea']));
      }
    } catch (e, s) {
      logger.e('Error en getAllAreas', error: e, stackTrace: s);
    }
    return [];
  }

  Future<List<String>> getAllIngredients() async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en getAllIngredients');
      return [];
    }

    final url = Uri.parse('$_baseUrl/list.php?i=list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['meals'].map((e) => e['strIngredient']));
      }
    } catch (e, s) {
      logger.e('Error en getAllIngredients', error: e, stackTrace: s);
    }
    return [];
  }

  Future<List<dynamic>?> searchMealsByFirstLetter(String letter) async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en searchMealsByFirstLetter');
      return null;
    }

    final url = Uri.parse('$_baseUrl/search.php?f=$letter');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('Búsqueda por letra "$letter": ${data['meals']?.length ?? 0} resultados');
        return data['meals'];
      }
    } catch (e, s) {
      logger.e('Error en searchMealsByFirstLetter', error: e, stackTrace: s);
    }
    return null;
  }

  Future<List<dynamic>?> fetchAllMeals() async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en fetchAllMeals');
      return null;
    }

    final allMeals = <dynamic>[];
    final letters = 'abcdefghijklmnopqrstuvwxyz';

    for (var letter in letters.split('')) {
      final url = Uri.parse('$_baseUrl/search.php?f=$letter');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['meals'] != null) {
            allMeals.addAll(data['meals']);
            logger.i('Letras "$letter": ${data['meals'].length} recetas obtenidas');
          } else {
            logger.i('Letras "$letter": sin recetas');
          }
        } else {
          logger.w('Letras "$letter": respuesta inesperada ${response.statusCode}');
        }
      } catch (e, s) {
        logger.e('Error al obtener recetas para la letra "$letter"', error: e, stackTrace: s);
      }
    }

    if (allMeals.isEmpty) {
      logger.w('No se encontraron recetas para ninguna letra');
      return null;
    }

    return allMeals;
  }

  Future<Map<String, dynamic>?> fetchMealById(String id) async {
    if (!await _hasConnection()) {
      logger.w('Sin conexión en fetchMealById');
      return null;
    }

    final url = Uri.parse('$_baseUrl/lookup.php?i=$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.i('Detalle de comida obtenida para ID $id');
        return data['meals']?[0];
      }
    } catch (e, s) {
      logger.e('Error en fetchMealById', error: e, stackTrace: s);
    }
    return null;
  }
}
