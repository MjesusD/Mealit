import 'package:flutter/material.dart';
import 'package:mealit/services/api_service.dart';
import 'package:mealit/models/meal_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  Meal? meal;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  Future<void> loadMeal() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    final data = await apiService.fetchRandomMeal();
    if (data != null) {
      setState(() {
        meal = Meal.fromJson(data);
        isLoading = false;
      });
    } else {
      setState(() {
        error = 'Error al cargar la comida.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MealIt - Comida del Día')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : error != null
                ? Text(error!)
                : meal == null
                    ? const Text('No hay datos')
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(meal!.imageUrl),
                            const SizedBox(height: 16),
                            Text(meal!.name, style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 12),
                            const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...meal!.ingredients.map((e) => Text('• $e')),
                            const SizedBox(height: 12),
                            const Text('Instrucciones:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(meal!.instructions),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                onPressed: loadMeal,
                                child: const Text('Otra comida'),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
