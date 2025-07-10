import 'package:flutter/material.dart';
import 'package:mealit/services/api_service.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/widgets/meal_list.dart';

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

  @override
  void initState() {
    super.initState();
    loadFilters();
  }

  Future<void> loadFilters() async {
    final cats = await apiService.getAllCategories();
    final ars = await apiService.getAllAreas();
    final ings = await apiService.getAllIngredients();

    setState(() {
      categories = cats;
      areas = ars;
      ingredients = ings;
    });
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

    if (results != null) {
      setState(() {
        meals = (results ?? []).map((json) => Meal.fromJson(json)).toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: selectedValue,
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
            buildDropdown('Categoría', categories, selectedCategory, (val) => setState(() => selectedCategory = val)),
            const SizedBox(height: 12),
            buildDropdown('Área', areas, selectedArea, (val) => setState(() => selectedArea = val)),
            const SizedBox(height: 12),
            buildDropdown('Ingrediente', ingredients, selectedIngredient, (val) => setState(() => selectedIngredient = val)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Aplicar filtros'),
              onPressed: applyFilters,
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (meals.isEmpty)
              const Text('No hay resultados')
            else
              Expanded(child: MealListWidget(meals: meals)),
          ],
        ),
      ),
    );
  }
}
