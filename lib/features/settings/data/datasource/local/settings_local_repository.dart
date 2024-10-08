// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SettingsLocalRepository {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  SettingsLocalRepository({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  Future<Map<String, dynamic>> handleLocalYourself() async {
    final sessionData = _getUserSessionData(sharedPreferences);
    final securekeys = await _getSecureKeys(secureStorage);

    return {
      'sessionData': sessionData,
      'secureKeys': securekeys,
    };
  }

  Map<String, dynamic> _getUserSessionData(SharedPreferences sharedPrefs) {
    final sessionInfoString = sharedPrefs.getString('session_information');
    final sessionInfo = jsonDecode(sessionInfoString!);

    return {
      'userAID': sessionInfo['AID'],
      'isLoggined': sessionInfo['is_loggined'],
    };
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
