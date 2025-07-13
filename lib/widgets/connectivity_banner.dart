import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mealit/services/connectivity_service.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  bool _hasConnection = true;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();

    _hasConnection = ConnectivityService.instance.hasConnection;

    _subscription = ConnectivityService.instance.connectionChange.listen((connected) {
      if (!mounted) return;

      if (_hasConnection != connected) {
        // Para evitar setState dentro del frame actual
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _hasConnection = connected;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Opción para excluir splash y login (op)
  bool get _isExcludedPage {
    final runtimeTypeName = widget.child.runtimeType.toString();
    return runtimeTypeName.contains('Splash') || runtimeTypeName.contains('Login');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: (!_hasConnection && !_isExcludedPage)
                  ? Material(
                      key: const ValueKey('connectivityBanner'),
                      elevation: 6,
                      child: MaterialBanner(
                        backgroundColor: Colors.red.shade600,
                        content: const Text(
                          'Sin conexión a internet',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: const [], // Sin botones que puedan interferir
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    )
                  : const SizedBox(key: ValueKey('emptyBanner')),
            ),
          ),
        ),
      ],
    );
  }
}
