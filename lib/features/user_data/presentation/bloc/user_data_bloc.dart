
import 'package:cloudy/features/user_data/domain/entities/self_entity.dart';
import 'package:cloudy/features/user_data/domain/repository/user_data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

@injectable
class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final UserDataRepository messagingRepository;
  UserDataBloc({
    required this.messagingRepository,
  }) : super(UserDataInitial()) {
    on<GetStartUserData>(_getStartData);
  }

  Future<void> _getStartData(
      GetStartUserData event, Emitter<UserDataState> emit) async {
    try {
      final user = await messagingRepository.handleSelfEntity();

      emit(UserDataLoaded(userData: user));
    } catch (e) {
      emit(UserDataFailure(message: e.toString()));
    }
  }

  
}
