import 'package:flutter/material.dart';
import 'package:mealit/pages/home.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() {
  // Configuración inicial de logger 
  logger.i('La app MealIt se está iniciando');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i('Construyendo MyApp widget');
    return MaterialApp(
      title: 'MealIt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
