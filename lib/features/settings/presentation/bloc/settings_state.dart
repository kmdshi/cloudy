part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserSelfEntitiy userData;
  final String? expectedErrorMessage;
  const SettingsLoaded({
    required this.userData,
    this.expectedErrorMessage
  });

  @override
  List<Object> get props => [userData];
}

class SettingsFailure extends SettingsState {
  final String message;
  const SettingsFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}


class CustomSettingsFailures extends SettingsState {
  final String message;
  const CustomSettingsFailures({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
