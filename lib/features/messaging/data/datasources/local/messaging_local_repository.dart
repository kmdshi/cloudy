import 'dart:convert';

import 'package:cryptome/core/DI/dependency_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MessagingLocalRepository {
  Future<Map<String, String>> getSecureKeys() async {
    final secureStorage = getIt<FlutterSecureStorage>();

    final keys = await secureStorage.read(key: 'cipher_keys');

    if (keys != null) {
      final keysDetail = jsonDecode(keys);

      return {
        'public_key_modulus': keysDetail['public_key_modulus'],
        'public_key_exponent': keysDetail['public_key_exponent'],
        'private_key_modulus': keysDetail['private_key_modulus'],
        'private_key_exponent': keysDetail['private_key_exponent'],
        'p': keysDetail['p'],
        'q': keysDetail['q'],
      };
    } else {
      throw Exception('Secure keys not found');
    }
  }
}
