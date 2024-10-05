import 'dart:typed_data';

import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cloudy/features/messaging/domain/entities/message_entity.dart';
import 'package:cloudy/features/messaging/presentation/bloc/messaging_bloc.dart';
import 'package:cloudy/features/messaging/presentation/widgets/custom_input_field.dart';
import 'package:cloudy/features/messaging/presentation/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: TColorTheme.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Assets.icons.arrowIcon.image(),
        ),
      ),
      body: BlocBuilder<MessagingBloc, MessagingState>(
        builder: (context, state) {
          if (state is MessagingLoaded) {
            final dialogKey = state.dialogKey;

            return StreamBuilder<List<MessageEntity>>(
              stream: state.chatHistory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      const Center(child: Text('No messages')),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                decoration: const InputDecoration(
                                  labelText: 'Enter message',
                                  border: OutlineInputBorder(),
                                ),
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
                            child: Column(
                              children: [
                                ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: messages.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    return MessageWidget(
                                      message: message.message,
                                      date: message.timestamp,
                                      isFromInitiator: message.isFromInitiator,
                                    );
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
