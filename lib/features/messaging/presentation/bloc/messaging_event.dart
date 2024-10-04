// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'messaging_bloc.dart';

sealed class MessagingEvent extends Equatable {
  const MessagingEvent();

  @override
  List<Object> get props => [];
}

class DialogInitializationEvent extends MessagingEvent {
  final InitialDataValueEntity initialDataValue;
  const DialogInitializationEvent({
    required this.initialDataValue,
  });
  @override
  List<Object> get props => [initialDataValue];
}

class SendMessageEvent extends MessagingEvent {
  final String message;
  final Uint8List dialogKey;
  final String initiatorID;
  final String secondID;
  const SendMessageEvent({
    required this.message,
    required this.dialogKey,
    required this.initiatorID,
    required this.secondID,
  });

  @override
  List<Object> get props => [message, dialogKey, initiatorID, secondID];
}

class MessagesUpdated extends MessagingEvent {
  final Map<String, dynamic> messages;

  const MessagesUpdated({required this.messages});

  @override
  List<Object> get props => [messages];
}
