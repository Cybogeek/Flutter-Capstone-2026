import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../business/providers/auth_provider.dart';
import '../../business/providers/nav_provider.dart';
import '../ask_doc/ask_doc_page.dart';
import '../library/library_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'widgets/app_bottom_nav_bar.dart';

class MainShellPage extends ConsumerWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navProvider);
    final authState = ref.watch(authProvider);

    final pages = [
      const HomePage(),
      const LibraryPage(),
      const AskDocPage(),
      const ProfilePage(),
    ];

    return PopScope(
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (authState.user == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.signIn,
            (_) => false,
          );
          return;
        }

        if (index != 0) {
          ref.read(navProvider.notifier).setNavIndex(0);
        }
      },
      child: Scaffold(
        body: pages[index],
        bottomNavigationBar: const AppBottomNavBar(),
      ),
    );
  }
}
