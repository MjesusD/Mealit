import 'package:flutter/material.dart';
import 'package:mealit/entity/user_profile.dart';
import 'package:mealit/pages/create_recipe.dart';
import 'package:mealit/pages/user_library.dart';
import 'package:mealit/pages/edit_profile.dart';
import 'package:mealit/models/profile_storage.dart';
import '../widgets/drawer.dart';
import '../widgets/profile_content.dart';

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

  static const List<String> _routes = ['/', '/profile', '/preferences', '/favorites'];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final loadedProfile = await UserProfileStorage.load();

    if (!mounted) return;

    if (loadedProfile == null) {
      // Redirigir al formulario de creación de perfil si no existe aún
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => EditProfilePage(
              profile: UserProfile(
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

    final targetRoute = _routes[index];
    Navigator.pop(context);

    if (ModalRoute.of(context)?.settings.name == targetRoute) return;

    if (targetRoute == '/preferences') {
      final result = await Navigator.pushNamed(context, targetRoute);
      if (result == true) {
        await _loadUserProfile();
      }
    } else {
      Navigator.pushNamed(context, targetRoute);
    }
  }

  void _onInternalTabTapped(int index) {
    setState(() {
      _internalTabIndex = index;
      if (index == 1) {
        _libraryKey.currentState?.reloadRecipes();
      }
    });
  }

  Future<void> _handleEditProfile() async {
    if (profile == null) return;

    final updatedProfile = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(profile: profile!),
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
        onSelectPage: _onSelectPage,
        selectedIndex: _drawerSelectedIndex,
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
                CreateRecipePage(
                  onSave: (newRecipe) {
                    setState(() {
                      _internalTabIndex = 1;
                    });
                    _libraryKey.currentState?.reloadRecipes();
                  },
                ),
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
