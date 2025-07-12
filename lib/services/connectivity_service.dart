import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionChangeController = StreamController<bool>.broadcast();

  bool _hasConnection = true;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityService._internal();

  static ConnectivityService get instance => _instance;

  Stream<bool> get connectionChange => _connectionChangeController.stream;

  bool get hasConnection => _hasConnection;

  Future<void> initialize() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);

    // Cancelar si ya hay una suscripción previa (para evitar múltiples)
    await _subscription?.cancel();

    _subscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        _updateConnectionStatus(result);
      },
      onError: (error) {
        // Opcional: loguear error
      },
    );
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final connected = result != ConnectivityResult.none;
    if (_hasConnection != connected) {
      _hasConnection = connected;
      _connectionChangeController.add(_hasConnection);
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectionChangeController.close();
  }
}
