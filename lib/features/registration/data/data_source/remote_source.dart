// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptome/core/services/cipher_service.dart';
import 'package:cryptome/features/registration/domain/entities/person_entity.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RegistrationRemoteSource {
  final FirebaseFirestore fireStoreDB;
  final CipherService cipherService;
  RegistrationRemoteSource({
    required this.fireStoreDB,
    required this.cipherService,
  });

  // ignore: non_constant_identifier_names
  Future<void> addPerson(PersonEntity personEntity) async {
    // ignore: non_constant_identifier_names
    final AID =
        cipherService.createAID(personEntity.nickname, personEntity.keyPhrase);
    DocumentReference<Map<String, dynamic>> documentReference =
        fireStoreDB.collection('accounts').doc(AID);

    Map<String, dynamic> data = personEntity.toMap();

    await documentReference.set(data);
  }
}
