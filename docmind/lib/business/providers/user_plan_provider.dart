import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/app_user_model.dart';
import 'auth_provider.dart';

final userPlanProvider = FutureProvider<AppUserModel?>((ref) async {
  final repository = ref.read(authRepositoryProvider);
  return repository.getCurrentUser();
});
