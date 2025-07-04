import 'package:flutter_test/flutter_test.dart';
import 'package:mealit/services/api_service.dart';

void main() {
  final apiService = ApiService();

  test('Obtiene una comida aleatoria desde la API', () async {
    final meal = await apiService.fetchRandomMeal();

    expect(meal, isNotNull);
    expect(meal!['strMeal'], isNotEmpty);
    expect(meal['strInstructions'], isNotEmpty);
    expect(meal['strMealThumb'], isNotEmpty);
  });
}
