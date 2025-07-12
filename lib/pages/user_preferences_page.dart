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
  final Map<String, Map<String, dynamic>> _availablePreferences = {
    'vegetarian': {'label': 'Vegetariano', 'icon': Icons.eco},
    'vegan': {'label': 'Vegano', 'icon': Icons.spa},
    'gluten_free': {'label': 'Sin gluten', 'icon': Icons.no_food},
    'dairy_free': {'label': 'Sin lácteos', 'icon': Icons.free_breakfast},
    'pescatarian': {'label': 'Pescetariano', 'icon': Icons.set_meal},
  };

  Map<String, bool> _selectedPrefs = {};
  late UserProfile profile;
  bool isLoading = true;

  final TextEditingController _habitController = TextEditingController();
  List<String> _dietaryHabitsList = [];

  // Drawer selected index
  final int _drawerSelectedIndex = 2;
  static const List<String> _routes = ['/home', '/profile', '/preferences', '/favorites', '/about'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefsProfile = await UserProfileStorage.load();

    profile = prefsProfile ??
        UserProfile(
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

    _selectedPrefs = {
      for (var key in _availablePreferences.keys)
        key: profile.dietaryPreferences.contains(key),
    };

    _dietaryHabitsList = profile.dietaryHabits.isEmpty
        ? []
        : profile.dietaryHabits.split(',').map((e) => e.trim()).toList();

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    final updatedProfile = profile.copyWith(
      dietaryPreferences:
          _selectedPrefs.entries.where((e) => e.value).map((e) => e.key).toList(),
      dietaryHabits: _dietaryHabitsList.join(', '),
    );

    await UserProfileStorage.save(updatedProfile);

    if (!mounted) return;

    setState(() {
      profile = updatedProfile;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferencias guardadas'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _onPreferenceChanged(String key, bool? value) {
    setState(() {
      _selectedPrefs[key] = value ?? false;
    });
    _savePreferences();
  }

  void _addHabit(String habit) {
    final trimmed = habit.trim();
    if (trimmed.isNotEmpty && !_dietaryHabitsList.contains(trimmed)) {
      setState(() {
        _dietaryHabitsList.add(trimmed);
      });
      _habitController.clear();
      _savePreferences();
    }
  }

  void _removeHabit(String habit) {
    setState(() {
      _dietaryHabitsList.remove(habit);
    });
    _savePreferences();
  }

  Future<bool> _onWillPop() async {
    // Guardado automático, sin alerta al salir
    return true;
  }

  void _onSelectPage(int index) {
    if (index == _drawerSelectedIndex) {
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context);

    final targetRoute = _routes[index];

    if (ModalRoute.of(context)?.settings.name == targetRoute) {
      // Ya estamos en la ruta, no navegamos
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.pushReplacementNamed(context, targetRoute);
    } else {
      Navigator.pushNamed(context, targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: MainDrawer(
          selectedIndex: _drawerSelectedIndex,
          onSelectPage: _onSelectPage,
        ),
        appBar: AppBar(title: const Text('Preferencias')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Elige tus preferencias alimenticias',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    ..._availablePreferences.entries.map((entry) {
                      final key = entry.key;
                      final label = entry.value['label'] as String;
                      final icon = entry.value['icon'] as IconData;
                      return CheckboxListTile(
                        secondary:
                            Icon(icon, color: Theme.of(context).colorScheme.primary),
                        title: Text(label),
                        value: _selectedPrefs[key] ?? false,
                        onChanged: (val) => _onPreferenceChanged(key, val),
                      );
                    }),
                    const Divider(height: 40),
                    Text(
                      'Añade tus hábitos alimenticios',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _dietaryHabitsList
                          .map((habit) => Chip(
                                label: Text(habit),
                                deleteIcon: const Icon(Icons.close),
                                onDeleted: () => _removeHabit(habit),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _habitController,
                            decoration: const InputDecoration(
                              hintText: 'Añadir nuevo hábito',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            ),
                            onSubmitted: _addHabit,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _addHabit(_habitController.text),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
