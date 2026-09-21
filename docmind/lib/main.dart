import 'dart:io';

import 'package:docmind/app/docmind_app.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'util.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Activate App Check with the debug provider

  // await _setupAppCheck();
  runApp(ProviderScope(child: const DocMindApp()));
}

Future<void> _setupAppCheck() async {
  // For Phase 1 dev/testing:
  // Android -> debug provider
  // Apple   -> debug provider
  // Web     -> recaptcha if needed later
  //
  // Windows desktop does not use Android/Apple attestation providers.
  // We guard by platform and avoid crashing there.
  try {
    if (Platform.isAndroid) {
      await FirebaseAppCheck.instance.activate(
        // providerAndroid: AndroidDebugProvider(
        //   debugToken: 'ANDROID_DEBUG_TOKEN',
        // ),
        androidProvider: AndroidProvider.debug,
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      await FirebaseAppCheck.instance.activate(
        // providerApple: AppleDebugProvider(debugToken: 'APPLE_DEBUG_TOKEN'),
        appleProvider: AppleProvider.debug,
      );
    } else if (Platform.isWindows) {
      String windowsDebugToken = dotenv.env['APP_CHECK_DEBUG_TOKEN'] ?? '';
      // String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');
      await FirebaseAppCheck.instance.activate(
        providerWindows: WindowsDebugProvider(debugToken: windowsDebugToken),
      );
      debugPrint('Windows debug token: $windowsDebugToken');
    } else {
      // No mobile attestation provider to activate here.
      // For Phase 1, allow app to run without calling activate on unsupported desktop targets.
      debugPrint('App Check activate skipped for this desktop platform.');
    }

    // Optional: force token fetch once to surface config issues early
    // final token = await FirebaseAppCheck.instance.getToken(true);
    // debugPrint('App Check token fetched: ${token != null ? "yes" : "no"}');
  } catch (e) {
    debugPrint('App Check setup failed: $e');
  }
}
