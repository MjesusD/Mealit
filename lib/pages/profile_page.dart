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
  final Future<void> Function(BuildContext, String) navigateSafely;

  const ProfilePage({
    super.key,
    required this.title,
    required this.navigateSafely,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? profile;

  int _internalTabIndex = 0;
  final GlobalKey<MyLibraryPageState> _libraryKey = GlobalKey();
  final int _drawerSelectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';

    final loadedProfile = await UserProfileStorage.load();

    if (!mounted) return;

    if (loadedProfile == null) {
      final newProfile = UserProfile(
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
      );

      await UserProfileStorage.save(newProfile);

      if (!mounted) return;

      setState(() {
        profile = newProfile;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil creado. Puedes editarlo cuando quieras.')),
      );

      return;
    }

    setState(() {
      profile = loadedProfile;
    });
  }

  void _onInternalTabTapped(int index) async {
    if (index == 2) {
      final newRecipe = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CreateRecipePage()),
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

    if (!mounted) return;

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

    Widget bodyContent;
    PreferredSizeWidget? appBar;
    Widget? drawer;

    if (_internalTabIndex == 0) {
      // Perfil con AppBar y Drawer
      appBar = AppBar(
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
      );
      drawer = MainDrawer(
        selectedIndex: _drawerSelectedIndex,
        navigateSafely: widget.navigateSafely,
      );
      bodyContent = profile == null
          ? const Center(child: CircularProgressIndicator())
          : ProfileContent(profile: profile!);
    } else if (_internalTabIndex == 1) {
      // Mis Recetas sin AppBar ni Drawer
      appBar = null;
      drawer = null;
      bodyContent = MyLibraryPage(
        key: _libraryKey,
        onRecipeEditedOrSaved: () {
          _libraryKey.currentState?.reloadRecipes();
        },
        onBack: () {
          setState(() {
            _internalTabIndex = 0;
          });
        },
      );
    } else {
      // Crear Receta sin AppBar ni Drawer
      appBar = null;
      drawer = null;
      bodyContent = Container();
    }

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: bodyContent,
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
