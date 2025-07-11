import 'package:flutter/material.dart';
import 'package:mealit/pages/home.dart';
import 'package:mealit/pages/profile_page.dart';
import 'package:mealit/pages/user_preferences_page.dart';
import 'package:mealit/pages/favorites.dart';
import 'package:mealit/pages/splash_page.dart';
import 'package:mealit/pages/login.dart';
import 'package:mealit/themes/theme.dart';
import 'package:mealit/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/auth_repository.dart'; // Añadido

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authRepository = AuthRepository(prefs);
  runApp(MyApp(authRepository: authRepository));
}


class MyApp extends StatelessWidget {
  final AuthRepository authRepository; // Añadido
  
  const MyApp({super.key, required this.authRepository}); // Modificado constructor

  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, 'Roboto', 'Rubik');
    final customTheme = MaterialTheme(textTheme).light();

    return MaterialApp(
      title: 'MealIt',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashWrapper(authRepository: authRepository), 
        '/login': (context) => const LoginScreen(), // Añadido / faltante
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(title: 'Perfil'),
        '/preferences': (context) => const PreferencesPage(),
        '/favorites': (context) => const FavoritesPage(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}

class SplashWrapper extends StatefulWidget {
  final AuthRepository authRepository;
  const SplashWrapper({super.key, required this.authRepository});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
     _navigateToHomeAfterDelay();
  }

  Future<void> _checkAuthStatus() async {
    // Esperar un breve tiempo para mostrar el splash
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final isLoggedIn = widget.authRepository.isLoggedIn();
    if (!_navigated) {
      setState(() => _navigated = true);
      Navigator.of(context).pushReplacementNamed(
        isLoggedIn ? '/home' : '/login',
      );
    }
  }

  void _navigateToHomeAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!_navigated && mounted) {
      _navigated = true;
      Navigator.of(context).pushReplacementNamed('/login'); // ← Siempre va a login
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}