import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/services/api_service.dart';
import 'package:mealit/widgets/meal_detail.dart';
import '../widgets/drawer.dart';
import '../widgets/meal_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Meal> meals = [];
  Meal? recommendedMeal;
  bool isLoading = false;
  String? error;
  String searchType = 'name';

  List<String> categories = [];
  List<String> areas = [];
  List<String> ingredients = [];
  String? selectedFilterValue;

  int _selectedIndex = 0;
  static const List<String> _routes = ['/', '/profile', '/preferences', '/favorites'];

  // Claves para SharedPreferences
  static const _prefKeyRecommendedMeal = 'recommended_meal';
  static const _prefKeyRecommendedDate = 'recommended_date';

  @override
  void initState() {
    super.initState();
    loadRecommendedMeal();
    loadDropdownData();
  }

  // Carga la receta recomendada guardada o una nueva si cambió el día
  Future<void> loadRecommendedMeal() async {
    final prefs = await SharedPreferences.getInstance();

    final savedDate = prefs.getString(_prefKeyRecommendedDate);
    final todayDate = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD

    if (savedDate == todayDate) {
      final savedMealJson = prefs.getString(_prefKeyRecommendedMeal);
      if (savedMealJson != null) {
        final mealMap = jsonDecode(savedMealJson);
        if (!mounted) return;
        setState(() {
          recommendedMeal = Meal.fromJson(mealMap);
          isLoading = false;
        });
        return;
      }
    }

    // Si no hay receta guardada para hoy o fecha diferente, carga nueva
    if (!mounted) return;
    setState(() => isLoading = true);

    final data = await apiService.fetchRandomMeal();

    if (!mounted) return;
    if (data != null) {
      await prefs.setString(_prefKeyRecommendedDate, todayDate);
      await prefs.setString(_prefKeyRecommendedMeal, jsonEncode(data));

      setState(() {
        recommendedMeal = Meal.fromJson(data);
        isLoading = false;
      });
    } else {
      setState(() {
        error = 'No se pudo cargar la comida recomendada';
        isLoading = false;
      });
    }
  }

  // Carga categorías, áreas e ingredientes para los filtros
  Future<void> loadDropdownData() async {
    final fetchedCategories = await apiService.getAllCategories();
    final fetchedAreas = await apiService.getAllAreas();
    final fetchedIngredients = await apiService.getAllIngredients();

    if (!mounted) return;
    setState(() {
      categories = fetchedCategories;
      areas = fetchedAreas;
      ingredients = fetchedIngredients;
    });
  }

  // Busca comidas según tipo y texto
  Future<void> search(String query) async {
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        meals = [];
        error = null;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      isLoading = true;
      error = null;
    });

    List<dynamic>? results;
    switch (searchType) {
      case 'ingredient':
        results = await apiService.filterByIngredient(query);
        break;
      case 'area':
        results = await apiService.filterByArea(query);
        break;
      case 'category':
        results = await apiService.filterByCategory(query);
        break;
      default:
        results = await apiService.searchMealsByName(query);
    }

    if (!mounted) return;
    setState(() {
      if (results == null || results.isEmpty) {
        meals = [];
        error = 'No se encontraron resultados';
      } else {
        meals = results.map<Meal>((json) => Meal.fromJson(json)).toList();
        error = null;
      }
      isLoading = false;
    });
  }

  // Muestra detalle de receta en modal
  Future<void> _showMealDetail(Meal meal) async {
    final data = await apiService.fetchMealById(meal.idMeal);
    if (data != null && mounted) {
      final fullMeal = Meal.fromJson(data);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (_) => MealDetailView(meal: fullMeal),
      );
    }
  }

  // Obtiene una nueva receta y la guarda, usada por botón "Nueva comida"
  Future<void> fetchNewRecommendedMeal() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final data = await apiService.fetchRandomMeal();

    if (!mounted) return;
    if (data != null) {
      final prefs = await SharedPreferences.getInstance();
      final todayDate = DateTime.now().toIso8601String().substring(0, 10);
      await prefs.setString(_prefKeyRecommendedDate, todayDate);
      await prefs.setString(_prefKeyRecommendedMeal, jsonEncode(data));

      setState(() {
        recommendedMeal = Meal.fromJson(data);
        isLoading = false;
      });
    } else {
      setState(() {
        error = 'No se pudo cargar la comida recomendada';
        isLoading = false;
      });
    }
  }

  void _onSelectPage(int index) {
    if (index == _selectedIndex) {
      Navigator.pop(context); // Cierra drawer si seleccionó la misma página
      return;
    }
    setState(() {
      _selectedIndex = index;
    });

    Navigator.popAndPushNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      drawer: MainDrawer(
        onSelectPage: _onSelectPage,
        selectedIndex: _selectedIndex,
      ),
      appBar: AppBar(
        title: const Text('MealIt'),
      ),
      body: Padding(
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
                  onTap: () => _showMealDetail(recommendedMeal!),
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
                                onPressed: fetchNewRecommendedMeal,
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
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      searchType = value;
                      selectedFilterValue = null;
                      meals = [];
                      _searchController.clear();
                      error = null;
                    });
                  }
                },
              ),
            ),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: search,
                    decoration: InputDecoration(
                      hintText: searchType == 'name'
                          ? 'Buscar por nombre...'
                          : 'Buscador',
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: searchType == 'name'
                      ? const SizedBox.shrink()
                      : DropdownButtonFormField<String>(
                          value: selectedFilterValue,
                          isExpanded: true,
                          hint: const Text('Selecciona una opción'),
                          items: (searchType == 'ingredient'
                                  ? ingredients
                                  : searchType == 'area'
                                      ? areas
                                      : categories)
                              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                selectedFilterValue = val;
                              });
                              search(val);
                            }
                          },
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

            Expanded(
              child: meals.isEmpty
                  ? Center(
                      child: Text(
                        error ?? 'No se encontraron comidas.',
                        style: textTheme.bodyLarge,
                      ),
                    )
                  : MealListWidget(meals: meals, onMealTap: _showMealDetail),
            ),
          ],
        ),
      ),
    );
  }
}
