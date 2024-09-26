import 'dart:convert';
import 'package:cryptome/core/DI/dependency_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingLocalRepo {
  Future<Map<String, dynamic>> getLocalUserData() async {
    final sharedPrefs = getIt<SharedPreferences>();
    final secureStorage = getIt<FlutterSecureStorage>();

    final userAID = await _getUserAID(sharedPrefs);
    final keysDetail = await _getSecureKeys(secureStorage);

    return {
      'AID': userAID,
      'keys': keysDetail,
    };
  }

  Future<String> _getUserAID(SharedPreferences sharedPrefs) async {
    final sessionInfoString = sharedPrefs.getString('session_information');
    final sessionInfo = jsonDecode(sessionInfoString!);

    return sessionInfo['AID'];
  }

  Future<Map<String, String>> _getSecureKeys(
      FlutterSecureStorage secureStorage) async {
    final keys = await secureStorage.read(key: 'cipher_keys');

    if (keys != null) {
      final keysDetail = jsonDecode(keys);

      return {
        'public_key_modulus': keysDetail['public_key_modulus'],
        'public_key_exponent': keysDetail['public_key_exponent'],
        'private_key_modulus': keysDetail['private_key_modulus'],
        'private_key_exponent': keysDetail['private_key_exponent'],
      };
    } else {
      throw Exception('Secure keys not found');
    }
  }
}
