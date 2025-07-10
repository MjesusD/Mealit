import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/services/api_service.dart';
import '../widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with RouteAware {
  final ApiService apiService = ApiService();
  List<Meal> favoriteMeals = [];
  Set<String> favoriteMealIds = {};
  bool isLoading = true;

  final int _selectedIndex = 3;
  static const List<String> _routes = [
    '/home',
    '/profile',
    '/preferences',
    '/favorites',
  ];

  @override
  void initState() {
    super.initState();
    loadFavoriteMeals();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Se llama cuando volvemos a esta pantalla (por ejemplo desde Home)
    loadFavoriteMeals();
  }

  Future<void> loadFavoriteMeals() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final favIds = prefs.getStringList('favoriteMealIds') ?? [];

    if (favIds.isEmpty) {
      setState(() {
        favoriteMeals = [];
        favoriteMealIds = {};
        isLoading = false;
      });
      return;
    }

    final fetchedMeals = await Future.wait(
      favIds.map((id) => apiService.fetchMealById(id)),
    );

    setState(() {
      favoriteMealIds = favIds.toSet();
      favoriteMeals = fetchedMeals
          .whereType<Map<String, dynamic>>()
          .map((json) => Meal.fromJson(json))
          .toList();
      isLoading = false;
    });
  }

  Future<void> removeFromFavorites(Meal meal) async {
    final prefs = await SharedPreferences.getInstance();

    favoriteMealIds.remove(meal.idMeal);
    favoriteMeals.removeWhere((m) => m.idMeal == meal.idMeal);

    await prefs.setStringList('favoriteMealIds', favoriteMealIds.toList());

    setState(() {});
  }

  void _onSelectPage(int index) {
    Navigator.pop(context);
    if (index == _selectedIndex) return;

    final targetRoute = _routes[index];
    if (ModalRoute.of(context)?.settings.name == targetRoute) return;

    if (Navigator.of(context).canPop()) {
      Navigator.pushReplacementNamed(context, targetRoute);
    } else {
      Navigator.pushNamed(context, targetRoute);
    }
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
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
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
              const Text('Ingredientes:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...meal.ingredients.map((e) => Text('• $e')),
              const SizedBox(height: 12),
              const Text('Instrucciones:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(meal.instructions),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        selectedIndex: _selectedIndex,
        onSelectPage: _onSelectPage,
      ),
      appBar: AppBar(title: const Text('Recetas Favoritas')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteMeals.isEmpty
              ? const Center(child: Text('No tienes recetas favoritas.'))
              : ListView.builder(
                  itemCount: favoriteMeals.length,
                  itemBuilder: (context, index) {
                    final meal = favoriteMeals[index];
                    final isFavorite = favoriteMealIds.contains(meal.idMeal);

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Image.network(
                          meal.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(meal.name),
                        trailing: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => removeFromFavorites(meal),
                        ),
                        onTap: () => _showMealDetail(meal),
                      ),
                    );
                  },
                ),
    );
  }
}
