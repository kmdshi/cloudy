import 'dart:convert';

import 'package:cloudy/core/DI/dependency_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MessagingLocalRepository {
  Future<Map<String, BigInt>> getSecureKeys() async {
    final secureStorage = getIt<FlutterSecureStorage>();

    final keys = await secureStorage.read(key: 'cipher_keys');

    if (keys != null) {
      final keysDetail = jsonDecode(keys);

      return {
        'nPub': BigInt.parse(keysDetail['publicKey']['n']),
        'ePub': BigInt.parse(keysDetail['publicKey']['e']),
        'nPriv': BigInt.parse(keysDetail['privateKey']['n']),
        'dPriv': BigInt.parse(keysDetail['privateKey']['d']),
        'pPriv': BigInt.parse(keysDetail['privateKey']['p']),
        'qPriv': BigInt.parse(keysDetail['privateKey']['q']),
      };
    } else {
      throw Exception('Secure keys not found');
    }
  }
}
