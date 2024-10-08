import 'dart:async';
import 'dart:developer';

import 'package:cloudy/features/user_data/domain/entities/self_entity.dart';
import 'package:cloudy/features/user_data/domain/entities/user_entity.dart';
import 'package:cloudy/features/user_data/domain/repository/user_data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

@injectable
class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final UserDataRepository messagingRepository;
  StreamSubscription<List<UserEntity>?>? _contactsSubscription;

  UserDataBloc({
    required this.messagingRepository,
  }) : super(UserDataInitial()) {
    on<GetStartUserData>(_getStartData);
    on<AddContactEvent>(_addContact);
    on<ContactsUpdatedEvent>(_onContactsUpdated);
    on<ChangeUrlStatusEvent>(_changeUrlStatus);
  }

  Future<void> _changeUrlStatus(
      ChangeUrlStatusEvent event, Emitter<UserDataState> emit) async {
    try {
      await messagingRepository.changeDataUrlStatus(event.AID, event.newStatus);

      if (state is UserDataLoaded) {
        final currentState = state as UserDataLoaded;

        emit(UserDataLoaded(
            contactsStream: currentState.contactsStream,
            userData:
                currentState.userData.copyWith(urlStatus: event.newStatus)));
      }
    } catch (e) {
      emit(UserDataFailure(message: e.toString()));
    }
  }

  Future<void> _getStartData(
      GetStartUserData event, Emitter<UserDataState> emit) async {
    try {
      final user = await messagingRepository.handleSelfEntity();
      final contactsStream =
          await messagingRepository.getContactsStream(user.AID);

      await _contactsSubscription?.cancel();
      _contactsSubscription = contactsStream.listen(
        (contacts) {
          add(ContactsUpdatedEvent(contacts));
        },
        onError: (error) {
          emit(UserDataFailure(message: error.toString()));
        },
      );

      emit(UserDataLoaded(userData: user, contactsStream: contactsStream));
    } catch (e) {
      emit(UserDataFailure(message: e.toString()));
    }
  }

  Future<void> _addContact(
      AddContactEvent event, Emitter<UserDataState> emit) async {
    try {
      if (state is UserDataLoaded) {
        final currentState = state as UserDataLoaded;

        emit(UserDataLoading());

        final result = await messagingRepository.addNewCompanion(
          event.AID,
          event.contactAID,
          event.localName,
        );

        emit(UserDataLoaded(
          userData: currentState.userData,
          expectedErrorMessage: result,
          contactsStream: currentState.contactsStream,
        ));
      }
    } catch (e) {
      emit(UserDataFailure(message: e.toString()));
    }
  }

  void _onContactsUpdated(
      ContactsUpdatedEvent event, Emitter<UserDataState> emit) {
    if (state is UserDataLoaded) {
      final currentState = state as UserDataLoaded;

      emit(UserDataLoaded(
        userData: currentState.userData,
        contactsStream: currentState.contactsStream,
        expectedErrorMessage: currentState.expectedErrorMessage,
      ));
    }
  }

  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }
}
