import 'package:flutter/material.dart'; 
import 'package:mealit/entity/user_profile.dart';
import 'package:mealit/models/profile_storage.dart';
import '../widgets/drawer.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool vegetarian = false;
  bool vegan = false;

  late UserProfile profile;
  bool isLoading = true;

  static const List<String> _routes = ['/', '/profile', '/preferences', '/favorites'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefsProfile = await UserProfileStorage.load();

    if (prefsProfile == null) {
      profile = UserProfile(
        name: '',
        age: 0,
        bio: '',
        profileImage: '',
        galleryImages: [],
        heightCm: 0,
        weightKg: 0,
        dietaryHabits: '',
        dietaryPreferences: [],
        favoriteMealsIds: [],
      );
    } else {
      profile = prefsProfile;
      vegetarian = profile.dietaryPreferences.contains('vegetarian');
      vegan = profile.dietaryPreferences.contains('vegan');
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    final prefsList = <String>[];
    if (vegetarian) prefsList.add('vegetarian');
    if (vegan) prefsList.add('vegan');

    final updatedProfile = profile.copyWith(dietaryPreferences: prefsList);

    await UserProfileStorage.save(updatedProfile);

    if (!mounted) return;
    setState(() {
      profile = updatedProfile;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferencias guardadas')),
    );
  }

  void _onSelectPage(int index) {
  if (index == 2) {
    Navigator.pop(context); // Ya en preferencias, solo cierra drawer
    return;
  }

  Navigator.pop(context); // cerrar drawer

  final targetRoute = _routes[index];

  // Evitar navegar a la misma ruta
  if (ModalRoute.of(context)?.settings.name == targetRoute) {
    return;
  }

  // Si se puede hacer pop, hacemos popAndPush (reemplazo),
  // si no, hacemos push normal para evitar el error
  if (Navigator.canPop(context)) {
    Navigator.popAndPushNamed(context, targetRoute);
  } else {
    Navigator.pushNamed(context, targetRoute);
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      drawer: MainDrawer(onSelectPage: _onSelectPage, selectedIndex: 2),
      appBar: AppBar(
        title: const Text('Preferencias'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Vegetariano'),
              value: vegetarian,
              onChanged: (val) => setState(() => vegetarian = val),
            ),
            SwitchListTile(
              title: const Text('Vegano'),
              value: vegan,
              onChanged: (val) => setState(() => vegan = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePreferences,
              child: const Text('Guardar Preferencias'),
            ),
          ],
        ),
      ),
    );
  }
}
