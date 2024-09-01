// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final bool isReg;

  AuthLoaded({
    required this.isReg,
  });

  @override
  List<Object> get props => [isReg];
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
