import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mealit/entity/recipe_model.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(recipe.imagePath),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text('Descripción', style: theme.textTheme.titleMedium),
            Text(recipe.description),
            const SizedBox(height: 12),
            Text('Ingredientes', style: theme.textTheme.titleMedium),
            ...recipe.ingredients.map((i) => Text('• $i')),
            const SizedBox(height: 12),
            Text('Pasos', style: theme.textTheme.titleMedium),
            Text(recipe.steps),
          ],
        ),
      ),
    );
  }
}
