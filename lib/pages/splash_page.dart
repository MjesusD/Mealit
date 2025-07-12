import 'package:flutter/material.dart';
import 'package:mealit/services/connectivity_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();
    // Obtén estado inicial de conexión
    _hasConnection = ConnectivityService.instance.hasConnection;

    // Escucha cambios en la conexión para actualizar UI
    ConnectivityService.instance.connectionChange.listen((connected) {
      if (!mounted) return;
      setState(() {
        _hasConnection = connected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/splash2_logo.png', width: 250, height: 250),
            const SizedBox(height: 24),
            if (!_hasConnection)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Sin conexión a internet',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
