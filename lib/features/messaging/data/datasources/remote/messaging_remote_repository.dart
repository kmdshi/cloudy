// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptome/core/services/cipher_service.dart';
import 'package:injectable/injectable.dart';

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
    String fPublicKeyModulus,
    String fPublicKeyExponent,
    String fPrivateKeyModulus,
    String fPrivatKeyExponent,
    String p,
    String q,
    String sPublicKeyModulus,
    String sPublicKeyExponent,
  ) async {
    final sortedAIDs = [initiatorAID.substring(0, 4), secondAID.substring(0, 4)]
      ..sort();
    final mutualAID = '${sortedAIDs[0]}_${sortedAIDs[1]}';

    DocumentSnapshot snapshot =
        await fireStoreDB.collection('dialogs').doc(mutualAID).get();

    if (!snapshot.exists) {
      final commonSymmeticKey = cipherService.generateSymmetricKey();

      final firstUserKey = cipherService.encryptDialogKeyWithPublicUserKey(
        commonSymmeticKey,
        fPublicKeyModulus,
        fPublicKeyExponent,
      );

      final secondUserKey = cipherService.encryptDialogKeyWithPublicUserKey(
        commonSymmeticKey,
        sPublicKeyModulus,
        sPublicKeyExponent,
      );

      final firebaseData = {
        sortedAIDs[0]: base64.encode(firstUserKey),
        sortedAIDs[1]: base64.encode(secondUserKey),
        'messages': {},
      };
      await fireStoreDB.collection('dialogs').doc(mutualAID).set(firebaseData);

      return firstUserKey;
    } else {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw ('Something went wrong');
      }

      final initiatorKey = data[initiatorAID.substring(0, 4)];
      if (initiatorKey != null) {
        final encryptedKey = cipherService.decryptWithPrivateKey(
          initiatorKey,
          fPrivateKeyModulus,
          fPrivatKeyExponent,
          p,
          q,
        );
        print('ENCRYPTED KEY: $encryptedKey');
        final decodedData = base64.decode(encryptedKey);
        return decodedData;
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
      final newMessage = {
        'id': messageId,
        'sender': initiatorAID,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      };

      data['messages'][messageId] = newMessage;

      await fireStoreDB.collection('dialogs').doc(mutualAID).update(data);
    }
  }

  Stream<Map<String, dynamic>> getMessagesStream(
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
        return data?['messages'] ?? {};
      } else {
        return {};
      }
    });
  }
}
