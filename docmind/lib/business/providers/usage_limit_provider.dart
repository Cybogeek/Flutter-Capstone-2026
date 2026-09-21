import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/app_user_model.dart';
import 'user_plan_provider.dart';

class UsageLimitInfo {
  final AppUserModel? user;
  final int dailyLimit;
  final int usageCount;
  final bool hasLimitReached;
  final bool isSubscriptionActive;

  const UsageLimitInfo({
    required this.user,
    required this.dailyLimit,
    required this.usageCount,
    required this.hasLimitReached,
    required this.isSubscriptionActive,
  });
}

final usageLimitProvider = Provider<AsyncValue<UsageLimitInfo>>((ref) {
  final userAsync = ref.watch(userPlanProvider);

  return userAsync.whenData((user) {
    int limit = 3;

    switch (user?.membership) {
      case MembershipPlan.student:
        limit = 30;
        break;
      case MembershipPlan.pro:
        limit = 100;
        break;
      case MembershipPlan.free:
      default:
        limit = 3;
    }

    final usage = user?.dailyAiUsage ?? 0;
    final active = user?.subscriptionEnds.isAfter(DateTime.now()) ?? false;

    return UsageLimitInfo(
      user: user,
      dailyLimit: limit,
      usageCount: usage,
      hasLimitReached: usage >= limit,
      isSubscriptionActive: active,
    );
  });
});
