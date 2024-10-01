// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'messaging_bloc.dart';

sealed class MessagingState extends Equatable {
  const MessagingState();

  @override
  List<Object> get props => [];
}

final class MessagingInitial extends MessagingState {}

class MessagingLoading extends MessagingState {}

class MessagingLoaded extends MessagingState {
  final Uint8List dialogKey;
  final Stream<Map<String, dynamic>> chatHistory;
  const MessagingLoaded({
    required this.dialogKey,
    required this.chatHistory,
  });

  @override
  List<Object> get props => [dialogKey];
}

class MessagingFailure extends MessagingState {
  final String message;
  const MessagingFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
