import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mealit/entity/recipe_model.dart';
import 'package:mealit/models/recipe_storage.dart';
import 'package:mealit/pages/create_recipe.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/recipe_detail.dart';

class MyLibraryPage extends StatefulWidget {
  final void Function()? onRecipeEditedOrSaved;
  final void Function()? onBack;

  const MyLibraryPage({super.key, this.onRecipeEditedOrSaved, this.onBack});

  @override
  MyLibraryPageState createState() => MyLibraryPageState();
}

class MyLibraryPageState extends State<MyLibraryPage> {
  List<Recipe> recipes = [];
  List<Recipe> filteredRecipes = [];
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reloadRecipes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredRecipes = recipes.where((r) {
        final name = r.name.toLowerCase();
        final category = r.listName.toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();
    });
  }

  Future<void> reloadRecipes() async {
    setState(() => isLoading = true);
    final loaded = await RecipeStorage.loadRecipes();
    if (!mounted) return;
    setState(() {
      recipes = loaded;
      filteredRecipes = loaded;
      isLoading = false;
    });
  }

  Future<void> _editRecipe(Recipe recipe) async {
    final updated = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(builder: (_) => CreateRecipePage(initialRecipe: recipe)),
    );

    if (updated != null) {
      await RecipeStorage.addOrUpdateRecipe(updated);
      if (!mounted) return;
      await reloadRecipes();
      widget.onRecipeEditedOrSaved?.call();
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
      MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: recipe)),
    );
  }

  Future<void> _shareRecipe(Recipe recipe) async {
    final buffer = StringBuffer();
    buffer.writeln('Receta: ${recipe.name}');
    buffer.writeln('Categoría: ${recipe.listName}');
    buffer.writeln('Ingredientes:');
    for (var ing in recipe.ingredients) {
      buffer.writeln('- $ing');
    }
    buffer.writeln('\nPasos:\n${recipe.steps}');

    if (recipe.imagePath.isNotEmpty) {
      final imageFile = File(recipe.imagePath);
      if (await imageFile.exists()) {
        await Share.shareXFiles(
          [XFile(recipe.imagePath)],
          text: buffer.toString(),
          subject: recipe.name,
        );
        return;
      }
    }

    Share.share(buffer.toString(), subject: recipe.name);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Recetas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack ?? () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Buscar por nombre o categoría',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredRecipes.isEmpty
                      ? const Center(child: Text('No se encontraron recetas.'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredRecipes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final recipe = filteredRecipes[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: InkWell(
                                onTap: () => _showRecipeDetail(recipe),
                                borderRadius: BorderRadius.circular(16),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          const BorderRadius.horizontal(left: Radius.circular(16)),
                                      child: recipe.imagePath.isNotEmpty
                                          ? Image.file(
                                              File(recipe.imagePath),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey[300],
                                              child:
                                                  const Icon(Icons.image_not_supported, size: 40),
                                            ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(recipe.name,
                                                style: theme.textTheme.titleMedium
                                                    ?.copyWith(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(
                                              recipe.listName,
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(color: Colors.grey[700]),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.share),
                                                  tooltip: 'Compartir receta',
                                                  onPressed: () => _shareRecipe(recipe),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  tooltip: 'Editar receta',
                                                  onPressed: () => _editRecipe(recipe),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete),
                                                  tooltip: 'Eliminar receta',
                                                  onPressed: () => _deleteRecipe(recipe),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
