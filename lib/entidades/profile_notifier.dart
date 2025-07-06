import 'package:flutter/material.dart';

class ProfileNotifier extends ChangeNotifier {
  void refreshProfile() {
    notifyListeners(); // Notifica a los listeners que los datos del perfil cambiaron
  }
}