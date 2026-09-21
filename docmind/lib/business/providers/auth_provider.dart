import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../business/states/auth_state.dart';
import '../../data/repositories/auth_repository.dart';
import 'app_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: ref.read(firebaseAuthServiceProvider),
    localStorageService: ref.read(localStorageServiceProvider),
  );
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository repository;

  AuthNotifier();

  Future<void> checkAuthStatus() async {
    try {
      final currentUser = await repository.getCurrentUser();
      if (currentUser != null) {
        state = state.copyWith(
          user: currentUser,
          isSuccess: true,
          isLoading: false,
          errorMessage: null,
        );
      }
    } catch (_) {}
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
      );

      final user = await repository.signIn(email: email, password: password);

      state = state.copyWith(
        isLoading: false,
        user: user,
        isSuccess: true,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
      );

      final user = await repository.signUp(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        user: user,
        isSuccess: true,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        isSuccess: false,
      );

      await repository.forgotPassword(email);

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
    state = AuthState.initial();
  }

  @override
  AuthState build() {
    repository = ref.read(authRepositoryProvider);
    return AuthState.initial();
  }
}
