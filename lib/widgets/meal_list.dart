import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';

class MealListWidget extends StatelessWidget {
  final List<Meal> meals;
  final void Function(Meal meal)? onMealTap;

  const MealListWidget({
    super.key,
    required this.meals,
    this.onMealTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: meals.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final meal = meals[index];
        return GestureDetector(
          onTap: () => onMealTap?.call(meal),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                meal.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(meal.name),
          ),
        );
      },
    );
  }
}