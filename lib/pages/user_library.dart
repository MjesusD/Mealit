import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mealit/entity/recipe_model.dart';
import 'package:mealit/models/recipe_storage.dart';
import 'package:mealit/pages/create_recipe.dart';

import '../widgets/recipe_detail.dart'; 

class MyLibraryPage extends StatefulWidget {
  final void Function()? onRecipeEditedOrSaved;

  const MyLibraryPage({super.key, this.onRecipeEditedOrSaved});

  @override
  MyLibraryPageState createState() => MyLibraryPageState();
}

class MyLibraryPageState extends State<MyLibraryPage> {
  List<Recipe> recipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    reloadRecipes();
  }

  Future<void> reloadRecipes() async {
    setState(() {
      isLoading = true;
    });

    final loaded = await RecipeStorage.loadRecipes();

    if (!mounted) return;

    setState(() {
      recipes = loaded;
      isLoading = false;
    });
  }

  Future<void> _editRecipe(Recipe recipe) async {
    final updatedRecipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateRecipePage(initialRecipe: recipe),
      ),
    );

    if (updatedRecipe != null) {
      await RecipeStorage.addOrUpdateRecipe(updatedRecipe);

      if (!mounted) return;

      await reloadRecipes();

      if (widget.onRecipeEditedOrSaved != null) {
        widget.onRecipeEditedOrSaved!();
      }
      // Evitamos snackbar aquí para prevenir mensajes repetidos
    }
  }

  Future<void> _deleteRecipe(Recipe recipe) async {
    await RecipeStorage.deleteRecipe(recipe.id);

    if (!mounted) return;

    await reloadRecipes();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receta eliminada')),
    );
  }

  void _showRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailPage(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recipes.isEmpty) {
      return const Center(child: Text('No tienes recetas creadas.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: recipe.imagePath.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(recipe.imagePath),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.image_not_supported),
                  ),
            title: Text(recipe.name),
            subtitle: Text(recipe.listName),
            onTap: () => _showRecipeDetail(recipe),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editRecipe(recipe),
                  tooltip: 'Editar receta',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteRecipe(recipe),
                  tooltip: 'Eliminar receta',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
