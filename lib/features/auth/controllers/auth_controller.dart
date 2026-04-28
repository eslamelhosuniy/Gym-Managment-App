import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:gym_management_app/core/constants/app_strings.dart';
import 'package:gym_management_app/core/network/db_connection.dart';
import 'package:mongo_dart/mongo_dart.dart' show where;

import '../data/auth_local_service.dart';
import '../models/admin_model.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._localService);

  final AuthLocalService _localService;

  AdminModel? _admin;
  bool _isLoading = false;
  String? _errorMessage;

  AdminModel? get admin => _admin;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _admin != null;

  /// Called once at app startup to restore an existing session.
  ///
  /// If a session is found in local storage, the admin is set without
  /// requiring a new login.
  Future<void> tryRestoreSession() async {
    final saved = await _localService.getSavedAdmin();
    if (saved != null) {
      _admin = saved;
      notifyListeners();
    }
  }


  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final admin = await _verifyCredentials(
        email: email.trim().toLowerCase(),
        password: password,
      );

      if (admin == null) {
        _setError(AppStrings.invalidCredentials);
        return false;
      }

      // Persist session then update state
      await _localService.saveSession(admin);
      _admin = admin;
      notifyListeners();
      return true;
    } catch (e, st) {
      dev.log(
        'Login error',
        name: 'AuthController',
        error: e,
        stackTrace: st,
      );
      _setError(AppStrings.unexpectedError);
      return false;
    } finally {
      _setLoading(false);
    }
  }


  /// Clears the session both in memory and on disk.
  Future<void> logout() async {
    await _localService.clearSession();
    _admin = null;
    _clearError();
    notifyListeners();
  }


  Future<AdminModel?> _verifyCredentials({
    required String email,
    required String password,
  }) async {
    final collection = DbConnection.instance.db.collection('admins');
    final doc = await collection.findOne(where.eq('email', email));

    if (doc == null) return null;
    if (doc['password_hash'] != password) return null;

    return AdminModel.fromMap(doc);
  }


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
