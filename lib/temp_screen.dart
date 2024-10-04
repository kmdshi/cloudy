import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/features/user_data/data/datasource/remote_source/user_data_remote_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'features/user_data/data/datasource/local_repository/user_data_local_repo.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({super.key});

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  late AsymmetricKeyPair<PublicKey, PrivateKey> keyPair;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final FirebaseFirestore fireStoreDB = FirebaseFirestore.instance;
  final FirebaseStorage fireStorage = FirebaseStorage.instance;
  final TextEditingController controller = TextEditingController();

  final UserDataLocalRepo userDataLocalRepo = UserDataLocalRepo();

  String AID = '';
  String publicKey = '';
  String encryptedData = 'Enter your data to encrypt here';
  String decryptedData = 'Nothing yet';
  String verificationResult = '';
  String encryptedSymmetrcKey = '';
  String decryptedSymmetricKey = '';
  String publicKeyFromRemote = '';
  String generatedSymKey = '';
  late RSAPublicKey regeneratedPublicKey;
  @override
  void initState() {
    super.initState();
    loadKeysFromLocal();
    loadKeysFromRemote();
  }

  Future<void> loadKeysFromRemote() async {
    final localData = await userDataLocalRepo.getLocalUserData();

    DocumentSnapshot snapshot =
        await fireStoreDB.collection('accounts').doc(localData['AID']).get();

    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        final publicKeyFromRemote = data['publicKey'];

        final BigInt nKey = BigInt.parse(publicKeyFromRemote['n']);
        final BigInt eKey = BigInt.parse(publicKeyFromRemote['e']);

        final generatedKey =
            CipherService().regeneratePublicKey({'n': nKey, 'e': eKey});

        regeneratedPublicKey = generatedKey;
      }
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<void> loadKeysFromLocal() async {
    final localData = await userDataLocalRepo.getLocalUserData();

    final regeneratedPublicKey = CipherService().regeneratePublicKey(
        {'n': localData['keys']['nPub'], 'e': localData['keys']['ePub']});

    final usAID = localData['AID'];

    final regeneratedPrivateKey = CipherService().regeneratePrivateKey({
      'n': localData['keys']['nPriv'],
      'd': localData['keys']['dPriv'],
      'p': localData['keys']['pPriv'],
      'q': localData['keys']['qPriv'],
    });

    setState(() {
      keyPair = AsymmetricKeyPair(regeneratedPublicKey, regeneratedPrivateKey);
      AID = usAID;
      publicKey =
          'n: ${regeneratedPublicKey.n}, e: ${regeneratedPublicKey.publicExponent}';
    });
  }

  Future<void> generateSymKey() async {
    final symkey = CipherService().generateRandomAESKey();
    setState(() {
      generatedSymKey = symkey;
    });
  }

  Future<void> verifyKeyPair() async {
    setState(() {
      final publicKeysMatch =
          (keyPair.publicKey as RSAPublicKey) == regeneratedPublicKey;

      verificationResult =
          publicKeysMatch ? 'Keys match!' : 'Keys do not match!';
    });
  }

  Future<void> encryptSymkeyByPublic() async {
    final encryptedKey = CipherService()
        .encryptSymmetricKey(generatedSymKey, regeneratedPublicKey);

    setState(() {
      encryptedSymmetrcKey = encryptedKey;
    });
  }

  Future<void> decryptSymkeyByPublic() async {
    final encryptedKey = CipherService()
        .decryptSymmetricKey(encryptedSymmetrcKey, keyPair.privateKey);

    setState(() {
      decryptedSymmetricKey = base64Encode(encryptedKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),

            Text('Public Key: $publicKey'),
            TextField(controller: controller),
            // ElevatedButton(
            //   onPressed: () => encryptMessage(
            //       controller.text, IV.fromUtf8('1234567890123456')),
            //   child: const Text('Encrypt Data'),
            // ),
            Text('Encrypted Data: $encryptedData'),
            // ElevatedButton(
            //   onPressed: () => decryptMessage(
            //       encryptedData, IV.fromUtf8('1234567890123456')),
            //   child: const Text('Decrypt Data'),
            // ),
            Text('Decrypted Data: $decryptedData'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyKeyPair,
              child: const Text('Verify Key Pair'),
            ),
            Text('Verification Result: $verificationResult'),

            Text('Generated symmetric Key: $generatedSymKey'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateSymKey,
              child: const Text('Genetrate symmetric key'),
            ),
            Text('Decrypted Symmetric Key: $decryptedSymmetricKey'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: decryptSymkeyByPublic,
              child: const Text('Decrypt symmetric key'),
            ),
            Text('Encrypted Symmetric Key: $encryptedSymmetrcKey'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: encryptSymkeyByPublic,
              child: const Text('Encrypt symmetric key'),
            ),
          ],
        ),
      ),
    );
  }
}
