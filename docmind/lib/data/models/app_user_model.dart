import 'package:cloud_firestore/cloud_firestore.dart';

enum MembershipPlan {
  free,
  student,
  pro,
}

extension MembershipPlanX on MembershipPlan {
  static MembershipPlan fromString(String value) {
    switch (value) {
      case 'student':
        return MembershipPlan.student;
      case 'pro':
        return MembershipPlan.pro;
      default:
        return MembershipPlan.free;
    }
  }

  String get value {
    switch (this) {
      case MembershipPlan.free:
        return 'free';
      case MembershipPlan.student:
        return 'student';
      case MembershipPlan.pro:
        return 'pro';
    }
  }
}

class AppUserModel {
  final String id;
  final String email;
  final String? name;
  final MembershipPlan membership;
  final DateTime subscriptionEnds;
  final int dailyAiUsage;
  final DateTime lastReset;

  const AppUserModel({
    required this.id,
    required this.email,
    this.name,
    required this.membership,
    required this.subscriptionEnds,
    required this.dailyAiUsage,
    required this.lastReset,
  });

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    final subscriptionTs = map['subscriptionEnds'];
    final lastResetTs = map['lastReset'];

    return AppUserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      membership: MembershipPlanX.fromString(map['membership'] ?? 'free'),
      subscriptionEnds: subscriptionTs is Timestamp
          ? subscriptionTs.toDate()
          : DateTime.now().add(const Duration(days: 7)),
      dailyAiUsage: map['dailyAiUsage'] ?? 0,
      lastReset: lastResetTs is Timestamp
          ? lastResetTs.toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'membership': membership.value,
      'subscriptionEnds': Timestamp.fromDate(subscriptionEnds),
      'dailyAiUsage': dailyAiUsage,
      'lastReset': Timestamp.fromDate(lastReset),
    };
  }

  AppUserModel copyWith({
    String? id,
    String? email,
    String? name,
    MembershipPlan? membership,
    DateTime? subscriptionEnds,
    int? dailyAiUsage,
    DateTime? lastReset,
  }) {
    return AppUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      membership: membership ?? this.membership,
      subscriptionEnds: subscriptionEnds ?? this.subscriptionEnds,
      dailyAiUsage: dailyAiUsage ?? this.dailyAiUsage,
      lastReset: lastReset ?? this.lastReset,
    );
  }
}