import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/profile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';

class UserPreferences {
  static late UserType _userType;
  static late String _nombreUsuario;
  static String? _profileImagePath;
  static late Color _backgroundColor;
  static late double _fontSizeFactor;
  static late bool _isProfileImageRound;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedType = prefs.getString('userType');

    _userType =
        storedType != null
            ? UserType.values.firstWhere(
              (e) => e.toString() == storedType,
              orElse: () => UserType.comprador,
            )
            : UserType.comprador;
    _nombreUsuario = prefs.getString('username') ?? 'Camarada Anónimo';
    _profileImagePath = prefs.getString('profileImagePath');
    _backgroundColor = Color(
      prefs.getInt('backgroundColor') ?? 0xFFF5F5F5,
    ); // Color por defecto claro
    _fontSizeFactor = prefs.getDouble('fontSizeFactor') ?? 1.0;
    _isProfileImageRound = prefs.getBool('isProfileImageRound') ?? true;
  }

  //metodo para guardar los valores de las preferencias del usuario
  static Future<void> saveUserType(UserType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', type.toString());
    _userType = type;
  }

  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    _nombreUsuario = username;
  }

  static Future<void> saveProfileImage(String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    if (imagePath != null) {
      await prefs.setString(
        'profileImagePath',
        imagePath,
      ); // Guardar la ruta de la imagen de perfil
    } else {
      await prefs.remove(
        'profileImagePath',
      ); // Eliminar la ruta de la imagen de perfil si es nula
    }
    _profileImagePath = imagePath; // Actualizar la variable de instancia
  }

  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _userType = UserType.comprador; // Reiniciar al tipo de usuario por defecto
    _nombreUsuario =
        'Cocinero Anónimo'; // Reiniciar el nombre de usuario por defecto
    _profileImagePath = null; // Limpiar la ruta de la imagen de perfil
  }

  static Future<void> saveBackgroundColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('backgroundColor', color.value);
    _backgroundColor = color;
  }

  static Future<void> saveFontSizeFactor(double factor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizeFactor', factor);
    _fontSizeFactor = factor;
  }

  static Future<void> saveProfileImageShape(bool isRound) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isProfileImageRound', isRound);
    _isProfileImageRound = isRound;
  }

  // Métodos para obtener los valores guardados
  static UserType getUserType() {
    return _userType;
  }

  static String getUsername() {
    return _nombreUsuario;
  }

  static File? getProfileImage() {
    // Implementación para obtener la imagen de perfil
    // Aquí puedes usar SharedPreferences o cualquier otra forma de almacenamiento
    return _profileImagePath != null ? File(_profileImagePath!) : null;
  }

  static Color getBackgroundColor() {
    return _backgroundColor;
  }

  static double getFontSizeFactor() {
    return _fontSizeFactor;
  }

  static bool isProfileImageRound() {
    return _isProfileImageRound;
  }
}

class ImageStorageService {
  // Clase para manejar el almacenamiento de imágenes
  static Future<String> saveImageLocal(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await image.copy(imagePath);
      return imagePath;
    } catch (e) {
      debugPrint('Error al guardar imagen: $e');
      throw Exception('No se pudo guardar la imagen localmente');
    }
  }

  static Future<void> deleteImageLocal(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Error al eliminar imagen: $e');
    }
  }
}
