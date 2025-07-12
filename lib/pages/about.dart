import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class AboutPage extends StatelessWidget {
  final Future<void> Function(BuildContext, String) navigateSafely;

  const AboutPage({super.key, required this.navigateSafely});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de MealIt'),
        backgroundColor: colorScheme.primary,
      ),
      drawer: MainDrawer(
        selectedIndex: 4, // índice correspondiente al About en tu menú
        navigateSafely: navigateSafely,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Image.asset(
                'assets/icons/about_logo.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 12),
            Text(
              'Mealit es una aplicación para descubrir recetas deliciosas y saludables. '
              'Puedes explorar comidas de diferentes categorías, guardar tus favoritas, '
              'y personalizar tus preferencias alimenticias.',
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Versión 1.0.0',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                '© 2025 MealIt. Todos los derechos reservados.',
                style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
