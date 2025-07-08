import 'package:Mealit/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/home.dart';
import 'package:logger/logger.dart';
import '../themes/theme.dart';
import '../themes/util.dart';
import 'entidades/profile_notifier.dart';

final logger = Logger();

void main() {
  // Configuración inicial de logger
  logger.i('La app MealIt se está iniciando');

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProfileNotifier())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  /*Widget build(BuildContext context) {
    logger.i('Construyendo MyApp widget');
    return MaterialApp(
      title: 'MealIt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(title: 'MEALIT'),
      debugShowCheckedModeBanner: false,
    );
  }*/
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Gochi Hand");
    MaterialTheme theme = MaterialTheme(textTheme);
    //MaterialTheme theme = MaterialTheme(texTheme);
    return MaterialApp(
      title: 'MEALIT',
      theme:
          brightness == Brightness.light
              ? theme.light()
              : theme.dark(), //cambia el tema de acrde al modo del selu
      //home: const SplashPref(title: 'MEALIT'),
      home: HomePage(title: 'MEALIT'),
    );
  }
}
