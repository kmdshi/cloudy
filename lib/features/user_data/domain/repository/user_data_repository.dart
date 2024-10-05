import 'package:cloudy/features/user_data/domain/entities/last_message_entity.dart';
import 'package:cloudy/features/user_data/domain/entities/self_entity.dart';

abstract class UserDataRepository {
  Future<SelfEntity> handleSelfEntity();
  Future<void> addNewCompanion(String AID);
  Future<Stream<LastMessageEntity?>> getLastMessageStream(String initiatorAID, String secondAID);
}
