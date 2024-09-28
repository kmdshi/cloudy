// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'messaging_bloc.dart';

sealed class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

final class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final SelfEntity userData;
  const UserDataLoaded({
    required this.userData,
  });

  @override
  List<Object> get props => [userData];
}

class UserDataFailure extends UserDataState {
  final String message;
  const UserDataFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
