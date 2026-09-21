import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../business/providers/auth_provider.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(authProvider.notifier).checkAuthStatus();

      if (!mounted) return;
      final authState = ref.read(authProvider);

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      if (authState.user != null) {
        Navigator.pushReplacementNamed(context, AppRouter.shell);
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.signIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.deepInk, Color(0xFF0D1430), AppColors.deepInk],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [AppColors.mutedPurple, AppColors.subtleCyan],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricViolet.withValues(alpha: .35),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                size: 56,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text('DOCMIND', style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Text('The AI Study Companion', style: AppTextStyles.body),
            const Spacer(),
            PrimaryButton(
              label: 'Get Started',
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRouter.signIn);
              },
            ),
            const SizedBox(height: 14),
            Text(
              'Already have an account? Log in',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
