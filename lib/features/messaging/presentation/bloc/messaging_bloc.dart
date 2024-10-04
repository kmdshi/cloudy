import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloudy/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cloudy/features/messaging/domain/entities/message_entity.dart';
import 'package:cloudy/features/messaging/domain/repository/messaging_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

@injectable
class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final MessagingRepository messagingRepository;
  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  MessagingBloc({
    required this.messagingRepository,
  }) : super(MessagingInitial()) {
    on<DialogInitializationEvent>(_dialogInit);
    on<MessagesUpdated>(_updatedMessages);
    on<SendMessageEvent>(_sendMessage);
  }

  Future<void> closeSubcription() async {
    await _messagesSubscription?.cancel();
  }

  Future<void> _dialogInit(
      DialogInitializationEvent event, Emitter<MessagingState> emit) async {
    try {
      final dialogKey = await messagingRepository.startDialog(
        event.initialDataValue.initiatorAID,
        event.initialDataValue.secondAID,
        event.initialDataValue.secondPublicKey,
      );
      final chatHistoryStream = messagingRepository.getMessagesStream(
          event.initialDataValue.initiatorAID,
          event.initialDataValue.secondAID,
          dialogKey);
      emit(MessagingLoaded(
          dialogKey: dialogKey, chatHistory: chatHistoryStream));

      _messagesSubscription = chatHistoryStream.listen((messages) {
        add(MessagesUpdated(messages: messages));
      });
    } catch (e) {
      emit(MessagingFailure(message: e.toString()));
    }
  }

  Future<void> _sendMessage(
      SendMessageEvent event, Emitter<MessagingState> emit) async {
    try {
      messagingRepository.sendMessage(
        event.message,
        event.dialogKey,
        event.initiatorID,
        event.secondID,
      );
    } catch (e) {
      emit(MessagingFailure(message: e.toString()));
    }
  }

  Future<void> _updatedMessages(
      MessagesUpdated event, Emitter<MessagingState> emit) async {
    try {
      if (state is MessagingLoaded) {
        final currentState = state as MessagingLoaded;

        final updatedMessages = event.messages;

        emit(MessagingLoaded(
          dialogKey: currentState.dialogKey,
          chatHistory: Stream.value(updatedMessages),
        ));
      }
    } catch (e) {
      emit(MessagingFailure(message: e.toString()));
    }
  }
}
