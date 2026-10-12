// lib/services/auth_service.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

import 'appwrite_client.dart';

class AuthService {
  /// Returns the logged-in user, or null when there is no valid session.
  Future<models.User?> currentUser() async {
    try {
      return await account.get();
    } on AppwriteException {
      return null;
    }
  }

  Future<models.User> signIn(String email, String password) async {
    await account.createEmailPasswordSession(email: email, password: password);
    return account.get();
  }

  Future<models.User> signUp(String name, String email, String password) async {
    await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
    // Creating an account does not open a session: sign in right after
    return signIn(email, password);
  }

  Future<void> signOut() async {
    await account.deleteSession(sessionId: 'current');
  }
}