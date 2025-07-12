import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mealit/entity/user_profile.dart';
import '../entity/auth_repository.dart';

class UserProfileStorage {
  static const _key = 'user_profile';

  static Future<UserProfile?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);
      if (jsonString == null) return null;
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserProfile.fromJson(jsonMap);
    } catch (_) {
      // Manejo básico: si falla, retorna null
      return null;
    }
  }

  static Future<void> save(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authRepo = AuthRepository(prefs);
      
      final currentUsername = authRepo.getUsername();
      
      final updatedProfile = profile.copyWith(
        name: (currentUsername != null && currentUsername.isNotEmpty) 
            ? currentUsername 
            : profile.name,
      );
      
      final jsonString = jsonEncode(updatedProfile.toJson());
      await prefs.setString(_key, jsonString);
    } catch (_) {
      // agregar logger 
    }
  }
}
