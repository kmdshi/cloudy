import 'dart:convert';

import 'package:cloudy/core/DI/dependency_config.dart';
import 'package:cloudy/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cloudy/features/messaging/presentation/widgets/communication_screen.dart';
import 'package:cloudy/features/registration/domain/entities/person_entity.dart';
import 'package:cloudy/features/registration/presentation/widgets/onboarding_screen.dart';
import 'package:cloudy/features/registration/presentation/widgets/registration_screen.dart';
import 'package:cloudy/features/registration/presentation/widgets/restore_screen.dart';
import 'package:cloudy/features/registration/presentation/widgets/verefication_screen.dart';
import 'package:cloudy/features/registration/presentation/widgets/verify_sucess_screen.dart';
import 'package:cloudy/features/settings/presentation/widgets/about_screen.dart';
import 'package:cloudy/features/settings/presentation/widgets/cipher_screen.dart';
import 'package:cloudy/features/settings/presentation/widgets/settings_screen.dart';
import 'package:cloudy/core/presentation/general_screen.dart';
import 'package:cloudy/core/presentation/import_adress_screen.dart';
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
              path: 'import/:AID',
              builder: (context, state) {
                final String AID = state.pathParameters['AID']!;
                return ImportAddressScreen(isFromSettings: false, AID: AID);
              }),
          GoRoute(
            path: 'communication',
            builder: (context, state) {
              final data = state.extra as InitialDataValueEntity;
              return CommunicationScreen(initialDataValueEntity: data);
            },
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) {
              return const SettingsScreen();
            },
            routes: [
              GoRoute(
                  path: 'import/:AID',
                  builder: (context, state) {
                    final String AID = state.pathParameters['AID']!;
                    return ImportAddressScreen(isFromSettings: true, AID: AID);
                  }),
              GoRoute(
                path: 'cipher',
                builder: (context, state) => const CipherScreen(),
              ),
              GoRoute(
                path: 'about',
                builder: (context, state) => const AboutScreen(),
              ),
            ],
          )
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
