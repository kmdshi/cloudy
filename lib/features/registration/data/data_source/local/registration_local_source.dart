// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cryptome/core/DI/dependency_config.dart';
import 'package:cryptome/core/services/cipher_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:basic_utils/basic_utils.dart';

@lazySingleton
class RegistrationLocalSource {
  final CipherService cipherService;
  RegistrationLocalSource({
    required this.cipherService,
  });

  Future<void> createSession(
    String nickname,
    List<String> keyPhrase,
  ) async {
    final prefs = getIt<SharedPreferences>();
    final String? data = prefs.getString('session_information');

    if (data != null && data.isNotEmpty) return;

    Map<String, dynamic> sessionInfo = {
      'created_at': DateTime.now().toIso8601String(),
      'is_loggined': true,
      'AID': cipherService.createAID(nickname, keyPhrase)
    };

    String sessionInfoString = jsonEncode(sessionInfo);

    await prefs.setString('session_information', sessionInfoString);
  }

  Future<Map<String, String>> createKeyPairs(
      String nickname, List<String> keyPhrase) async {
    final secureStorage = getIt<FlutterSecureStorage>();

    String? keyJson = await secureStorage.read(key: 'cipher_keys');

    if (keyJson != null) {
      return Map<String, String>.from(jsonDecode(keyJson));
    }

    final keyPair = cipherService.generateKeyPairFromSeed(nickname, keyPhrase);

    final publicKeyModulusBytes = CryptoUtils.rsaPublicKeyModulusToBytes(
        keyPair.publicKey as RSAPublicKey);
    final publicKeyExponentBytes = CryptoUtils.rsaPublicKeyExponentToBytes(
        keyPair.publicKey as RSAPublicKey);
    final privateKeyModulusBytes = CryptoUtils.rsaPrivateKeyModulusToBytes(
        keyPair.privateKey as RSAPrivateKey);
    final privateKeyExponentBytes = CryptoUtils.rsaPrivateKeyExponentToBytes(
        keyPair.privateKey as RSAPrivateKey);

    final publicKeyModulusBase64 = base64Encode(publicKeyModulusBytes);
    final publicKeyExponentBase64 = base64Encode(publicKeyExponentBytes);
    final privateKeyModulusBase64 = base64Encode(privateKeyModulusBytes);
    final privateKeyExponentBase64 = base64Encode(privateKeyExponentBytes);

    final keyPairMap = {
      'public_key_modulus': publicKeyModulusBase64,
      'public_key_exponent': publicKeyExponentBase64,
      'private_key_modulus': privateKeyModulusBase64,
      'private_key_exponent': privateKeyExponentBase64,
    };

    final keyPairJson = jsonEncode(keyPairMap);

    await secureStorage.write(key: 'cipher_keys', value: keyPairJson);

    return keyPairMap;
  }
}
