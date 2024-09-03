part of 'messaging_bloc.dart';

sealed class MessagingState extends Equatable {
  const MessagingState();
  
  @override
  List<Object> get props => [];
}

final class MessagingInitial extends MessagingState {}
