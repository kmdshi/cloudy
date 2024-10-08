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

class AddContactEvent extends UserDataEvent {
  final String AID;
  final String contactAID;
  final String? localName;
  const AddContactEvent(
      {required this.AID, required this.contactAID, this.localName});

  @override
  List<Object> get props => [];
}

class ContactsUpdatedEvent extends UserDataEvent {
  final List<UserEntity>? updatedContacts;

  const ContactsUpdatedEvent(
    this.updatedContacts,
  );
}

class ChangeUrlStatusEvent extends UserDataEvent {
  final String AID;
  final bool newStatus;
  const ChangeUrlStatusEvent({
    required this.AID,
    required this.newStatus,
  });
  @override
  List<Object> get props => [AID, newStatus];
}
