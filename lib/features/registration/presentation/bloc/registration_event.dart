// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'registration_bloc.dart';

@immutable
sealed class RegistrationEvent extends Equatable {}

class CreatePersonEvent extends RegistrationEvent {
  final PersonEntity personEntity;
  CreatePersonEvent({
    required this.personEntity,
  });

  @override
  List<Object?> get props => [personEntity];
}
