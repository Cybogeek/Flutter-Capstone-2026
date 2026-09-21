import 'package:docmind/data/models/pdf_item_model.dart';
import 'package:flutter/material.dart';

import '../presentation/auth/forgot_password_page.dart';
import '../presentation/auth/sign_in_page.dart';
import '../presentation/auth/sign_up_page.dart';
import '../presentation/auth/splash_page.dart';
import '../presentation/home/main_shell_page.dart';
import '../presentation/reader/reader_page.dart';
import '../presentation/ask_doc/ask_doc_page.dart';
import '../presentation/settings/settings_page.dart';
import '../presentation/subscription/subscription_page.dart';
import '../presentation/about/about_page.dart';
import '../presentation/settings/bookmarks_page.dart';
import '../presentation/settings/playback_settings_page.dart';
import '../presentation/settings/reader_preferences_page.dart';

class AppRouter {
  static const splash = '/';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const shell = '/shell';
  static const reader = '/reader';
  static const askDoc = '/ask-doc';
  static const settings = '/settings';
  static const subscription = '/subscription';
  static const about = '/about';
  static const bookmarks = '/bookmarks';
  static const playbackSettings = '/playback-settings';
  static const readerPreferences = '/reader-preferences';

  static Route<dynamic> onGenerateRoute(RouteSettings rtSettings) {
    switch (rtSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case shell:
        return MaterialPageRoute(builder: (_) => const MainShellPage());
      case reader:
        final pdf = rtSettings.arguments as dynamic;
        return MaterialPageRoute(builder: (_) => ReaderPage(pdfItem: pdf));
      case askDoc:
        final pdf = rtSettings.arguments as PdfItemModel?;
        return MaterialPageRoute(builder: (_) => AskDocPage(pdfItem: pdf));
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case subscription:
        return MaterialPageRoute(builder: (_) => const SubscriptionPage());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case bookmarks:
        return MaterialPageRoute(builder: (_) => const BookmarksPage());
      case playbackSettings:
        return MaterialPageRoute(builder: (_) => const PlaybackSettingsPage());
      case readerPreferences:
        return MaterialPageRoute(builder: (_) => const ReaderPreferencesPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
