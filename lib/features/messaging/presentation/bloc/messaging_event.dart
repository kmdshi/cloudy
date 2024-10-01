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

class MessagesUpdated extends MessagingEvent {
  final Map<String, dynamic> messages;

  const MessagesUpdated({required this.messages});

  @override
  List<Object> get props => [messages];
}
