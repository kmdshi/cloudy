import 'dart:typed_data';

import 'package:cloudy/features/messaging/domain/entities/message_entity.dart';
import 'package:pointycastle/api.dart';

abstract class MessagingRepository {
  Future<Uint8List> startDialog(
    String initiatorAID,
    String secondAID,
    PublicKey secondPublicKey,
  );

  Future<void> sendMessage(String message, Uint8List dialogKey,
      String initiatorAID, String secondAID);

  Stream<List<MessageEntity>> getMessagesStream(
      String initiatorAID, String secondAID, Uint8List dialogKey);
}
