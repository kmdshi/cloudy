// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_data_bloc.dart';

sealed class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

class GetStartUserData extends UserDataEvent {}

class GetLastMessageStreamEvent extends UserDataEvent {
  final String initiatorID;
  final String secondAID;
  const GetLastMessageStreamEvent({
    required this.initiatorID,
    required this.secondAID,
  });

  @override
  List<Object> get props => [initiatorID, secondAID];
}
