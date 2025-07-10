import 'package:flutter/material.dart';
import 'package:mealit/pages/home.dart';
import 'package:mealit/pages/profile_page.dart';
import 'package:mealit/pages/user_preferences_page.dart';
import 'package:mealit/pages/favorites.dart';
import 'package:mealit/themes/theme.dart';
import 'package:mealit/utils/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(title: 'Perfil'),
        '/preferences': (context) => const PreferencesPage(),
        '/favorites': (context) => const FavoritesPage(),
      },
    );
  }
}
