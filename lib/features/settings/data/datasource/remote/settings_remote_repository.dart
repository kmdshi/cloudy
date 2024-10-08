// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SettingsRemoteRepository {
  final FirebaseFirestore fireStoreDB;
  final FirebaseStorage firestorage;
  SettingsRemoteRepository({
    required this.fireStoreDB,
    required this.firestorage,
  });

  Future<Map<String, Object?>> handleRemoteYourself(String AID) async {
    DocumentSnapshot snapshot =
        await fireStoreDB.collection('accounts').doc(AID).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        final String? nickname = data['nickname'] ?? '';
        final bool urlStatus = data['urlStatus'];

        String avatarUrl =
            'https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg';

        try {
          final storageRef =
              FirebaseStorage.instance.ref().child('avatars/$AID.png');

          await storageRef.getMetadata();

          avatarUrl = await storageRef.getDownloadURL();
        } catch (e) {
          (e as FirebaseException).code == 'object-not-found'
              ? log('no user image found')
              : log('Error fetching image: $e');
        }

        return {
          'nickname': nickname,
          'urlStatus': urlStatus,
          'avatarUrl': avatarUrl,
        };
      }
      return throw ('No data in firebase');
    }
    return throw ('no snapshot in firebase');
  }

  Future<void> changeUrlStatus(String AID, bool newStatus) async {
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
