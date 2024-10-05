import 'dart:convert';
import 'package:cloudy/core/DI/dependency_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class UserDataLocalRepo {
  Future<Map<String, dynamic>> getLocalUserData() async {
    final sharedPrefs = getIt<SharedPreferences>();
    final secureStorage = getIt<FlutterSecureStorage>();

    final userAID = _getUserAID(sharedPrefs);
    final keysDetail = await _getSecureKeys(secureStorage);

    return {
      'AID': userAID,
      'keys': keysDetail,
    };
  }

  String _getUserAID(SharedPreferences sharedPrefs) {
    final sessionInfoString = sharedPrefs.getString('session_information');
    final sessionInfo = jsonDecode(sessionInfoString!);

    return sessionInfo['AID'];
  }

  Future<Map<String, BigInt>> _getSecureKeys(
      FlutterSecureStorage secureStorage) async {
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
