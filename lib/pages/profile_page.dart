import 'package:flutter/material.dart';
import 'package:mealit/entity/user_profile.dart';
import 'package:mealit/pages/create_recipe.dart';
import 'package:mealit/pages/user_library.dart';
import 'package:mealit/pages/edit_profile.dart';
import 'package:mealit/models/profile_storage.dart';
import '../widgets/drawer.dart';
import '../widgets/profile_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String title;

  const ProfilePage({super.key, required this.title});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? profile;

  int _internalTabIndex = 0;
  final GlobalKey<MyLibraryPageState> _libraryKey = GlobalKey();
  final int _drawerSelectedIndex = 1;

  static const List<String> _routes = [
    '/home',
    '/profile',
    '/preferences',
    '/favorites',
    '/about',

  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    // Cargo perfil guardado
    final loadedProfile = await UserProfileStorage.load();

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';

    if (!mounted) return;

    if (loadedProfile == null) {
      // Si no hay perfil guardado, creo uno nuevo con el username del login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => EditProfilePage(
              profile: UserProfile(
                name: username,
                age: 0,
                bio: '',
                profileImage: '',
                galleryImages: [],
                heightCm: 0,
                weightKg: 0,
                dietaryHabits: '',
                dietaryPreferences: [],
                favoriteMealsIds: [],
              ),
            ),
          ),
        );
      });
      return;
    }

    setState(() {
      profile = loadedProfile;
    });
  }

  void _onSelectPage(int index) async {
    if (index == _drawerSelectedIndex) {
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context);

    final targetRoute = _routes[index];

    if (ModalRoute.of(context)?.settings.name == targetRoute) return;

    if (targetRoute == '/preferences') {
      final result = await Navigator.pushNamed(context, targetRoute);
      if (result == true) {
        await _loadUserProfile();
      }
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.pushReplacementNamed(context, targetRoute);
      } else {
        Navigator.pushNamed(context, targetRoute);
      }
    }
  }

  void _onInternalTabTapped(int index) async {
    if (index == 2) {
      final newRecipe = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CreateRecipePage()),
      );
      if (newRecipe != null) {
        setState(() {
          _internalTabIndex = 1;
        });
        _libraryKey.currentState?.reloadRecipes();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receta creada correctamente')),
        );
      }
      return;
    }

    setState(() {
      _internalTabIndex = index;
      if (index == 1) {
        _libraryKey.currentState?.reloadRecipes();
      }
    });
  }

  Future<void> _handleEditProfile() async {
  if (profile == null) return;

  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username') ?? '';

  if(!mounted)return;
  // Guardamos el Navigator local antes del await
  final navigator = Navigator.of(context);

  final updatedProfile = await navigator.push<UserProfile>(
    MaterialPageRoute(
      builder: (context) => EditProfilePage(
        profile: profile!.copyWith(
          name: username.isNotEmpty ? username : profile!.name,
        ),
      ),
    ),
  );

  if (!mounted) return;

  if (updatedProfile != null) {
    await UserProfileStorage.save(updatedProfile);
    setState(() {
      profile = updatedProfile;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: MainDrawer(
        selectedIndex: _drawerSelectedIndex,
        onSelectPage: _onSelectPage,
      ),
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar perfil',
            onPressed: _handleEditProfile,
          ),
        ],
      ),
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _internalTabIndex,
              children: [
                ProfileContent(profile: profile!),
                MyLibraryPage(
                  key: _libraryKey,
                  onRecipeEditedOrSaved: () {
                    _libraryKey.currentState?.reloadRecipes();
                  },
                ),
                Container(), // Placeholder vacío para CreateRecipePage
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _internalTabIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Mis Recetas'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Crear Receta'),
        ],
        onTap: _onInternalTabTapped,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withAlpha(120),
        backgroundColor: colorScheme.surface,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
