import 'package:firebase_auth/firebase_auth.dart';

class AuthUserData {
  final String id;
  final String email;
  final String? name;

  const AuthUserData({
    required this.id,
    required this.email,
    this.name,
  });
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthUserData? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;

    return AuthUserData(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
    );
  }

  Future<AuthUserData> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (name != null && name.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Failed to create account');
    }

    return AuthUserData(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? name,
    );
  }

  Future<AuthUserData> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw Exception('Sign in failed');
    }

    return AuthUserData(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}