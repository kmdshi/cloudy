import 'dart:typed_data';

abstract class MessagingRepository {
  Future<Uint8List> startDialog(
      String initiatorAID,
      String secondAID,
      String  fPublicKeyModulus,
      String  fPublicKeyExponent,
      String  sPublicKeyModulus,
      String  sPublicKeyExponent);

  Future<void> sendMessage(String message, Uint8List dialogKey,
      String initiatorAID, String secondAID);
      
  Stream<Map<String, dynamic>> getMessagesStream(
      String initiatorAID, String secondAID);
}
