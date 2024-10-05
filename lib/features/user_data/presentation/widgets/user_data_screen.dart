// ignore_for_file: non_constant_identifier_names

import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cloudy/features/user_data/presentation/bloc/user_data_bloc.dart';
import 'package:cloudy/features/user_data/presentation/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

          return user.contacts.isEmpty
              ? Column(
                  children: [
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                    Assets.images.bgNoChats.image(),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => _showUrlDialog(
                        context,
                        user.AID,
                        user.urlStatus,
                      ),
                      style:
                          Theme.of(context).elevatedButtonTheme.style!.copyWith(
                                fixedSize:
                                    const WidgetStatePropertyAll(Size(180, 40)),
                              ),
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
                      onPressed: () => context.push('/messages/import'),
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
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: user.contacts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final currentUser = user.contacts[index];
                    final data = InitialDataValueEntity(
                      initiatorAID: user.AID,
                      secondAID: currentUser.AID,
                      firstPublicKey: user.keys.publicKey,
                      firstPrivateKey: user.keys.privateKey,
                      secondPublicKey: CipherService().regeneratePublicKey({
                        'n': currentUser.nPub,
                        'e': currentUser.ePub,
                      }),
                    );
                    return UserWidget(
                      avatarUrl: currentUser.urlAvatar,
                      userName: currentUser.username,
                      initiatorID: user.AID,
                      secondID: currentUser.AID,
                      onTap: () =>
                          context.push('/messages/communication', extra: data),
                    );
                  });
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

  Future<Object?> _showUrlDialog(
    BuildContext context,
    String AID,
    bool urlStatus,
  ) async {
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, __, ___) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              width: 334,
              height: 430,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Public URL is ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 16)),
                            TextSpan(
                              text: 'Enabled',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListBody(
                      children: [
                        Text(
                          'You are now enabling public url. \nIt means, you can invite people to message \nyou directly using url below.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 14,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: QrImageView(
                            data: 'public.cx/0x$AID',
                            version: QrVersions.auto,
                            size: 115.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Your public url:',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => onTextTap(context),
                          child: Text(
                            'public.cx/0x$AID',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 14,
                                  color: TColorTheme.buttonBgBlue,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.paperIcon.image(),
                            const SizedBox(width: 5),
                            Text(
                              'click to copy',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontSize: 12,
                                  ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                fixedSize:
                                    const WidgetStatePropertyAll(Size(143, 40)),
                                foregroundColor: const WidgetStatePropertyAll(
                                    TColorTheme.textGrey),
                                backgroundColor: const WidgetStatePropertyAll(
                                    TColorTheme.white),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: TColorTheme.textGrey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                          child: Text(
                            urlStatus
                                ? 'Disable Public url'
                                : 'Enable Public url',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: TColorTheme.textGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                fixedSize:
                                    const WidgetStatePropertyAll(Size(114, 40)),
                              ),
                          child: Text(
                            'Save & close',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: TColorTheme.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onTextTap(context) async {
    await Clipboard.setData(const ClipboardData(
            text: 'public.cx/0x79BFAA8B226FC527315A8C07B2953927382CDE8B'))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to your clipboard !')));
    });
  }
}
