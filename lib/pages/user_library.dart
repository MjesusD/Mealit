import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mealit/entity/recipe_model.dart';
import 'package:mealit/models/recipe_storage.dart';
import 'package:mealit/pages/create_recipe.dart';

class MyLibraryPage extends StatefulWidget {
  final VoidCallback? onRecipeEditedOrSaved;
  const MyLibraryPage({super.key, this.onRecipeEditedOrSaved});

  @override
  MyLibraryPageState createState() => MyLibraryPageState();
}

class MyLibraryPageState extends State<MyLibraryPage> {
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  String _filterCategory = 'Todas';
  String _searchText = '';
  bool _sortAsc = true;

  final List<String> _categories = ['Todas'];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final recipes = await RecipeStorage.loadRecipes();
    setState(() {
      _allRecipes = recipes;
      _extractCategories();
      _applyFilters();
    });
  }

  void _extractCategories() {
    final cats = _allRecipes.map((r) => r.listName).toSet().toList();
    cats.sort();
    _categories
      ..clear()
      ..add('Todas')
      ..addAll(cats);
  }

  void _applyFilters() {
    List<Recipe> temp = List.from(_allRecipes);
    if (_filterCategory != 'Todas') {
      temp = temp.where((r) => r.listName == _filterCategory).toList();
    }
    if (_searchText.isNotEmpty) {
      temp = temp.where((r) => r.name.toLowerCase().contains(_searchText.toLowerCase())).toList();
    }
    temp.sort((a, b) =>
        _sortAsc ? a.name.toLowerCase().compareTo(b.name.toLowerCase()) : b.name.toLowerCase().compareTo(a.name.toLowerCase()));

    setState(() {
      _filteredRecipes = temp;
    });
  }

  Future<void> _deleteRecipe(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar receta'),
        content: const Text('¿Seguro que quieres eliminar esta receta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmed != true) return;

    _allRecipes.removeWhere((r) => r.id == id);
    await RecipeStorage.saveRecipes(_allRecipes);
    if (!mounted) return;
    _applyFilters();
    widget.onRecipeEditedOrSaved?.call();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receta eliminada')));
  }

  Future<void> _editRecipe(Recipe recipe) async {
    final updatedRecipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateRecipePage(initialRecipe: recipe),
      ),
    );
    if (updatedRecipe != null) {
      final index = _allRecipes.indexWhere((r) => r.id == updatedRecipe.id);
      if (index >= 0) {
        _allRecipes[index] = updatedRecipe;
      } else {
        _allRecipes.add(updatedRecipe);
      }
      await RecipeStorage.saveRecipes(_allRecipes);
      if (!mounted) return;
      _applyFilters();
      widget.onRecipeEditedOrSaved?.call();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receta guardada')));
    }
  }

  // Exponer método para recargar desde afuera
  Future<void> reloadRecipes() async {
    await _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Buscar receta',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchText = value;
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _filterCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  _filterCategory = val;
                  _applyFilters();
                },
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: Icon(_sortAsc ? Icons.sort_by_alpha : Icons.sort),
                tooltip: 'Ordenar',
                onPressed: () {
                  _sortAsc = !_sortAsc;
                  _applyFilters();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredRecipes.isEmpty
              ? Center(
                  child: Text(
                    'No hay recetas que coincidan',
                    style: textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final r = _filteredRecipes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: r.imagePath.isNotEmpty
                              ? Image.file(File(r.imagePath), width: 64, height: 64, fit: BoxFit.cover)
                              : Container(
                                  width: 64,
                                  height: 64,
                                  color: colorScheme.primaryContainer,
                                  child: Icon(Icons.restaurant_menu, color: colorScheme.onPrimaryContainer),
                                ),
                        ),
                        title: Text(r.name, style: textTheme.titleMedium),
                        subtitle: Text(r.listName),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'editar') {
                              _editRecipe(r);
                            } else if (value == 'eliminar') {
                              _deleteRecipe(r.id);
                            }
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: 'editar', child: Text('Editar')),
                            const PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                          ],
                        ),
                        onTap: () {
                          _showRecipeDetails(r);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showRecipeDetails(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        final textTheme = Theme.of(context).textTheme;
        final colorScheme = Theme.of(context).colorScheme;
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(recipe.name, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (recipe.imagePath.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(recipe.imagePath), fit: BoxFit.cover),
                    ),
                  const SizedBox(height: 12),
                  Text('Categoría: ${recipe.listName}', style: textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Text('Descripción:', style: textTheme.titleMedium),
                  Text(recipe.description, style: textTheme.bodyMedium),
                  const SizedBox(height: 12),
                  Text('Ingredientes:', style: textTheme.titleMedium),
                  ...recipe.ingredients.map((i) => Text('• $i', style: textTheme.bodyMedium)),
                  const SizedBox(height: 12),
                  Text('Pasos:', style: textTheme.titleMedium),
                  Text(recipe.steps, style: textTheme.bodyMedium),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
