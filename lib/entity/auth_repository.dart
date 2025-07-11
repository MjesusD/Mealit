import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyPassword = 'password'; // nunca almacenes contraseñas en texto plano

  final SharedPreferences prefs;

  AuthRepository(this.prefs);

  Future<bool> login(String username, String email, String password) async {
    try {
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUsername, username);
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyPassword, password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await prefs.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isLoggedIn() {
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getUsername() {
    return prefs.getString(_keyUsername);
  }

  String? getEmail() {
    return prefs.getString(_keyEmail);
  }

  // Método para verificar credenciales (útil si implementas login posteriormente)
  bool verifyCredentials(String email, String password) {
    final storedEmail = prefs.getString(_keyEmail);
    final storedPassword = prefs.getString(_keyPassword);
    return storedEmail == email && storedPassword == password;
  }
}