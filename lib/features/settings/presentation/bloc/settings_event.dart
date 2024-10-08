// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class GetInitialUserData extends SettingsEvent {}

class AddSettingsContactEvent extends SettingsEvent {
  final String AID;
  final String contactAID;
  final String? localName;
  const AddSettingsContactEvent(
      {required this.AID, required this.contactAID, this.localName});

  @override
  List<Object> get props => [];
}

class ChangeUrlSettingsStatusEvent extends SettingsEvent {
  final String AID;
  final bool newStatus;
  const ChangeUrlSettingsStatusEvent({
    required this.AID,
    required this.newStatus,
  });
  @override
  List<Object> get props => [AID, newStatus];
}
