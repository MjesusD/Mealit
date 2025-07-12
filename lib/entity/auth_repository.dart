import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyPassword = 'password'; // no seguro almacenar contraseña en texto plano

  final SharedPreferences prefs;

  AuthRepository(this.prefs);

  Future<bool> register(String username, String email, String password) async {
    try {
      await prefs.setString(_keyUsername, username);
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyPassword, password);
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    final storedEmail = prefs.getString(_keyEmail);
    final storedPassword = prefs.getString(_keyPassword);
    if (storedEmail == email && storedPassword == password) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    return false;
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

  Future<bool> setUsername(String username) async {
    try {
      await prefs.setString(_keyUsername, username);
      return true;
    } catch (e) {
      return false;
    }
  }
}
