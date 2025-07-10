import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/services/api_service.dart';

class MealExplorer extends StatefulWidget {
  const MealExplorer({super.key});

  @override
  State<MealExplorer> createState() => _MealExplorerState();
}

class _MealExplorerState extends State<MealExplorer> {
  final ApiService apiService = ApiService();
  List<Meal> meals = [];
  String query = '';
  bool isLoading = false;
  String? error;

  Future<void> searchMeals(String text) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final data = await apiService.searchMealsByName(text);
    if (data != null && data.isNotEmpty) {
      setState(() {
        meals = data.map((json) => Meal.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        meals = [];
        error = 'No se encontraron resultados.';
        isLoading = false;
      });
    }
  }

  void showMealDetail(Meal meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(meal.name, style: Theme.of(context).textTheme.headlineSmall),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(meal.imageUrl),
              ),
              const SizedBox(height: 12),
              const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...meal.ingredients.map((e) => Text('• $e')),
              const SizedBox(height: 12),
              const Text('Instrucciones:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(meal.instructions),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar recetas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar comida...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                query = value;
              },
              onSubmitted: searchMeals,
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: meals.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return ListTile(
                      leading: Image.network(meal.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                      title: Text(meal.name),
                      onTap: () => showMealDetail(meal),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
