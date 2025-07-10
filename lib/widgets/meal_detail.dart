import 'package:flutter/material.dart';
import 'package:mealit/entity/meal_model.dart';
import 'package:mealit/models/profile_storage.dart';

class MealDetailView extends StatefulWidget {
  final Meal meal;
  const MealDetailView({super.key, required this.meal});

  @override
  State<MealDetailView> createState() => _MealDetailViewState();
}

class _MealDetailViewState extends State<MealDetailView> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final profile = await UserProfileStorage.load();
    if (profile != null && profile.favoriteMealsIds.contains(widget.meal.idMeal)) {
      setState(() => isFavorite = true);
    }
  }

  Future<void> _toggleFavorite() async {
    final profile = await UserProfileStorage.load();
    if (profile == null) return;
    setState(() => isFavorite = !isFavorite);
    if (isFavorite) {
      profile.favoriteMealsIds.add(widget.meal.idMeal);
    } else {
      profile.favoriteMealsIds.remove(widget.meal.idMeal);
    }
    await UserProfileStorage.save(profile);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.meal.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.meal.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Ingredientes:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...widget.meal.ingredients.map((e) => Text('• $e')),
            const SizedBox(height: 10),
            const Text('Instrucciones:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.meal.instructions, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
