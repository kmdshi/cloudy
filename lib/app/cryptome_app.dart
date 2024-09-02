import 'package:cryptome/core/DI/dependency_config.dart';
import 'package:cryptome/core/router/cryptome_router.dart';
import 'package:cryptome/core/theme/app_theme.dart';
import 'package:cryptome/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptomeApp extends StatelessWidget {
  const CryptomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<RegistrationBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: TCiphermeTheme.lightTheme,
        routerConfig: TCryptomeRouter.router,
      ),
    );
  }
}
