// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessagingRemoteRepo {
  final FirebaseFirestore fireStoreDB;
  final FirebaseStorage firestorage;
  MessagingRemoteRepo({
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
        final List<String> contactsAIDs = data['contacts'];

        return {
          'urlStatus': urlStatus,
          'contactsAIDs': contactsAIDs,
        };
      }
      return throw Exception('Data does not exist');
    } else {
      throw Exception('Document does not exist');
    }
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
