import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/digests/sha256.dart';
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

  AsymmetricKeyPair<PublicKey, PrivateKey> generateKeyPairFromSeed(
      String nickname, List<String> keyPhrase) {
    final seed = _createSeed(nickname, keyPhrase);
    final keyPair = _generateRSAKeyPair(seed);
    return keyPair;
  }

  Uint8List _createSeed(String nickname, List<String> keyPhrase) {
    final input = nickname + keyPhrase.join();
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return Uint8List.fromList(digest.bytes);
  }

  AsymmetricKeyPair<PublicKey, PrivateKey> _generateRSAKeyPair(Uint8List seed) {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 5),
        _secureRandom(seed),
      ));
    return keyGen.generateKeyPair();
  }

  SecureRandom _secureRandom(Uint8List seed) {
    final secureRandom = FortunaRandom();
    secureRandom.seed(KeyParameter(seed));
    return secureRandom;
  }

  String encryptWithPublicKey(String data, PublicKey publicKey) {
    final encryptor = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    final encrypted = _processInBlocks(encryptor, utf8.encode(data));
    return base64.encode(encrypted);
  }

  String decryptWithPrivateKey(String base64Data, PrivateKey privateKey) {
    final decryptor = RSAEngine()
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final encryptedBytes = base64.decode(base64Data);
    final decrypted = _processInBlocks(decryptor, encryptedBytes);
    return utf8.decode(decrypted);
  }

  Uint8List _processInBlocks(RSAEngine engine, Uint8List input) {
    final maxBlockSize = engine.inputBlockSize;
    final output = BytesBuilder();
    for (var offset = 0; offset < input.length; offset += maxBlockSize) {
      final end = (offset + maxBlockSize < input.length)
          ? offset + maxBlockSize
          : input.length;
      output
          .add(engine.process(Uint8List.fromList(input.sublist(offset, end))));
    }
    return output.toBytes();
  }

  Uint8List generateSalt([int length = 16]) {
    final random = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(length, (_) => random.nextInt(256)));
  }

  Uint8List generateSymmetricKey({int keyLength = 32}) {
    final salt = generateSalt();
    final digest = SHA256Digest();
    final hashedSalt = digest.process(salt);

    return Uint8List.fromList(hashedSalt.take(keyLength).toList());
  }

  Uint8List encryptDialogKeyWithPublicUserKey(
      Uint8List symmetricKey, String base64Modulus, String base64Exponent) {
    Uint8List modulusBytes = base64.decode(base64Modulus);
    Uint8List exponentBytes = base64.decode(base64Exponent);

    BigInt modulus = BigInt.parse(
        modulusBytes.map((byte) => byte.toRadixString(16)).join(),
        radix: 16);
    BigInt exponent = BigInt.parse(
        exponentBytes.map((byte) => byte.toRadixString(16)).join(),
        radix: 16);

    final rsaPublicKey = RSAPublicKey(modulus, exponent);

    final encryptor = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));

    return encryptor.process(symmetricKey);
  }
}
