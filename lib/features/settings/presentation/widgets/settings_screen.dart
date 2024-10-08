import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:cloudy/features/settings/presentation/widgets/header_widget.dart';
import 'package:cloudy/features/settings/presentation/widgets/settings_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    context.read<SettingsBloc>().add(GetInitialUserData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Assets.icons.arrowIcon.image(),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is CustomSettingsFailures) {
            context.read<SettingsBloc>().add(GetInitialUserData());
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoaded) {
              final user = state.userData;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    HeaderWidget(
                      avatarUrl: user.avatarUrl,
                      nickname: user.nickname,
                      AID: user.userAID,
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: SettingsOptionsWidget(
                        AID: user.userAID,
                        urlStatus: user.urlStatus,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is SettingsFailure) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
