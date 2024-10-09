// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloudy/core/DI/dependency_config.dart';
import 'package:cloudy/core/services/cipher_service.dart';
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

  Future<Map<String, dynamic>> createKeyPairs(
      String nickname, List<String> keyPhrase) async {
    final secureStorage = getIt<FlutterSecureStorage>();

    String? keyJson = await secureStorage.read(key: 'cipher_keys');

    if (keyJson != null) {
      return Map<String, dynamic>.from(jsonDecode(keyJson));
    }

    final keyPair = await cipherService.createKeyPair(nickname, keyPhrase);

    final RSAPublicKey publicKey = keyPair.publicKey as RSAPublicKey;
    final RSAPrivateKey privateKey = keyPair.privateKey as RSAPrivateKey;

    final keyPairMap = {
      'publicKey': {
        'n': publicKey.n.toString(),
        'e': publicKey.publicExponent.toString(),
      },
      'privateKey': {
        'n': privateKey.modulus.toString(),
        'd': privateKey.privateExponent.toString(),
        'p': privateKey.p.toString(),
        'q': privateKey.q.toString(),
      },
    };

    final keyPairJson = jsonEncode(keyPairMap);

    await secureStorage.write(key: 'cipher_keys', value: keyPairJson);

    return keyPairMap;
  }
}
