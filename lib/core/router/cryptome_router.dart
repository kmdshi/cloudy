import 'package:cryptome/features/authentication/domain/entities/person_entity.dart';
import 'package:cryptome/features/authentication/presentation/widgets/onboarding_screen.dart';
import 'package:cryptome/features/authentication/presentation/widgets/registration_screen.dart';
import 'package:cryptome/features/authentication/presentation/widgets/restore_screen.dart';
import 'package:cryptome/features/authentication/presentation/widgets/verefication_screen.dart';
import 'package:cryptome/features/authentication/presentation/widgets/verify_sucess_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TCryptomeRouter {
  TCryptomeRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/start',
    routes: [
      GoRoute(
        path: '/start',
        builder: (context, state) => const OnboardingScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const RegistationScreen(),
            routes: [
              GoRoute(
                path: 'verif',
                builder: (context, state) {
                  final data = state.extra as PersonEntity?;
                  if (data == null) {
                    return throw ('no person, route error');
                  }
                  return VereficationScreen(person: data);
                },
                routes: [
                  GoRoute(
                    path: 'success',
                    builder: (context, state) => const VerifySuccessScreen(),
                  ),
                ],
              )
            ],
          ),
          GoRoute(
            path: 'restore',
            builder: (context, state) => const RestoreScreen(),
          )
        ],
      ),
    ],
  );
}
