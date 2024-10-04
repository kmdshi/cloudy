import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';

class CipherService {
  String createAID(String nickname, List<String> keyPhrase) {
    String input = nickname + keyPhrase.join();

    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);

    return digest.toString();
  }

  // OTHER FOR ENCRYPTION

  RSAPrivateKey regeneratePrivateKey(Map<String, dynamic> keyParams) {
    final n = keyParams['n'];
    final d = keyParams['d'];
    final p = keyParams['p'];
    final q = keyParams['q'];

    return RSAPrivateKey(n, d, p, q);
  }

  RSAPublicKey regeneratePublicKey(Map<String, dynamic> keyParams) {
    final n = keyParams['n'];
    final e = keyParams['e'];

    return RSAPublicKey(n, e);
  }

  Uint8List _createSeed(String nickname, List<String> keyPhrase) {
    final input = nickname + keyPhrase.join();
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return Uint8List.fromList(digest.bytes);
  }

  SecureRandom _secureRandomFromSeed(Uint8List seed) {
    final secureRandom = FortunaRandom();
    final seedKey = KeyParameter(seed);
    secureRandom.seed(seedKey);
    return secureRandom;
  }

  Uint8List _processInBlocks(RSAEngine engine, Uint8List input) {
    final output = <int>[];
    for (var offset = 0; offset < input.length;) {
      final chunkSize = engine.inputBlockSize;
      final end = (offset + chunkSize < input.length)
          ? offset + chunkSize
          : input.length;
      output.addAll(engine.process(Uint8List.sublistView(input, offset, end)));
      offset = end;
    }
    return Uint8List.fromList(output);
  }

  Uint8List generateSalt([int length = 16]) {
    final random = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(length, (_) => random.nextInt(256)));
  }

  // OPERTAIONS WITH KEYS

  Future<AsymmetricKeyPair<PublicKey, PrivateKey>> createKeyPair(
      String nickname, List<String> keyPhrase) async {
    final seed = _createSeed(nickname, keyPhrase);
    final secureRandom = _secureRandomFromSeed(seed);

    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
          secureRandom));

    final keys = keyGen.generateKeyPair();

    return keys;
  }

  String generateRandomAESKey() {
    final keyBytes = Uint8List(32);
    final random = Random.secure();
    for (int i = 0; i < keyBytes.length; i++) {
      keyBytes[i] = random.nextInt(256);
    }
    return base64Encode(keyBytes);
  }

  // ENCRYPT / DECRYPT

  Uint8List decryptSymmetricKey(
      String encryptedSymmetrcKey, PrivateKey privateKey) {
    final symmetricKeyBytes = base64Decode(encryptedSymmetrcKey);

    final decryptor = RSAEngine()
      ..init(false,
          PrivateKeyParameter<RSAPrivateKey>(privateKey as RSAPrivateKey));

    final decryptedSymmetricKey =
        _processInBlocks(decryptor, symmetricKeyBytes);

    return decryptedSymmetricKey;
  }

  String encryptSymmetricKey(String symmetricKey, PublicKey publicKey) {
    final symmetricKeyBytes = base64Decode(symmetricKey);

    final encryptor = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey as RSAPublicKey));

    final encrypted = _processInBlocks(encryptor, symmetricKeyBytes);

    return base64Encode(encrypted);
  }

  String encryptMessage(String plainText, encrypt.IV iv, String symmetricKey) {
    final key = encrypt.Key.fromBase64(symmetricKey);

    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    return encrypted.base64;
  }

  String decryptMessage(
      String encryptedText, encrypt.IV iv, String symmetricKey) {
    final key = encrypt.Key.fromBase64(symmetricKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);

    return decrypted;
  }

  // Uint8List decryptWithPrivateKey(
  //   String base64Data,
  //   PrivateKey privateKey,
  // ) {
  //   // final privateKey = createPrivateKeyFromModulusAndExponent(
  //   //     base64Modulus, base64PrivateExponent, p, q);

  //   final decryptor = RSAEngine()
  //     ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

  //   final encryptedBytes = base64.decode(base64Data);

  //   final decrypted = _processInBlocks(decryptor, encryptedBytes);

  //   // final symmetricKey = _removePKCS1Padding(decrypted);

  //   return decrypted;
  // }

  // RSAPrivateKey createPrivateKeyFromModulusAndExponent(
  //   String base64Modulus,
  //   String base64PrivateExponent,
  //   String p,
  //   String q,
  // ) {
  //   Uint8List modulusBytes = base64.decode(base64Modulus);
  //   Uint8List privateExponentBytes = base64.decode(base64PrivateExponent);

  //   BigInt modulus = BigInt.parse(
  //     modulusBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(),
  //     radix: 16,
  //   );
  //   BigInt privateExponent = BigInt.parse(
  //     privateExponentBytes
  //         .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
  //         .join(),
  //     radix: 16,
  //   );

  //   final privateKey = RSAPrivateKey(
  //     modulus,
  //     privateExponent,
  //     BigInt.parse(p),
  //     BigInt.parse(q),
  //   );

  //   return privateKey;
  // }

  // Uint8List _removePKCS1Padding(Uint8List data) {
  //   int index = data.indexWhere((byte) => byte == 0x00, 2);
  //   if (index == -1) {
  //     throw Exception('Invalid PKCS#1 padding.');
  //   }
  //   return data.sublist(index + 1);
  // }
}
