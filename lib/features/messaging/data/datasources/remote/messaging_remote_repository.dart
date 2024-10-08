// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/features/messaging/data/DTO/message_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/pointycastle.dart';

@lazySingleton
class MessagingRemoteRepository {
  final FirebaseFirestore fireStoreDB;
  final CipherService cipherService;
  MessagingRemoteRepository({
    required this.fireStoreDB,
    required this.cipherService,
  });

  Future<Uint8List> startDialog(
    String initiatorAID,
    String secondAID,
    PublicKey initiatorPublicKey,
    PrivateKey firstPrivateKey,
    PublicKey secondPublicKey,
  ) async {
    final sortedAIDs = [initiatorAID.substring(0, 4), secondAID.substring(0, 4)]
      ..sort();
    final mutualAID = '${sortedAIDs[0]}_${sortedAIDs[1]}';

    DocumentSnapshot snapshot =
        await fireStoreDB.collection('dialogs').doc(mutualAID).get();

    if (!snapshot.exists) {
      final commonSymmeticKey = cipherService.generateRandomAESKey();

      final firstUserKey = cipherService.encryptSymmetricKey(
          commonSymmeticKey, initiatorPublicKey);

      final secondUserKey =
          cipherService.encryptSymmetricKey(commonSymmeticKey, secondPublicKey);

      final firebaseData = {
        initiatorAID.substring(0, 4): firstUserKey,
        secondAID.substring(0, 4): secondUserKey,
        'messages': {},
      };
      await fireStoreDB.collection('dialogs').doc(mutualAID).set(firebaseData);

      return base64Decode(firstUserKey);
    } else {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw ('Something went wrong');
      }

      final initiatorKey = data[initiatorAID.substring(0, 4)];
      
      if (initiatorKey != null) {
        final decryptedKey = cipherService.decryptSymmetricKey(
          initiatorKey,
          firstPrivateKey,
        );
        return decryptedKey;
      } else {
        throw ('No key data found');
      }
    }
  }

  Future<void> sendMessage(
    String message,
    Uint8List dialogKey,
    String initiatorAID,
    String secondAID,
  ) async {
    final sortedAIDs = [initiatorAID.substring(0, 4), secondAID.substring(0, 4)]
      ..sort();
    final mutualAID = '${sortedAIDs[0]}_${sortedAIDs[1]}';

    DocumentSnapshot snapshot =
        await fireStoreDB.collection('dialogs').doc(mutualAID).get();

    if (!snapshot.exists) {
      throw Exception('Диалог не существует');
    } else {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception('Не удалось получить данные диалога');
      }

      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final timestamp = Timestamp.now();

      final encryptedMessage = cipherService.encryptMessage(
        message,
        base64Encode(dialogKey),
      );

      final newMessage = {
        'id': messageId,
        'sender': initiatorAID,
        'message': encryptedMessage,
        'timestamp': timestamp,
      };

      data['messages'][messageId] = newMessage;

      await fireStoreDB.collection('dialogs').doc(mutualAID).update(data);
    }
  }

  Stream<List<MessageDto>> getMessagesStream(
      String initiatorAID, String secondAID) {
    final sortedAIDs = [initiatorAID.substring(0, 4), secondAID.substring(0, 4)]
      ..sort();
    final mutualAID = '${sortedAIDs[0]}_${sortedAIDs[1]}';

    return fireStoreDB
        .collection('dialogs')
        .doc(mutualAID)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        final messagesMap = data?['messages'] ?? {};
      
        return (messagesMap as Map<String, dynamic>).entries.map((entry) {
          final messageDto =
              MessageDto.fromMap(entry.value as Map<String, dynamic>).copyWith(
            isFromInitiator: initiatorAID == entry.value['sender'],
          );

          return messageDto;
        }).toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      } else {
        return <MessageDto>[];
      }
    });
  }
}
