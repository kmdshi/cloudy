import 'package:cryptome/features/registration/widgets/registation_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CryptomeRouter {
  CryptomeRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/start',
        builder: (context, state) => const RegistationScreen(),
      ),
    ],
  );
}
