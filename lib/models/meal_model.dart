class Meal {
  final String name;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;

  Meal({
    required this.name,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredientsList.add('$ingredient - $measure');
      }
    }
    return Meal(
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredientsList,
    );
  }
}
