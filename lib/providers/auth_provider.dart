// lib/providers/auth_provider.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._service);

  final AuthService _service;

  models.User? user;
  bool initializing = true; // true until we know if a session exists
  bool busy = false; // true while a sign-in/sign-up request is running
  String? error;

  /// Called once at startup: restores the session stored by the SDK.
  Future<void> init() async {
    user = await _service.currentUser();
    initializing = false;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) =>
      _run(() async => user = await _service.signIn(email, password));

  Future<bool> signUp(String name, String email, String password) =>
      _run(() async => user = await _service.signUp(name, email, password));

  Future<void> signOut() async {
    await _service.signOut();
    user = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AppwriteException catch (e) {
      error = e.message ?? 'Something went wrong';
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}