import 'dart:convert';
import 'dart:typed_data';

import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/features/messaging/domain/entities/initial_data_value.dart';
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
  @override
  void initState() {
    messageController = TextEditingController();
    context.read<MessagingBloc>().add(DialogInitializationEvent(
        initialDataValue: widget.initialDataValueEntity));
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
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
            final dialogHistory = state.chatHistory;
            return Expanded(
              child: TextField(
                controller: messageController,
                onSubmitted: (_) => sendMessage(dialogKey),
              ),
            );
            // // return StreamBuilder(
            // //   stream: state.chatHistory,
            // //   builder: (context, snapshot) {
            // //     if (snapshot.hasData) {
            // //       if (snapshot.data!.isEmpty) {
            // //         return Center(child: Text('No messages yet'));
            // //       } else {
            // //         // return ListView.builder(
            // //         //   itemCount: messages.length,
            // //         //   itemBuilder: (context, index) {
            // //         //     final message = messages[index];
            // //         //     return ListTile(
            // //         //       title: Text(message['text'] ?? ''),
            // //         //       subtitle:
            // //         //           Text(message['timestamp']?.toString() ?? ''),
            // //         //     );
            // //         //   },
            // //         // );
            // //       }
            // //       return SizedBox.shrink();
            //     } else {
            //       return Center(child: Text('shapshot eror'));
            //     }
            //   },
            // );
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
