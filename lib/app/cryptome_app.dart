import 'package:cryptome/core/router/cryptome_router.dart';
import 'package:cryptome/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CryptomeApp extends StatelessWidget {
  const CryptomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: TCiphermeTheme.lightTheme,
      routerConfig: TCryptomeRouter.router,
    );
  }
}
