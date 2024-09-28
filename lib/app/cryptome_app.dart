import 'package:cryptome/core/DI/dependency_config.dart';
import 'package:cryptome/core/router/cryptome_router.dart';
import 'package:cryptome/core/services/deeplink_handler.dart';
import 'package:cryptome/core/theme/app_theme.dart';
import 'package:cryptome/features/messaging/presentation/bloc/messaging_bloc.dart';
import 'package:cryptome/features/user_data/presentation/bloc/messaging_bloc.dart';
import 'package:cryptome/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptomeApp extends StatefulWidget {
  const CryptomeApp({super.key});

  @override
  _CryptomeAppState createState() => _CryptomeAppState();
}

class _CryptomeAppState extends State<CryptomeApp> {
  final DeepLinkHandlerService _deepLinkHandler =
      getIt<DeepLinkHandlerService>();

  @override
  void initState() {
    super.initState();
    _deepLinkHandler.startListening();
  }

  // @override
  // void dispose() {
  //   _deepLinkHandler.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<RegistrationBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<UserDataBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<MessagingBloc>(),
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: TCiphermeTheme.lightTheme,
        routerConfig: TCryptomeRouter.router,
      ),
    );
  }
}
