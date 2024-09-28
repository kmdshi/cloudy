import 'dart:convert';

import 'package:cryptome/core/DI/dependency_config.dart';
import 'package:cryptome/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cryptome/features/messaging/presentation/widgets/communication_screen.dart';
import 'package:cryptome/features/user_data/presentation/widgets/general_screen.dart';
import 'package:cryptome/features/user_data/presentation/widgets/import_adress_screen.dart';
import 'package:cryptome/features/registration/domain/entities/person_entity.dart';
import 'package:cryptome/features/registration/presentation/widgets/onboarding_screen.dart';
import 'package:cryptome/features/registration/presentation/widgets/registration_screen.dart';
import 'package:cryptome/features/registration/presentation/widgets/restore_screen.dart';
import 'package:cryptome/features/registration/presentation/widgets/verefication_screen.dart';
import 'package:cryptome/features/registration/presentation/widgets/verify_sucess_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TCryptomeRouter {
  TCryptomeRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/verification',
    routes: [
      GoRoute(
        path: '/verification',
        redirect: (context, state) {
          return handleRedirect();
        },
      ),
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
      GoRoute(
        path: '/messages',
        builder: (context, state) => const GeneralScreen(),
        routes: [
          GoRoute(
            path: 'import',
            builder: (context, state) => const ImportAddressScreen(),
          ),
          GoRoute(
              path: 'communication',
              builder: (context, state) {
                final data = state.extra as InitialDataValueEntity;
                return CommunicationScreen(initialDataValueEntity: data);
              }),
        ],
      )
    ],
  );
}

String? handleRedirect() {
  final prefs = getIt<SharedPreferences>();
  var sessionInformation = prefs.getString('session_information');

  if (sessionInformation == null) {
    return '/start';
  }

  final sessionData = jsonDecode(sessionInformation);
  bool isLoggined = sessionData['is_loggined'] ?? false;
  if (isLoggined) {
    return '/messages';
  }
  return null;
}
