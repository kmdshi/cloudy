import 'dart:async';

import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cloudy/features/user_data/domain/entities/user_entity.dart';
import 'package:cloudy/features/user_data/presentation/bloc/user_data_bloc.dart';
import 'package:cloudy/core/presentation/show_url_widget.dart';
import 'package:cloudy/features/user_data/presentation/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    context.read<UserDataBloc>().add(GetStartUserData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoaded) {
          final user = state.userData;
          return StreamBuilder<List<UserEntity>>(
            stream: state.contactsStream.map((contacts) => contacts ?? []),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final contacts = snapshot.data ?? [];

              if (contacts.isNotEmpty) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: contacts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (_, index) {
                    final currentUser = contacts[index];
                    final data = InitialDataValueEntity(
                      initiatorAID: user.AID,
                      secondAID: currentUser.AID,
                      avatarUrl: currentUser.urlAvatar,
                      username: currentUser.username,
                      firstPublicKey: user.keys.publicKey,
                      firstPrivateKey: user.keys.privateKey,
                      secondPublicKey: CipherService().regeneratePublicKey({
                        'n': currentUser.nPub,
                        'e': currentUser.ePub,
                      }),
                    );
                    return UserWidget(
                      localName: currentUser.localName,
                      avatarUrl: currentUser.urlAvatar,
                      userName: currentUser.username,
                      initiatorID: user.AID,
                      secondID: currentUser.AID,
                      onTap: () =>
                          context.push('/messages/communication', extra: data),
                    );
                  },
                );
              } else {
                return Column(
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                    Assets.images.bgNoChats.image(),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => showUrlDialog(
                        context,
                        user.AID,
                        user.urlStatus,
                        false,
                      ),
                      style: Theme.of(context)
                          .elevatedButtonTheme
                          .style!
                          .copyWith(
                              fixedSize:
                                  const WidgetStatePropertyAll(Size(180, 40))),
                      child: Text(
                        'Enable public url',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: TColorTheme.white,
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'or',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () =>
                          context.push('/messages/import/${user.AID}'),
                      style: Theme.of(context).textButtonTheme.style!.copyWith(
                            foregroundColor: const WidgetStatePropertyAll(
                                TColorTheme.mainBlue),
                            textStyle: WidgetStatePropertyAll(Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(fontSize: 16)),
                          ),
                      child: const Text('Import an address'),
                    )
                  ],
                );
              }
            },
          );
        } else if (state is UserDataLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserDataFailure) {
          return Center(
            child: Text(state.message),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
