import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/widgets/meal_list.dart';

class HomeView extends StatelessWidget {
  final Meal? recommendedMeal;
  final List<Meal> meals;
  final bool isLoading;
  final String? error;
  final bool hasSearched;

  final VoidCallback onReloadRecommendedMeal;
  final VoidCallback onRecommendedMealTap;
  final void Function(Meal meal) onMealTap;

  final TextEditingController searchController;
  final void Function(String) onSearchSubmitted;
  final VoidCallback onMicPressed;
  final bool isListening;

  final String searchType;
  final void Function(String?) onSearchTypeChanged;
  final List<String> filterOptions;
  final String? selectedFilterValue;
  final void Function(String?) onFilterValueChanged;

  final void Function(String) onLetterSelected;
  final String selectedLetter;

  final Set<String> favoriteMealIds;
 final void Function(Meal meal) onToggleFavorite;

  const HomeView({
    super.key,
    required this.recommendedMeal,
    required this.meals,
    required this.isLoading,
    required this.error,
    required this.onReloadRecommendedMeal,
    required this.onRecommendedMealTap,
    required this.onMealTap,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.onMicPressed,
    required this.isListening,
    required this.searchType,
    required this.onSearchTypeChanged,
    required this.filterOptions,
    required this.selectedFilterValue,
    required this.onFilterValueChanged,
    required this.onLetterSelected,
    required this.selectedLetter,
    required this.hasSearched,
    required this.favoriteMealIds,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
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
                onTap: onRecommendedMealTap,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Dropdown para tipo de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: DropdownButtonFormField<String>(
              value: searchType,
              decoration: InputDecoration(
                labelText: 'Buscar por',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Nombre')),
                DropdownMenuItem(value: 'ingredient', child: Text('Ingrediente')),
                DropdownMenuItem(value: 'area', child: Text('Área')),
                DropdownMenuItem(value: 'category', child: Text('Categoría')),
              ],
              onChanged: onSearchTypeChanged,
            ),
          ),

          // Barra de letras para búsqueda por primera letra (solo si searchType es 'name' y texto vacío)
          if (searchType == 'name' && searchController.text.isEmpty)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 26,
                itemBuilder: (context, index) {
                  final letter = String.fromCharCode(65 + index).toLowerCase();
                  final isSelected = selectedLetter == letter;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(letter.toUpperCase()),
                      selected: isSelected,
                      onSelected: (_) => onLetterSelected(letter),
                      selectedColor: colorScheme.primaryContainer,
                    ),
                  );
                },
              ),
            ),

          // Fila: buscador + dropdown filtro dinámico
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: searchController,
                  onSubmitted: onSearchSubmitted,
                  decoration: InputDecoration(
                    hintText: searchType == 'name' ? 'Buscar por nombre...' : 'Buscar',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(isListening ? Icons.mic : Icons.mic_none),
                      onPressed: onMicPressed,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: selectedFilterValue,
                  isExpanded: true,
                  hint: const Text('Selecciona una opción'),
                  items: filterOptions
                      .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: onFilterValueChanged,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Mostrar mensaje de error solo si hubo búsqueda y no hay resultados
          if (hasSearched && error != null && meals.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                error!,
                style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
              ),
            ),

          Expanded(
            child: meals.isEmpty
                ? Center(
                    child: Text(
                      'No hay comidas para mostrar.',
                      style: textTheme.bodyLarge,
                    ),
                  )
                : MealListWidget(
                    meals: meals,
                    onMealTap: onMealTap,
                    favoriteMealIds: favoriteMealIds,
                    onToggleFavorite: onToggleFavorite,
                  ),
          ),
        ],
      ),
    );
  }
}
