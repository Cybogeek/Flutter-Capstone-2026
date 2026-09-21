import 'package:docmind/app/app_router.dart';
import 'package:docmind/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DocMindApp extends StatelessWidget {
  const DocMindApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOCMIND',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
