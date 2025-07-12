import 'package:flutter/material.dart';
import 'package:mealit/entity/user_profile.dart';
import 'package:mealit/models/profile_storage.dart';
import '../widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesPage extends StatefulWidget {
  final Future<void> Function(BuildContext, String) navigateSafely;

  const PreferencesPage({super.key, required this.navigateSafely});

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

  final int _drawerSelectedIndex = 2;

  String _shareLanguage = 'en'; // idioma para compartir recetas ('en' o 'es')

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
      for (var key in _availablePreferences.keys) key: profile.dietaryPreferences.contains(key),
    };

    _dietaryHabitsList = profile.dietaryHabits.isEmpty
        ? []
        : profile.dietaryHabits.split(',').map((e) => e.trim()).toList();

    // Cargar preferencia de idioma para compartir recetas
    final sp = await SharedPreferences.getInstance();
    _shareLanguage = sp.getString('share_favorites_language') ?? 'en';

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    final updatedProfile = profile.copyWith(
      dietaryPreferences: _selectedPrefs.entries.where((e) => e.value).map((e) => e.key).toList(),
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

  Future<void> _saveShareLanguage(String lang) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('share_favorites_language', lang);

    setState(() {
      _shareLanguage = lang;
    });
    if(!mounted)return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Idioma para compartir recetas guardado: ${lang == 'es' ? 'Español' : 'Inglés'}'),
        duration: const Duration(seconds: 1),
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
    return true; // Puedes agregar lógica aquí si quieres controlar la salida
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
          navigateSafely: widget.navigateSafely,
        ),
        appBar: AppBar(title: const Text('Preferencias')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Selector idioma para compartir recetas favoritas
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Enviar recetas favoritas en:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  DropdownButton<String>(
                    value: _shareLanguage,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text(' Inglés')),
                      DropdownMenuItem(value: 'es', child: Text(' Español')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        _saveShareLanguage(val);
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),
              
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
                        secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
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
