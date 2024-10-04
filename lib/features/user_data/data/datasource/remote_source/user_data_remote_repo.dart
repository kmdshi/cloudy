// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudy/features/user_data/data/DTO/users_dto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserDataRemoteRepo {
  final FirebaseFirestore fireStoreDB;
  final FirebaseStorage firestorage;
  UserDataRemoteRepo({
    required this.fireStoreDB,
    required this.firestorage,
  });

  Future<Map<String, dynamic>> getRemoteUserInfo(String AID) async {
    DocumentSnapshot snapshot =
        await fireStoreDB.collection('accounts').doc(AID).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        final bool urlStatus = data['urlStatus'];
        final List<dynamic> contactsAIDs = data['contacts'];
        final contacts = await getUsersFromRemoteDB(contactsAIDs);

        return {
          'urlStatus': urlStatus,
          'contacts': contacts,
        };
      }
      return throw Exception('Data does not exist');
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<List<UserDto>> getUsersFromRemoteDB(List<dynamic> userIds) async {
    final List<Future<UserDto?>> futures = userIds.map((userID) async {
      try {
        DocumentSnapshot snapshot = await fireStoreDB
            .collection('accounts')
            .doc(userID as String)
            .get();
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data == null) return null;

        String avatarUrl =
            'https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg';

        try {
          final storageRef =
              FirebaseStorage.instance.ref().child('avatars/$userID.png');

          await storageRef.getMetadata();

          avatarUrl = await storageRef.getDownloadURL();
        } catch (e) {
          (e as FirebaseException).code == 'object-not-found'
              ? log('no user image found')
              : log('Error fetching image: $e');
        }

        return UserDto(
          name: data['name'] ?? userID,
          imageUrl: avatarUrl,
          ePub: BigInt.parse(data['publicKey']['e']),
          nPub: BigInt.parse(data['publicKey']['n']),
          AID: userID,
        );
      } catch (e) {
        log('Error fetching user: $e');
        return null;
      }
    }).toList();

    final List<UserDto?> fetchedUsers = await Future.wait(futures);

    return fetchedUsers.whereType<UserDto>().toList();
  }

  Future<void> addNewCompanion(String AID, String newContact) async {
    try {
      DocumentSnapshot snapshot =
          await fireStoreDB.collection('accounts').doc(AID).get();

      if (snapshot.exists) {
        await fireStoreDB.collection('accounts').doc(AID).update({
          'contacts': FieldValue.arrayUnion([newContact]),
        });
        log('Contact added successfully.');
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      log('Error adding new companion: $e');
    }
  }
}
