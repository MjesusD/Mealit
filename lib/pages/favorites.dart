import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/services/api_service.dart';
import '../widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class FavoritesPage extends StatefulWidget {
  final Future<void> Function(BuildContext, String) navigateSafely;

  const FavoritesPage({super.key, required this.navigateSafely});

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
    '/about',
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

  void _onSelectPage(int index) async {
    Navigator.pop(context);

    if (index == _selectedIndex) return;

    final targetRoute = _routes[index];
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == targetRoute) return;

    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;

    widget.navigateSafely(context, targetRoute);
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
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GridView.builder(
                    itemCount: favoriteMeals.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final meal = favoriteMeals[index];
                      final isFavorite = favoriteMealIds.contains(meal.idMeal);

                      return GestureDetector(
                        onTap: () => _showMealDetail(meal),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          shadowColor: Colors.black45,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: meal.idMeal,
                                      child: Image.network(
                                        meal.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return const Center(child: CircularProgressIndicator());
                                        },
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Center(child: Icon(Icons.error)),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white70,
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite ? Icons.favorite : Icons.favorite_border,
                                            color: isFavorite ? Colors.red : Colors.grey.shade800,
                                          ),
                                          onPressed: () => removeFromFavorites(meal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  meal.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
