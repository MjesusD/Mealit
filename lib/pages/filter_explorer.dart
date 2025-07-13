import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mealit/services/api_service.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/widgets/meal_list.dart';
import 'package:mealit/services/connectivity_service.dart'; 

class FilterExplorerPage extends StatefulWidget {
  const FilterExplorerPage({super.key});

  @override
  State<FilterExplorerPage> createState() => _FilterExplorerPageState();
}

class _FilterExplorerPageState extends State<FilterExplorerPage> {
  final ApiService apiService = ApiService();

  List<String> categories = [];
  List<String> areas = [];
  List<String> ingredients = [];

  String? selectedCategory;
  String? selectedArea;
  String? selectedIngredient;

  List<Meal> meals = [];
  bool isLoading = false;

  Set<String> favoriteMealIds = {};

  late StreamSubscription<bool> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    loadFilters();
    loadFavoriteMeals();

    // Suscribirse a los cambios de conectividad para recargar filtros cuando se reconecte
    _connectivitySubscription =
        ConnectivityService.instance.connectionChange.listen((connected) {
      if (connected) {
        loadFilters();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> loadFilters() async {
    try {
      final cats = await apiService.getAllCategories();
      final ars = await apiService.getAllAreas();
      final ings = await apiService.getAllIngredients();

      setState(() {
        categories = cats;
        areas = ars;
        ingredients = ings;
      });
    } catch (e) {
      setState(() {
        categories = [];
        areas = [];
        ingredients = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cargar filtros. Revisa tu conexión.'),
          ),
        );
      }
    }
  }

  Future<void> loadFavoriteMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList('favoriteMealIds') ?? [];
    setState(() {
      favoriteMealIds = favIds.toSet();
    });
  }

  Future<void> saveFavoriteMeals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteMealIds', favoriteMealIds.toList());
  }

  void onToggleFavorite(Meal meal) {
    setState(() {
      if (favoriteMealIds.contains(meal.idMeal)) {
        favoriteMealIds.remove(meal.idMeal);
      } else {
        favoriteMealIds.add(meal.idMeal);
      }
    });
    saveFavoriteMeals();
  }

  Future<void> applyFilters() async {
    setState(() {
      isLoading = true;
      meals = [];
    });

    List<dynamic>? results;

    if (selectedCategory != null) {
      results = await apiService.filterByCategory(selectedCategory!);
    } else if (selectedArea != null) {
      results = await apiService.filterByArea(selectedArea!);
    } else if (selectedIngredient != null) {
      results = await apiService.filterByIngredient(selectedIngredient!);
    }

    setState(() {
      meals = results?.map((json) => Meal.fromJson(json)).toList() ?? [];
      isLoading = false;
    });
  }

  Widget buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: items.contains(selectedValue) ? selectedValue : null,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar por filtros')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildDropdown(
              'Categoría',
              categories,
              selectedCategory,
              (val) {
                setState(() {
                  if (val != null) {
                    selectedCategory = val;
                    selectedArea = null;
                    selectedIngredient = null;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            buildDropdown(
              'Área',
              areas,
              selectedArea,
              (val) {
                setState(() {
                  if (val != null) {
                    selectedArea = val;
                    selectedCategory = null;
                    selectedIngredient = null;
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            buildDropdown(
              'Ingrediente',
              ingredients,
              selectedIngredient,
              (val) {
                setState(() {
                  if (val != null) {
                    selectedIngredient = val;
                    selectedCategory = null;
                    selectedArea = null;
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Aplicar filtros'),
              onPressed: applyFilters,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : meals.isEmpty
                      ? const Center(child: Text('No hay resultados'))
                      : MealListWidget(
                          meals: meals,
                          favoriteMealIds: favoriteMealIds,
                          onToggleFavorite: onToggleFavorite,
                          onMealTap: (meal) {
                            // Implementar el detalle 
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
