import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mealit/entity/user_profile.dart';
import 'package:mealit/models/recipe_storage.dart';
import 'package:mealit/pages/image_preview.dart';
import '../entity/info_chip.dart';
import '../entity/recipe_model.dart';

class ProfileContent extends StatelessWidget {
  final UserProfile profile;

  const ProfileContent({super.key, required this.profile});

  double _calculateBMI() {
    if (profile.heightCm <= 0 || profile.weightKg <= 0) return 0;
    final heightM = profile.heightCm / 100;
    return profile.weightKg / (heightM * heightM);
  }

  String _bmiCategory(double bmi) {
    if (bmi == 0) return 'Datos insuficientes';
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  @override
  Widget build(BuildContext context) {
    final bmi = _calculateBMI();
    final bmiCat = _bmiCategory(bmi);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final dietaryHabits = profile.dietaryHabits.trim().isEmpty
        ? []
        : profile.dietaryHabits.split(',').map((e) => e.trim()).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: profile.profileImage.isNotEmpty
                ? FileImage(File(profile.profileImage))
                : null,
            child: profile.profileImage.isEmpty
                ? Icon(Icons.person, size: 60, color: colorScheme.onPrimaryContainer)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 24,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              InfoChip(
                icon: Icons.cake,
                label: 'Edad',
                value: '${profile.age} años',
              ),
              InfoChip(
                icon: Icons.monitor_weight,
                label: 'IMC',
                value: '${bmi.toStringAsFixed(1)} ($bmiCat)',
              ),
            ],
          ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text('Hábitos Alimenticios', style: textTheme.titleMedium),
          ),
          const SizedBox(height: 8),

          dietaryHabits.isEmpty
              ? Text(
                  'No tienes hábitos agregados',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: dietaryHabits
                      .map((habit) => Chip(
                            label: Text(
                              habit,
                              style: TextStyle(color: colorScheme.onPrimaryContainer),
                            ),
                            backgroundColor: colorScheme.primaryContainer,
                            avatar: Icon(
                              Icons.check_circle,
                              size: 18,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ))
                      .toList(),
                ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text('Preferencias Alimenticias', style: textTheme.titleMedium),
          ),
          const SizedBox(height: 8),

          profile.dietaryPreferences.isEmpty
              ? Text(
                  'No tienes preferencias seleccionadas',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.dietaryPreferences
                      .map((pref) => Chip(
                            label: Text(
                              pref,
                              style: TextStyle(color: colorScheme.onSecondaryContainer),
                            ),
                            backgroundColor: colorScheme.secondaryContainer,
                            avatar: Icon(
                              Icons.restaurant_menu,
                              size: 18,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ))
                      .toList(),
                ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text('Recetas guardadas', style: textTheme.titleMedium),
          ),
          const SizedBox(height: 12),

          FutureBuilder<List<Recipe>>(
            future: RecipeStorage.loadRecipes(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final recipes = snapshot.data!;
              final validRecipes = recipes
                  .where((r) => r.imagePath.isNotEmpty && File(r.imagePath).existsSync())
                  .toList();

              if (validRecipes.isEmpty) {
                return Text(
                  'No has creado recetas aún',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                );
              }

              return GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: validRecipes.map((recipe) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImagePreviewPage(imagePath: recipe.imagePath),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(recipe.imagePath), fit: BoxFit.cover),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
