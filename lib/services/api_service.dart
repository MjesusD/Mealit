import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<dynamic>?> searchMealsByName(String name) async {
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

  // Buscar por categoría
  Future<List<dynamic>?> filterByCategory(String category) async {
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

  // Buscar por país / región
  Future<List<dynamic>?> filterByArea(String area) async {
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

  // Buscar por ingrediente
  Future<List<dynamic>?> filterByIngredient(String ingredient) async {
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

  // Obtener todas las categorías
  Future<List<String>> getAllCategories() async {
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

  // Obtener todas las áreas
  Future<List<String>> getAllAreas() async {
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

  // Obtener todos los ingredientes
  Future<List<String>> getAllIngredients() async {
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

  Future<Map<String, dynamic>?> fetchMealById(String id) async {
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
