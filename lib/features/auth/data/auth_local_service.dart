import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_model.dart';


class AuthLocalService {

  static const String _keyAdminJson = 'logged_in_admin';
  static const String _keyIsLoggedIn = 'is_logged_in';

  Future<void> saveSession(AdminModel admin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyAdminJson, jsonEncode(admin.toJsonLocal()));
  }


  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<AdminModel?> getSavedAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyAdminJson);
    if (json == null) return null;

    try {
      return AdminModel.fromMap(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      await clearSession();
      return null;
    }
  }


  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyAdminJson);
  }
}
