import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mealit/entity/user_profile.dart';
import 'package:mealit/pages/image_preview.dart';
import '../entity/info_chip.dart';  // Asegúrate que la ruta es correcta

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
          const SizedBox(height: 16),  // Más espacio debajo del avatar para separación
          const SizedBox(height: 12),
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
              InfoChip(
                icon: Icons.restaurant_menu,
                label: 'Hábitos',
                value: profile.dietaryHabits,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Recetas guardadas', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          profile.galleryImages.isEmpty
              ? Text(
                  'No has guardado recetas aún',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                )
              : GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  children: profile.galleryImages.map((imgPath) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImagePreviewPage(imagePath: imgPath),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(File(imgPath), fit: BoxFit.cover),
                      ),
                    );
                  }).toList(),
                ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
