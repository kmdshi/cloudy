import 'package:cloudy/features/user_data/domain/entities/last_message_entity.dart';
import 'package:cloudy/features/user_data/domain/entities/self_entity.dart';
import 'package:cloudy/features/user_data/domain/entities/user_entity.dart';

abstract class UserDataRepository {
  Future<SelfEntity> handleSelfEntity();
  Future<String?> addNewCompanion(
      String AID, String newContact, String? localName);
  Future<Stream<LastMessageEntity?>> getLastMessageStream(
      String initiatorAID, String secondAID);
  Future<Stream<List<UserEntity>?>> getContactsStream(String initiatorAID);
  Future<void> changeDataUrlStatus(String AID, bool newStatus);
}
