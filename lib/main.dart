import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mealit/pages/home.dart';
import 'package:mealit/pages/profile_page.dart';
import 'package:mealit/pages/user_preferences_page.dart';
import 'package:mealit/pages/favorites.dart';
import 'package:mealit/pages/splash_page.dart';
import 'package:mealit/pages/login.dart';
import 'package:mealit/pages/offline_page.dart';
import 'package:mealit/pages/about.dart';
import 'package:mealit/themes/theme.dart';
import 'package:mealit/utils/util.dart';
import 'package:mealit/services/connectivity_service.dart';
import 'package:mealit/entity/auth_repository.dart';


final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final authRepository = AuthRepository(prefs);

  await ConnectivityService.instance.initialize();

  runApp(MyApp(
    authRepository: authRepository,
    scaffoldMessengerKey: scaffoldMessengerKey,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.scaffoldMessengerKey,
  });

  Future<void> navigateSafely(BuildContext context, String route) async {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == route) return;

    final hasConnection = ConnectivityService.instance.hasConnection;

    if (!hasConnection) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(
            'No hay conexión a internet. La navegación está permitida, pero el contenido podría no cargarse.',
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }

    final mainRoutes = {'/home', '/login', '/offline', '/'};
    final currentState = navigatorKey.currentState;
    if (currentState == null) return;

    if (mainRoutes.contains(route)) {
      if (currentState.canPop()) {
        await currentState.pushReplacementNamed(route);
      } else {
        await currentState.pushNamedAndRemoveUntil(route, (route) => false);
      }
    } else {
      await currentState.pushNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, 'Roboto', 'Rubik');
    final customTheme = MaterialTheme(textTheme).light();

    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'MealIt',
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashWrapper(
              authRepository: authRepository,
              navigateSafely: navigateSafely,
            ),
        '/login': (context) => LoginScreen(
              authRepository: authRepository,
              navigateSafely: navigateSafely,
            ),
        '/home': (context) => HomePage(navigateSafely: navigateSafely),
        '/favorites': (context) => FavoritesPage(navigateSafely: navigateSafely),
        '/profile': (context) => ProfilePage(title: 'Perfil',navigateSafely: navigateSafely,),
        '/preferences': (context) => PreferencesPage(navigateSafely: navigateSafely),
        '/about': (context) => AboutPage(navigateSafely: navigateSafely),
        '/offline': (context) => const OfflinePage(),
      },
    );
  }
}

class SplashWrapper extends StatefulWidget {
  final AuthRepository authRepository;
  final Future<void> Function(BuildContext, String) navigateSafely;

  const SplashWrapper({
    super.key,
    required this.authRepository,
    required this.navigateSafely,
  });

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _navigated = false;
  late StreamSubscription<bool> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

    _connectivitySubscription = ConnectivityService.instance.connectionChange.listen((connected) {
      final currentContext = navigatorKey.currentContext;
      if (connected && currentContext != null && mounted) {
        scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;

          try {
            final currentRoute = ModalRoute.of(currentContext)?.settings.name;
            if (currentRoute == '/offline') {
              final isLoggedIn = widget.authRepository.isLoggedIn();
              final target = isLoggedIn ? '/home' : '/login';
              await widget.navigateSafely(currentContext, target);
            }
          } catch (e) {
            debugPrint('Error al manejar reconexión: $e');
          }
        });
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted || _navigated) return;

    final isLoggedIn = widget.authRepository.isLoggedIn();
    _navigated = true;
    if (!mounted) return;

    await widget.navigateSafely(context, isLoggedIn ? '/home' : '/login');
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}
