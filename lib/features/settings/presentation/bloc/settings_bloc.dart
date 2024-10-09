import 'package:cloudy/features/settings/domain/entity/user_self_entitiy.dart';
import 'package:cloudy/features/settings/domain/repository/settings_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;
  SettingsBloc({
    required this.settingsRepository,
  }) : super(SettingsInitial()) {
    on<GetInitialUserData>(_getUserData);
    on<AddSettingsContactEvent>(_addContact);
    on<ChangeUrlSettingsStatusEvent>(_changeStatus);
  }

  Future<void> _changeStatus(
      ChangeUrlSettingsStatusEvent event, Emitter<SettingsState> emit) async {
    try {
      await settingsRepository.changeUrlStatus(event.AID, event.newStatus);

      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;

        emit(SettingsLoaded(
            userData:
                currentState.userData.copyWith(urlStatus: event.newStatus)));
      }
    } catch (e) {
      emit(SettingsFailure(message: e.toString()));
    }
  }

  Future<void> _getUserData(
      SettingsEvent event, Emitter<SettingsState> emit) async {
    try {
      final user = await settingsRepository.initialUserData();
      emit(SettingsLoaded(userData: user));
    } catch (e) {
      emit(SettingsFailure(message: e.toString()));
    }
  }

  Future<void> _addContact(
      AddSettingsContactEvent event, Emitter<SettingsState> emit) async {
    try {
      if (state is SettingsLoaded) {
        final currentState = state as SettingsLoaded;

        emit(SettingsLoading());
        final result = await settingsRepository.addContact(
          event.AID,
          event.contactAID,
          event.localName,
        );

        emit(SettingsLoaded(
          userData: currentState.userData,
          expectedErrorMessage: result,
        ));
      }
    } catch (e) {
      emit(SettingsFailure(message: e.toString()));
    }
  }
}
