// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloudy/features/registration/domain/entities/person_entity.dart';
import 'package:cloudy/features/registration/domain/repository/registration_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:injectable/injectable.dart';

part 'registration_event.dart';
part 'registration_state.dart';

@injectable
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationRepository registrationRepository;
  RegistrationBloc({required this.registrationRepository})
      : super(RegistrationInitial()) {
    on<CreatePersonEvent>(_createPerson);
  }

  Future<void> _createPerson(
      CreatePersonEvent event, Emitter<RegistrationState> emit) async {
    try {
      await registrationRepository.createPesron(event.personEntity);
      emit(RegistrationLoaded());
    } catch (e) {
      emit(RegistrationFailure(message: e.toString()));
    }
  }
}
