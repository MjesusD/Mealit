import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealit/entity/recipe_model.dart';
import 'package:mealit/models/recipe_storage.dart';

class CreateRecipePage extends StatefulWidget {
  final Recipe? initialRecipe;

  const CreateRecipePage({super.key, this.initialRecipe});

  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _stepsController;
  late TextEditingController _listNameController;
  late TextEditingController _ingredientInputController;

  List<String> _ingredients = [];
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
    _ingredientInputController = TextEditingController();
    _ingredients = List<String>.from(r?.ingredients ?? []);
    _imagePath = r?.imagePath ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    _listNameController.dispose();
    _ingredientInputController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, maxWidth: 600, maxHeight: 600);
      if (picked != null) {
        if (!mounted) return;
        setState(() => _imagePath = picked.path);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  void _addIngredient() {
    final trimmed = _ingredientInputController.text.trim();
    if (trimmed.isNotEmpty && !_ingredients.contains(trimmed)) {
      setState(() {
        _ingredients.add(trimmed);
        _ingredientInputController.clear();
      });
    } else if (_ingredients.contains(trimmed)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrediente ya agregado')),
      );
    }
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
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

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isEditing ? 'Receta actualizada' : 'Receta creada')),
    );
    Navigator.of(context).pop(recipe);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar Receta' : 'Crear Receta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCard([
                _buildTextField(_nameController, 'Nombre', validator: true),
                _buildTextField(_descriptionController, 'Descripción', maxLines: 2),
                _buildTextField(_listNameController, 'Categoría (Lista)'),
              ]),
              const SizedBox(height: 16),
              _buildCard([
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _ingredientInputController,
                        decoration: const InputDecoration(hintText: 'Agregar ingrediente'),
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
                  children: List.generate(_ingredients.length, (i) {
                    final ing = _ingredients[i];
                    return Chip(
                      label: Text(ing),
                      onDeleted: () => _removeIngredient(i),
                    );
                  }),
                ),
              ], title: 'Ingredientes'),
              const SizedBox(height: 16),
              _buildCard([
                _buildTextField(_stepsController, 'Pasos', maxLines: 5, validator: true),
              ]),
              const SizedBox(height: 16),
              _buildCard([
                if (_imagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(_imagePath), height: 200, fit: BoxFit.cover),
                  ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galería'),
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Cámara'),
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                  ],
                ),
              ], title: 'Imagen'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(_isEditing ? Icons.save : Icons.check_circle),
                  label: Text(_isEditing ? 'Guardar cambios' : 'Crear receta'),
                  onPressed: _saveRecipe,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, bool validator = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
        validator: validator ? (v) => v == null || v.trim().isEmpty ? 'Requerido' : null : null,
      ),
    );
  }

  Widget _buildCard(List<Widget> children, {String? title}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}