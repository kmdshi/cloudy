import 'package:cryptome/features/messaging/domain/entities/self_entity.dart';

abstract class MessagingRepository {
  Future<SelfEntity> handleSelfEntity(String AID);
  // ignore: non_constant_identifier_names
  Future<void> addNewCompanion(String AID);
}
