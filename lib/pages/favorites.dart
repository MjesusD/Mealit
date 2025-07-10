import 'package:flutter/material.dart';
import 'package:mealit/models/profile_storage.dart';
import 'package:mealit/services/api_service.dart';
import 'package:mealit/entity/meal_model.dart';
import '../widgets/drawer.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ApiService apiService = ApiService();
  List<Meal> favoriteMeals = [];
  bool isLoading = true;

  // Índice actual para el drawer
  final int _selectedIndex = 3;

  // Rutas para navegación con drawer
  static const List<String> _routes = ['/', '/profile', '/preferences', '/favorites'];

  @override
  void initState() {
    super.initState();
    loadFavoriteMeals();
  }

  Future<void> loadFavoriteMeals() async {
    final profile = await UserProfileStorage.load();
    if (profile == null || profile.favoriteMealsIds.isEmpty) {
      setState(() {
        favoriteMeals = [];
        isLoading = false;
      });
      return;
    }

    final fetchedMeals = await Future.wait(
      profile.favoriteMealsIds.map((id) => apiService.fetchMealById(id)),
    );

    setState(() {
      favoriteMeals = fetchedMeals
          .whereType<Map<String, dynamic>>()
          .map((json) => Meal.fromJson(json))
          .toList();
      isLoading = false;
    });
  }

  void _onSelectPage(int index) {
  Navigator.pop(context); // Cierra el drawer

  if (index == _selectedIndex) {
    // Ya estamos en favoritos, no hacemos nada
    return;
  }

  final targetRoute = _routes[index];

  // Evitar navegar a la misma ruta
  if (ModalRoute.of(context)?.settings.name == targetRoute) {
    return;
  }

  if (Navigator.canPop(context)) {
    Navigator.popAndPushNamed(context, targetRoute);
  } else {
    Navigator.pushNamed(context, targetRoute);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(onSelectPage: _onSelectPage, selectedIndex: _selectedIndex),
      appBar: AppBar(title: const Text('Recetas Favoritas')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteMeals.isEmpty
              ? const Center(child: Text('No tienes recetas favoritas.'))
              : ListView.builder(
                  itemCount: favoriteMeals.length,
                  itemBuilder: (context, index) {
                    final meal = favoriteMeals[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Image.network(meal.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(meal.name),
                        onTap: () => _showMealDetail(meal),
                      ),
                    );
                  },
                ),
    );
  }

  void _showMealDetail(Meal meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meal.name, style: Theme.of(context).textTheme.headlineSmall),
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
            ],
          ),
        ),
      ),
    );
  }
}
