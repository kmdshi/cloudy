// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptome/core/services/cipher_service.dart';
import 'package:cryptome/features/registration/domain/entities/person_entity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RegistrationRemoteSource {
  final FirebaseFirestore fireStoreDB;
  final FirebaseStorage firestorage;
  final CipherService cipherService;
  RegistrationRemoteSource({
    required this.fireStoreDB,
    required this.cipherService,
    required this.firestorage,
  });

  Future<void> addPerson(
    PersonEntity personEntity,
    Map<String, String> keys,
  ) async {
    final AID =
        cipherService.createAID(personEntity.nickname, personEntity.keyPhrase);
    DocumentReference<Map<String, dynamic>> documentReference =
        fireStoreDB.collection('accounts').doc(AID);

    Map<String, dynamic> data = personEntity.toMap();

    data['public_key_modulus'] = keys['public_key_modulus'];
    data['public_key_exponent'] = keys['public_key_exponent'];

    if (personEntity.avatar != null) {
      await uploadAvatar(personEntity.avatar!, AID);
    }

    await documentReference.set(data);
  }

  Future<String> uploadAvatar(Uint8List avatarBytes, String AID) async {
    final storageRef = FirebaseStorage.instance.ref().child('avatars/$AID.png');

    await storageRef.putData(avatarBytes);

    final avatarUrl = await storageRef.getDownloadURL();

    return avatarUrl;
  }
}
