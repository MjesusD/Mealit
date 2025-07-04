import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<Map<String, dynamic>?> fetchRandomMeal() async {
    final url = Uri.parse('$_baseUrl/random.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        logger.i('Petición exitosa: código 200');
        final data = json.decode(response.body);
        return data['meals'][0];
      } else {
        logger.w('Error: Status code ${response.statusCode}');
        return null;
      }
    } catch (e, stacktrace) {
      logger.e(
        'Excepción al hacer petición HTTP',
        error: e,
        stackTrace: stacktrace,
      );
      return null;
    }
  }
}
