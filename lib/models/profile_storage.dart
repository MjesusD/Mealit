import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mealit/entity/user_profile.dart';
import '../entity/auth_repository.dart';


class UserProfileStorage {
  static const _key = 'user_profile';

  static Future<UserProfile?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return UserProfile.fromJson(jsonMap);
  }

  
  static Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final authRepo = AuthRepository(prefs);
    
    // Obtiene el nombre de usuario actual del login
    final currentUsername = authRepo.getUsername();
    
    final updatedProfile = profile.copyWith(
      name: currentUsername ?? profile.name,
    );
    
    final jsonString = jsonEncode(updatedProfile.toJson());
    await prefs.setString(_key, jsonString);
  }
}
