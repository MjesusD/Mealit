import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/services/api_service.dart';
import '../widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Agregar import para traducción
import 'package:translator/translator.dart';

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
    setState(() => isLoading = true);

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

  Future<void> compartirRecetaComoPostal(Meal meal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString('share_favorites_language') ?? 'en';

      final translator = GoogleTranslator();

      String name = meal.name;
      List<String> ingredients = meal.ingredients;
      String instructions = meal.instructions;

      if (lang == 'es') {
        // Traducir al español
        name = (await translator.translate(name, to: 'es')).text;
        final translatedIngredientsFutures =
            ingredients.map((ing) => translator.translate(ing, to: 'es')).toList();
        final translatedIngredients = await Future.wait(translatedIngredientsFutures);
        ingredients = translatedIngredients.map((t) => t.text).toList();
        instructions = (await translator.translate(instructions, to: 'es')).text;
      }

      final response = await http.get(Uri.parse(meal.imageUrl));
      final bytes = response.bodyBytes;

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${meal.idMeal}.jpg');
      await file.writeAsBytes(bytes);

      final texto = '''
🍽️ $name

📋 Ingredientes:
${ingredients.map((e) => '• $e').join('\n')}

👨‍🍳 Instrucciones:
$instructions

¡Descubre más recetas con MealIt! 🌟
''';

      if (!mounted) return;

      await Share.shareXFiles(
        [XFile(file.path)],
        text: texto,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al compartir la receta.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        selectedIndex: _selectedIndex,
        navigateSafely: widget.navigateSafely,
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
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white70,
                                            child: IconButton(
                                              icon: Icon(
                                                isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isFavorite
                                                    ? Colors.red
                                                    : Colors.grey.shade800,
                                              ),
                                              onPressed: () => removeFromFavorites(meal),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          CircleAvatar(
                                            backgroundColor: Colors.white70,
                                            child: IconButton(
                                              icon: const Icon(Icons.share),
                                              onPressed: () =>
                                                  compartirRecetaComoPostal(meal),
                                            ),
                                          ),
                                        ],
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
