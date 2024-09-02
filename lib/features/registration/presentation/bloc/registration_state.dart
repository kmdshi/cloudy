// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'registration_bloc.dart';

@immutable
sealed class RegistrationState extends Equatable {
  @override
  List<Object> get props => [];
}

final class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLoaded extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String message;
  RegistrationFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
