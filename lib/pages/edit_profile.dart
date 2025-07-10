import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealit/entity/user_profile.dart';
import 'package:mealit/models/profile_storage.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bioController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  String? _profileImagePath; // ruta local de la imagen

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p.name);
    _ageController = TextEditingController(text: p.age.toString());
    _bioController = TextEditingController(text: p.bio);
    _heightController = TextEditingController(text: p.heightCm.toString());
    _weightController = TextEditingController(text: p.weightKg.toString());
    _profileImagePath = p.profileImage.isNotEmpty ? p.profileImage : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    final updatedProfile = widget.profile.copyWith(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? widget.profile.age,
      bio: _bioController.text.trim(),
      heightCm: double.tryParse(_heightController.text.trim()) ?? widget.profile.heightCm,
      weightKg: double.tryParse(_weightController.text.trim()) ?? widget.profile.weightKg,
      profileImage: _profileImagePath ?? '',
      // No se toca dietaryHabits aquí porque se maneja desde Preferencias
    );

    await UserProfileStorage.save(updatedProfile);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil guardado')),
    );

    Navigator.pop(context, updatedProfile);
  }

  Widget _buildProfileImage() {
    final double size = 120;
    if (_profileImagePath != null && _profileImagePath!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: FileImage(File(_profileImagePath!)),
      );
    } else {
      return CircleAvatar(
        radius: size / 2,
        child: Icon(Icons.person, size: size * 0.6),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _buildProfileImage(),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'Biografía'),
              maxLines: 3,
            ),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Altura (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Peso (kg)'),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
