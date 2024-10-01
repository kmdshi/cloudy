import 'package:cryptome/core/gen/assets.gen.dart';
import 'package:cryptome/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cryptome/features/messaging/presentation/bloc/messaging_bloc.dart';
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
  @override
  void initState() {
    context.read<MessagingBloc>().add(DialogInitializationEvent(
        initialDataValue: widget.initialDataValueEntity));
    super.initState();
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
            final adsa = state.dialogKey;
            final dialog = state.chatHistory;
            // return StreamBuilder(
            //   stream: state.chatHistory,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       if (snapshot.data!.isEmpty) {
            //         return Center(child: Text('No messages yet'));
            //       }
            //       return SizedBox.shrink();
            //       // } else {
            //       //   return ListView.builder(
            //       //     itemCount: messages.length,
            //       //     itemBuilder: (context, index) {
            //       //       final message = messages[index];
            //       //       return ListTile(
            //       //         title: Text(message['text'] ?? ''),
            //       //         subtitle:
            //       //             Text(message['timestamp']?.toString() ?? ''),
            //       //       );
            //       //     },
            //       //   );
            //       // }
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
}
