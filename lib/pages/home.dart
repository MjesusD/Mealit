import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_model.dart';
import '../entidades/menu_lateral.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  Meal? meal;
  bool isLoading = false;
  String? error;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  Future<void> loadMeal() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    final data = await apiService.fetchRandomMeal();
    if (data != null) {
      setState(() {
        meal = Meal.fromJson(data);
        isLoading = false;
      });
    } else {
      setState(() {
        error = 'Error al cargar la comida.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: obtenerMenuLateral(context),
      appBar: AppBar(title: const Text('MealIt - Comida del Día')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : error != null
                ? Text(error!)
                : meal == null
                    ? const Text('No hay datos')
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    meal!.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  meal!.name,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const Text(
                                  'Ingredientes:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...meal!.ingredients.map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text('• $e'),
                                    )),
                                const SizedBox(height: 16),
                                const Divider(),
                                const Text(
                                  'Instrucciones:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  meal!.instructions,
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 20),


                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // Esto hace que el Row ocupe solo el espacio necesario
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: loadMeal,
                                        child: const Text('Otra comida'),
                                      ),
                                      const SizedBox(width: 16), // Espacio entre los botones
                                       Material(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(8),
                                        elevation: 2,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(8),
                                          onTap: () {
                                            setState(() {
                                              // Tu lógica para favoritos aquí
                                            });
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.favorite, // O Icons.favorite_border para el estado no seleccionado
                                              size: 20,
                                              color: Colors.red, // Color personalizado
                                            ),
                                          ),
                                        ),
                                      ),

                                    /*IconButton(
                                      onPressed: () {
                                        // lógica de agregar a favoritos
                                      }, 
                                      icon: const Icon(
                                        Icons.favorite, 
                                        size: 28, // Aumenté el tamaño para que sea más visible
                                        color: Color.fromARGB(255, 204, 1, 1),
                                      ),
                                    ),*/
                                    
                                  ],
                                ),
                              ),
                              ],
                            ),
                          ),
                        ),
                      ),
        ),
      );
    }
  }
