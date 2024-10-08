// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_data_bloc.dart';

sealed class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

final class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final SelfEntity userData;
  final Stream<List<UserEntity>?> contactsStream;
  final String? expectedErrorMessage;
  const UserDataLoaded({
    required this.userData,
    required this.contactsStream,
    this.expectedErrorMessage,
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
