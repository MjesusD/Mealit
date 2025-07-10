import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/widgets/meal_list.dart';

class HomeView extends StatelessWidget {
  final Meal? recommendedMeal; // O null si se muestra arriba en HomePage
  final List<Meal> meals;
  final bool isLoading;
  final String? error;
  final VoidCallback onReloadRecommendedMeal;
  final void Function(Meal meal) onMealTap;

  const HomeView({
    super.key,
    required this.recommendedMeal,
    required this.meals,
    required this.isLoading,
    required this.error,
    required this.onReloadRecommendedMeal,
    required this.onMealTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text(error!, style: TextStyle(color: colorScheme.error)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (recommendedMeal != null)
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(top: 16, bottom: 24),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onReloadRecommendedMeal(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.secondaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          recommendedMeal!.imageUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comida del día',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recommendedMeal!.name,
                              style: textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: onReloadRecommendedMeal,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Nueva comida'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Buscador + Filtros alineados en fila
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                  maxLines: 1,
                  // onSubmitted lo maneja HomePage
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  items: const [],
                  onChanged: null,
                  hint: const Text('Filtros'),
                  isExpanded: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: meals.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron comidas.',
                      style: textTheme.bodyLarge,
                    ),
                  )
                : MealListWidget(meals: meals, onMealTap: onMealTap),
          ),
        ],
      ),
    );
  }
}
