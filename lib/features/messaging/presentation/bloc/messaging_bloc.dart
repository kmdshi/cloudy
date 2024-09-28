import 'dart:typed_data';

import 'package:cryptome/features/messaging/domain/entities/initial_data_value.dart';
import 'package:cryptome/features/messaging/domain/repository/messaging_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'messaging_event.dart';
part 'messaging_state.dart';

@injectable
class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final MessagingRepository messagingRepository;
  MessagingBloc({
    required this.messagingRepository,
  }) : super(MessagingInitial()) {
    on<DialogInitializationEvent>(_dialogInit);
  }

  Future<void> _dialogInit(
      DialogInitializationEvent event, Emitter<MessagingState> emit) async {
    try {
      final dialogKey = await messagingRepository.startDialog(
          event.initialDataValue.initiatorAID,
          event.initialDataValue.secondAID,
          event.initialDataValue.fPublicKeyModulus,
          event.initialDataValue.fPublicKeyExponent,
          event.initialDataValue.sPublicKeyModulus,
          event.initialDataValue.sPublicKeyExponent);
      emit(MessagingLoaded(dialogKey: dialogKey));
    } catch (e) {
      emit(MessagingFailure(messsage: e.toString()));
    }
  }
}
