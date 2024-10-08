// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/core/services/date_manipualtions.dart';
import 'package:cloudy/features/messaging/data/DTO/message_dto.dart';
import 'package:cloudy/features/user_data/data/DTO/users_dto.dart';
import 'package:cloudy/features/user_data/domain/entities/last_message_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/api.dart';

@lazySingleton
class UserDataRemoteRepo {
  final FirebaseFirestore fireStoreDB;
  final FirebaseStorage firestorage;
  final CipherService cipherService;

  UserDataRemoteRepo({
    required this.fireStoreDB,
    required this.firestorage,
    required this.cipherService,
  });

  Stream<LastMessageEntity?> getLastMessageStream(
    String initiatorAID,
    String secondAID,
    AsymmetricKeyPair<PublicKey, PrivateKey> keys,
  ) {
    final dateService = DateManipulations();
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

        final initiatorKey = data![initiatorAID.substring(0, 4)];

        final decryptedKey = cipherService.decryptSymmetricKey(
          initiatorKey,
          keys.privateKey,
        );

        final messages =
            (messagesMap as Map<String, dynamic>).entries.map((entry) {
          return MessageDto.fromMap(entry.value as Map<String, dynamic>)
              .copyWith(
            isFromInitiator: initiatorAID == entry.value['sender'],
          );
        }).toList()
              ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

        if (messages.isNotEmpty) {
          final lastMessage = messages.last;
          return LastMessageEntity(
            message: cipherService.decryptMessage(
              lastMessage.message,
              base64Encode(decryptedKey),
            ),
            isFromInitiator: lastMessage.isFromInitiator!,
            dateTime: dateService.formatMessageDate(lastMessage.timestamp),
          );
        }
        return null;
      } else {
        return null;
      }
    });
  }

  Future<Map<String, dynamic>> getRemoteUserInfo(String AID) async {
    DocumentSnapshot snapshot =
        await fireStoreDB.collection('accounts').doc(AID).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        final bool urlStatus = data['urlStatus'];
        // final Map<String, dynamic> contactsData = data['contacts'];
        // final contacts = await getUsersFromRemoteDB(contactsData);

        return {
          'urlStatus': urlStatus,
          // 'contacts': contacts,
        };
      }
      return throw Exception('Data does not exist');
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<void> changeDataUrlStatus(String AID, bool newStatus) async {
    try {
      DocumentSnapshot snapshot =
          await fireStoreDB.collection('accounts').doc(AID).get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data == null) {
          throw Exception('Не удалось получить данные диалога');
        }

        await fireStoreDB.collection('accounts').doc(AID).update({
          'urlStatus': newStatus,
        });

        log('url-status changed successfully.');
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      log('Error adding new companion: $e');
      rethrow;
    }
  }

  Stream<List<UserDto>> getContactsStream(String AID) {
    return fireStoreDB
        .collection('accounts')
        .doc(AID)
        .snapshots()
        .asyncMap((snapshot) async {
      Map<String, dynamic>? data = snapshot.data();
      if (data != null && data.containsKey('contacts')) {
        Map<String, dynamic> contactsData = data['contacts'];

        if (contactsData.isEmpty) {
          return [];
        }

        return await getUsersFromRemoteDB(contactsData);
      } else {
        return [];
      }
    });
  }

  Future<List<UserDto>> getUsersFromRemoteDB(
      Map<String, dynamic> userMap) async {
    final List<Future<UserDto?>> futures = userMap.entries.map((entry) async {
      final String userID = entry.key;
      final String? localName = entry.value;

      try {
        DocumentSnapshot snapshot =
            await fireStoreDB.collection('accounts').doc(userID).get();
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data == null) return null;

        String avatarUrl = await _getAvatarUrl(userID);

        if (data.containsKey('publicKey')) {
          final Map<String, dynamic> publicKey = data['publicKey'];
          final ePub = BigInt.tryParse(publicKey['e'])!;
          final nPub = BigInt.tryParse(publicKey['n'])!;

          return UserDto(
            localName: localName,
            name: data['nickname'] ?? userID,
            imageUrl: avatarUrl,
            ePub: ePub,
            nPub: nPub,
            AID: userID,
          );
        } else {
          log('Public key missing for user $userID');
          return null;
        }
      } catch (e) {
        log('Error fetching user: $e');
        return null;
      }
    }).toList();

    final List<UserDto?> fetchedUsers = await Future.wait(futures);

    return fetchedUsers.whereType<UserDto>().toList();
  }

  Future<String> _getAvatarUrl(String userID) async {
    String defaultAvatarUrl =
        'https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg';

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('avatars/$userID.png');
      await storageRef.getMetadata();
      return await storageRef.getDownloadURL();
    } catch (e) {
      if ((e as FirebaseException).code == 'object-not-found') {
        log('No user image found for $userID');
        return defaultAvatarUrl;
      } else {
        log('Error fetching image: $e');
        return defaultAvatarUrl;
      }
    }
  }

  Future<String?> addNewCompanion(
      String AID, String newContact, String? localName) async {
    try {
      DocumentSnapshot userSnapshot =
          await fireStoreDB.collection('accounts').doc(AID).get();

      DocumentSnapshot addedUserSnapshot =
          await fireStoreDB.collection('accounts').doc(newContact).get();

      if (userSnapshot.exists && addedUserSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;
        Map<String, dynamic>? addedUserData =
            addedUserSnapshot.data() as Map<String, dynamic>?;

        if (userData == null || addedUserData == null) {
          throw Exception('Не удалось получить данные диалога');
        }

        if (addedUserData['urlStatus'] == false) {
          return 'Unable to add. User has disabled the public link.';
        }

        Map<String, dynamic>? userContacts =
            userData['contacts'] as Map<String, dynamic>? ?? {};
        Map<String, dynamic>? addedUserContacts =
            addedUserData['contacts'] as Map<String, dynamic>? ?? {};

        userContacts[newContact] = localName;
        addedUserContacts[AID] = null;

        await fireStoreDB.collection('accounts').doc(AID).update({
          'contacts': userContacts,
        });

        await fireStoreDB.collection('accounts').doc(newContact).update({
          'contacts': addedUserContacts,
        });

        log('Contact added successfully.');
        return null;
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      log('Error adding new companion: $e');
      rethrow;
    }
  }
}
