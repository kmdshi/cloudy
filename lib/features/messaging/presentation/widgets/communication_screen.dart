import 'dart:typed_data';

import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cloudy/features/messaging/domain/entities/message_entity.dart';
import 'package:cloudy/features/messaging/presentation/bloc/messaging_bloc.dart';
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

  @override
  void initState() {
    messageController = TextEditingController();
    messagingBloc = context.read<MessagingBloc>();

    messagingBloc.add(DialogInitializationEvent(
      initialDataValue: widget.initialDataValueEntity,
    ));
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    messagingBloc.closeSubcription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return ListTile(
                              title: Text(message.message),
                              subtitle: Text(message.senderID),
                              trailing: Text(
                                message.timestamp.toLocal().toString(),
                              ),
                            );
                          },
                        ),
                      ),
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
}
