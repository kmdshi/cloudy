import 'dart:typed_data';

import 'package:pointycastle/api.dart';

abstract class MessagingRepository {
  Future<Uint8List> startDialog(
    String initiatorAID,
    String secondAID,

    PublicKey secondPublicKey,
  );

  Future<void> sendMessage(String message, Uint8List dialogKey,
      String initiatorAID, String secondAID);

  Stream<Map<String, dynamic>> getMessagesStream(
      String initiatorAID, String secondAID);
}
