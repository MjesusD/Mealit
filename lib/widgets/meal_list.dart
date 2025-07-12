import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';

class MealListWidget extends StatelessWidget {
  final List<Meal> meals;
  final void Function(Meal meal)? onMealTap;
  final Set<String> favoriteMealIds;
  final void Function(Meal meal) onToggleFavorite;

  const MealListWidget({
    super.key,
    required this.meals,
    this.onMealTap,
    required this.favoriteMealIds,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: meals.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final meal = meals[index];
        final isFavorite = favoriteMealIds.contains(meal.idMeal);

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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 30),
                  );
                },
              ),
            ),
            title: Text(meal.name),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () => onToggleFavorite(meal),
            ),
          ),
        );
      },
    );
  }
}
