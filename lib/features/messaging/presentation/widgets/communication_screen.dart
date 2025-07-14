import 'dart:typed_data';

import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cloudy/features/messaging/domain/entities/message_entity.dart';
import 'package:cloudy/features/messaging/presentation/bloc/messaging_bloc.dart';
import 'package:cloudy/features/messaging/presentation/widgets/custom_input_field.dart';
import 'package:cloudy/features/messaging/presentation/widgets/message_widget.dart';
import 'package:cloudy/features/messaging/presentation/widgets/time_separator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CommunicationScreen extends StatefulWidget {
  final InitialDataValueEntity initialDataValueEntity;
  const CommunicationScreen({
    super.key,
    required this.initialDataValueEntity,
  });

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  late final TextEditingController messageController;
  late final MessagingBloc messagingBloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    messageController = TextEditingController();
    _scrollController = ScrollController();

    messagingBloc = context.read<MessagingBloc>();

    messagingBloc.add(DialogInitializationEvent(
      initialDataValue: widget.initialDataValueEntity,
    ));

    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    _scrollController.dispose();
    messagingBloc.closeSubcription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MessagingBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        surfaceTintColor: TColorTheme.transparent,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Assets.icons.arrowIcon.image(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage(widget.initialDataValueEntity.avatarUrl),
            ),
            const SizedBox(width: 8),
            // сделать форматирование строки на обьект AID и никнейма
            Text(
              widget.initialDataValueEntity.username,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          MenuAnchor(
            style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                  TColorTheme.scaffoldbg.withValues(alpha: 0.96)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            builder: (context, controller, child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: Assets.icons.moreIcon.image(),
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: () => context
                    .read<MessagingBloc>()
                    .add(ClearMessagesHistory(
                      initiatorAID: widget.initialDataValueEntity.initiatorAID,
                      secondAID: widget.initialDataValueEntity.secondAID,
                    )),
                child: const Text('Удалить историю диалога'),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<MessagingBloc, MessagingState>(
        builder: (context, state) {
          if (state is MessagingLoaded) {
            final dialogKey = state.dialogKey;
            String? previousDate;

            return StreamBuilder<List<MessageEntity>>(
              stream: bloc.chatStream,
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Lottie.asset('assets/gifs/empty-chat-gif.json'),
                            Text(
                              'Oops... there\'s nothing here yet, start a dialog first',
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomInputField(
                                controller: messageController,
                                onSubmitted: (_) {
                                  sendMessage(dialogKey);
                                  messageController.clear();
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                sendMessage(dialogKey);
                                messageController.clear();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  final messages = snapshot.data!;

                  _scrollToBottom();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.only(
                                top: 50,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              children: [
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];

                                    final messageDate = DateFormat('yyyy-MM-dd')
                                        .format(message.timestamp);

                                    if (index == 0 ||
                                        previousDate != messageDate) {
                                      previousDate = messageDate;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          TimeSeparatorWidget(
                                              date: message.timestamp),
                                          const SizedBox(height: 10),
                                          MessageWidget(
                                            message: message.message,
                                            date: message.timestamp,
                                            isFromInitiator:
                                                message.isFromInitiator,
                                          ),
                                        ],
                                      );
                                    } else {
                                      return MessageWidget(
                                        message: message.message,
                                        date: message.timestamp,
                                        isFromInitiator:
                                            message.isFromInitiator,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomInputField(
                                  controller: messageController,
                                  onSubmitted: (_) {
                                    sendMessage(dialogKey);
                                    messageController.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else if (state is MessagingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MessagingFailure) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void sendMessage(Uint8List dialogKey) {
    if (messageController.text != '') {
      context.read<MessagingBloc>().add(SendMessageEvent(
            message: messageController.text,
            dialogKey: dialogKey,
            initiatorID: widget.initialDataValueEntity.initiatorAID,
            secondID: widget.initialDataValueEntity.secondAID,
          ));
    }
  }

  void openOptions() {}

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
