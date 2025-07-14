import 'dart:async';
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
  StreamController<List<MessageEntity>>? _controller;

  Stream<List<MessageEntity>> get chatStream => _controller!.stream;

  MessagingBloc({
    required this.messagingRepository,
  }) : super(MessagingInitial()) {
    on<DialogInitializationEvent>(_dialogInit);
    on<MessagesUpdated>(_updatedMessages);
    on<SendMessageEvent>(_sendMessage);
    on<ClearMessagesHistory>(_clearMessagesHistory);
  }

  Future<void> closeSubcription() async {
    await _messagesSubscription?.cancel();
    await _controller?.close();
    _controller = null;
    emit(MessagingInitial());
  }

  Future<void> _clearMessagesHistory(
      ClearMessagesHistory event, Emitter<MessagingState> emit) async {
    if (state is MessagingLoaded) {
      final currentState = state as MessagingLoaded;

      try {
        await messagingRepository.clearMessagesHistory(
            event.initiatorAID, event.secondAID);

        emit(MessagingLoaded(
          dialogKey: currentState.dialogKey,
        ));
      } catch (e) {
        emit(MessagingFailure(message: e.toString()));
      }
    } else {
      emit(const MessagingFailure(
          message: 'Invalid state: MessagingLoaded expected.'));
    }
  }

  Future<void> _dialogInit(
      DialogInitializationEvent event, Emitter<MessagingState> emit) async {
    try {
      final dialogKey = await messagingRepository.startDialog(
        event.initialDataValue.initiatorAID,
        event.initialDataValue.secondAID,
        event.initialDataValue.secondPublicKey,
      );

      await closeSubcription();

      final controller = StreamController<List<MessageEntity>>();
      controller.add([]);

      _messagesSubscription = messagingRepository
          .getMessagesStream(event.initialDataValue.initiatorAID,
              event.initialDataValue.secondAID, dialogKey)
          .listen(controller.add);

      _controller = controller;

      emit(MessagingLoaded(
        dialogKey: dialogKey,
      ));
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

        emit(MessagingLoaded(
          dialogKey: currentState.dialogKey,
        ));
      }
    } catch (e) {
      emit(MessagingFailure(message: e.toString()));
    }
  }
}
