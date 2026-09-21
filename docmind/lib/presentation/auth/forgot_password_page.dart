import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../business/providers/auth_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/page_background.dart';
import '../../core/widgets/primary_button.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final emailError = Validators.validateEmail(emailController.text);
    if (emailError != null) return _showMessage(emailError);

    await ref
        .read(authProvider.notifier)
        .forgotPassword(emailController.text.trim());

    final state = ref.read(authProvider);
    if (state.errorMessage != null) {
      _showMessage(state.errorMessage!);
    } else {
      _showMessage('Password reset email sent successfully');
      if (mounted) Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.midnight,
        content: Text(message.replaceAll('Exception: ', '')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: PageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: AuthHeader(
                    title: 'Forgot Password',
                    subtitle: 'Enter your email and we’ll send a reset link',
                  ),
                ),
                const SizedBox(height: 36),
                Text('Email', style: AppTextStyles.caption),
                const SizedBox(height: 8),
                AppTextField(
                  controller: emailController,
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Send Reset Link',
                  isLoading: authState.isLoading,
                  onTap: authState.isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
