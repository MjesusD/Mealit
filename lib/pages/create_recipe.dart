import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealit/entity/recipe_model.dart';
import 'package:mealit/models/recipe_storage.dart';

class CreateRecipePage extends StatefulWidget {
  final Recipe? initialRecipe;
  final void Function(Recipe recipe)? onSave;

  const CreateRecipePage({super.key, this.initialRecipe, this.onSave});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _stepsController;
  late TextEditingController _listNameController;
  List<String> _ingredients = [];
  String _newIngredient = '';
  String _imagePath = '';
  bool _isEditing = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final r = widget.initialRecipe;
    _isEditing = r != null;
    _nameController = TextEditingController(text: r?.name ?? '');
    _descriptionController = TextEditingController(text: r?.description ?? '');
    _stepsController = TextEditingController(text: r?.steps ?? '');
    _listNameController = TextEditingController(text: r?.listName ?? '');
    _ingredients = List<String>.from(r?.ingredients ?? []);
    _imagePath = r?.imagePath ?? '';
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, maxWidth: 600, maxHeight: 600);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  void _addIngredient() {
    final trimmed = _newIngredient.trim();
    if (trimmed.isNotEmpty) {
      setState(() {
        _ingredients.add(trimmed);
        _newIngredient = '';
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ingrediente')),
      );
      return;
    }
    if (_imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega una imagen a la receta')),
      );
      return;
    }

    final recipe = Recipe(
      id: widget.initialRecipe?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      steps: _stepsController.text.trim(),
      ingredients: _ingredients,
      imagePath: _imagePath,
      listName: _listNameController.text.trim().isEmpty
          ? 'General'
          : _listNameController.text.trim(),
    );

    await RecipeStorage.addOrUpdateRecipe(recipe);

    if (widget.onSave != null) widget.onSave!(recipe);
    if (!mounted) return;
    Navigator.of(context).pop(recipe);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Receta' : 'Crear Receta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),

              // Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // Categoría / Lista
              TextFormField(
                controller: _listNameController,
                decoration: const InputDecoration(labelText: 'Categoría (Lista)'),
              ),
              const SizedBox(height: 12),

              // Ingredientes
              Text('Ingredientes', style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(hintText: 'Agregar ingrediente'),
                      onChanged: (v) => _newIngredient = v,
                      onSubmitted: (_) => _addIngredient(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    color: colorScheme.primary,
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: List.generate(_ingredients.length, (index) {
                  final ingredient = _ingredients[index];
                  return Chip(
                    label: Text(ingredient),
                    onDeleted: () => _removeIngredient(index),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Pasos
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(labelText: 'Pasos'),
                maxLines: 5,
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),

              // Imagen
              Text('Imagen', style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              if (_imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(_imagePath), height: 200, fit: BoxFit.cover),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Cámara'),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Botón guardar
              ElevatedButton(
                onPressed: _saveRecipe,
                child: Text(_isEditing ? 'Guardar cambios' : 'Crear receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
