import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/firebase_auth_service.dart';
import '../../core/services/local_storage_service.dart';
import '../models/app_user_model.dart';

class AuthRepository {
  final FirebaseAuthService authService;
  final LocalStorageService localStorageService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepository({
    required this.authService,
    required this.localStorageService,
  });

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<AppUserModel> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final authUser = await authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      final now = DateTime.now();
      final subscriptionEnds = now.add(const Duration(days: 7));

      final userModel = AppUserModel(
        id: authUser.id,
        email: authUser.email,
        name: authUser.name,
        membership: MembershipPlan.student,
        subscriptionEnds: subscriptionEnds,
        dailyAiUsage: 0,
        lastReset: now,
      );

      await _users.doc(authUser.id).set(userModel.toMap());

      await localStorageService.saveUser(
        id: userModel.id,
        email: userModel.email,
        name: userModel.name,
      );

      return userModel;
    } catch (e) {
      throw Exception('Signup profile creation failed: $e');
    }
  }

  Future<AppUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authUser = await authService.signIn(
        email: email,
        password: password,
      );

      final doc = await _users.doc(authUser.id).get();

      if (doc.exists && doc.data() != null) {
        final user = AppUserModel.fromMap(doc.data()!);

        await localStorageService.saveUser(
          id: user.id,
          email: user.email,
          name: user.name,
        );

        return user;
      }

      // If user exists in Firebase Auth but not Firestore, create record now
      final now = DateTime.now();
      final fallbackUser = AppUserModel(
        id: authUser.id,
        email: authUser.email,
        name: authUser.name,
        membership: MembershipPlan.student,
        subscriptionEnds: now.add(const Duration(days: 7)),
        dailyAiUsage: 0,
        lastReset: now,
      );

      await _users.doc(authUser.id).set(fallbackUser.toMap());

      await localStorageService.saveUser(
        id: fallbackUser.id,
        email: fallbackUser.email,
        name: fallbackUser.name,
      );

      return fallbackUser;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<AppUserModel?> getCurrentUser() async {
    final authUser = authService.currentUser;
    if (authUser == null) return null;

    try {
      final doc = await _users.doc(authUser.id).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return AppUserModel.fromMap(doc.data()!);
    } catch (_) {
      return null;
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    await localStorageService.clearUser();
  }

  Future<void> forgotPassword(String email) async {
    await authService.sendPasswordResetEmail(email);
  }

  Future<void> incrementUsage(String userId) async {
    await _users.doc(userId).update({
      'dailyAiUsage': FieldValue.increment(1),
    });
  }

  Future<void> updateMembership({
    required String userId,
    required MembershipPlan plan,
    required DateTime subscriptionEnds,
  }) async {
    await _users.doc(userId).update({
      'membership': plan.value,
      'subscriptionEnds': Timestamp.fromDate(subscriptionEnds),
    });
  }
}