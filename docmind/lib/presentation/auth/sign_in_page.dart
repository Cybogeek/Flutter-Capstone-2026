import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../business/providers/auth_provider.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/page_background.dart';
import '../../core/widgets/primary_button.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final emailError = Validators.validateEmail(emailController.text);
    final passwordError = Validators.validatePassword(passwordController.text);

    if (emailError != null) return _showMessage(emailError);
    if (passwordError != null) return _showMessage(passwordError);

    await ref
        .read(authProvider.notifier)
        .signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    final state = ref.read(authProvider);
    if (state.user != null && mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.shell);
    } else if (state.errorMessage != null) {
      _showMessage(state.errorMessage!);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.midnight,
        content: Text(
          message.replaceAll('Exception: ', ''),
          style: AppTextStyles.body.copyWith(color: AppColors.error),
        ),
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 40,
              ),
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
                    child: Column(
                      children: [
                        AuthHeader(
                          title: 'Welcome Back',
                          subtitle: 'Sign in to continue reading smarter with DOCMIND',
                        ),
                      ],
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
                  const SizedBox(height: 18),
                  Text('Password', style: AppTextStyles.caption),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: passwordController,
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: obscure,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscure = !obscure),
                      icon: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.lavender,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.forgotPassword);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.subtleCyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: 'Sign In',
                    isLoading: authState.isLoading,
                    onTap: authState.isLoading ? null : _submit,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Wrap(
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: AppTextStyles.body,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouter.signUp);
                          },
                          child: Text(
                            'Sign Up',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.subtleCyan,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
