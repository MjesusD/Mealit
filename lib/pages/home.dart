import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/services/api_service.dart';
import '../widgets/drawer.dart';
import '../widgets/meal_voice.dart';
import '../widgets/home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText speech;
  final GoogleTranslator translator = GoogleTranslator();

  List<Meal> meals = [];
  Meal? recommendedMeal;
  bool isLoading = false;
  String? error;
  String searchType = 'name';
  bool hasSearched = false;

  List<String> categories = [];
  List<String> areas = [];
  List<String> ingredients = [];
  String? selectedFilterValue;

  String selectedLetter = 'a';

  bool isListening = false;

  int _selectedIndex = 0;
  static const List<String> _routes = ['/home', '/profile', '/preferences', '/favorites'];

  static const _prefKeyRecommendedMeal = 'recommended_meal';
  static const _prefKeyRecommendedDate = 'recommended_date';

  Set<String> favoriteMealIds = {};

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    loadFavoriteMeals();
    loadRecommendedMeal();
    loadDropdownData();

    if (searchType == 'name') {
      Future.microtask(() => searchByLetter(selectedLetter));
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

void toggleFavorite(Meal meal) {
  setState(() {
    if (favoriteMealIds.contains(meal.idMeal)) {
      favoriteMealIds.remove(meal.idMeal);
    } else {
      favoriteMealIds.add(meal.idMeal);
    }
  });
  saveFavoriteMeals();
}

  Future<void> loadRecommendedMeal() async {
    final prefs = await SharedPreferences.getInstance();

    final savedDate = prefs.getString(_prefKeyRecommendedDate);
    final todayDate = DateTime.now().toIso8601String().substring(0, 10);

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

  Future<void> searchByLetter(String letter) async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      error = null;
      hasSearched = true;
      meals = [];
    });

    final results = await apiService.searchMealsByFirstLetter(letter);

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

  Future<void> search(String query) async {
    if (searchType == 'name' && query.isEmpty) {
      await searchByLetter(selectedLetter);
      return;
    }

    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        meals = [];
        error = null;
        hasSearched = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      isLoading = true;
      error = null;
      hasSearched = true;
    });

    String queryToUse = query;
    if (searchType == 'name') {
      try {
        final translation = await translator.translate(query, to: 'en');
        queryToUse = translation.text;
      } catch (_) {}
    }

    List<dynamic>? results;
    switch (searchType) {
      case 'ingredient':
        results = await apiService.filterByIngredient(queryToUse);
        break;
      case 'area':
        results = await apiService.filterByArea(queryToUse);
        break;
      case 'category':
        results = await apiService.filterByCategory(queryToUse);
        break;
      default:
        results = await apiService.searchMealsByName(queryToUse);
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
        builder: (_) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, scrollController) => ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: Material(
              child: MealVoice(meal: fullMeal),
            ),
          ),
        ),
      );
    }
  }

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
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context); // Cierra el drawer

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushNamed(context, _routes[index]);
    }
  }

  void _listen() async {
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => isListening = false);
          }
        },
        onError: (val) {
          setState(() => isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al usar micrófono: ${val.errorMsg}')),
          );
        },
      );
      if (available) {
        setState(() => isListening = true);
        speech.listen(
          localeId: 'es_ES',
          onResult: (val) async {
            setState(() {
              _searchController.text = val.recognizedWords;
            });
            if (val.hasConfidenceRating && val.confidence > 0.7) {
              await search(val.recognizedWords);
            }
          },
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de micrófono denegado o no disponible.')),
        );
      }
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        selectedIndex: _selectedIndex,
        onSelectPage: _onSelectPage,
      ),
      appBar: AppBar(
        title: const Text('MealIt'),
      ),
      body: HomeView(
        recommendedMeal: recommendedMeal,
        meals: meals,
        isLoading: isLoading,
        error: error,
        onReloadRecommendedMeal: fetchNewRecommendedMeal,
        onRecommendedMealTap: () {
          if (recommendedMeal != null) {
            _showMealDetail(recommendedMeal!);
          }
        },
        onMealTap: _showMealDetail,
        searchController: _searchController,
        onSearchSubmitted: search,
        onMicPressed: _listen,
        isListening: isListening,
        searchType: searchType,
        onSearchTypeChanged: (val) {
          if (val != null) {
            setState(() {
              searchType = val;
              selectedFilterValue = null;
              meals = [];
              _searchController.clear();
              error = null;
              hasSearched = false;

              if (val == 'name') {
                selectedLetter = 'a';
                searchByLetter(selectedLetter);
              }
            });
          }
        },
        filterOptions: searchType == 'ingredient'
            ? ingredients
            : searchType == 'area'
                ? areas
                : searchType == 'category'
                    ? categories
                    : [],
        selectedFilterValue: selectedFilterValue,
        onFilterValueChanged: (val) {
          if (val != null) {
            setState(() {
              selectedFilterValue = val;
            });
            search(val);
          }
        },
        onLetterSelected: (letter) {
          setState(() {
            selectedLetter = letter;
          });
          searchByLetter(letter);
        },
        selectedLetter: selectedLetter,
        hasSearched: hasSearched,

        favoriteMealIds: favoriteMealIds,
        onToggleFavorite: toggleFavorite,
      ),
    );
  }
}
