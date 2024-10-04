// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/features/messaging/data/datasources/local/messaging_local_repository.dart';
import 'package:cloudy/features/messaging/data/datasources/remote/messaging_remote_repository.dart';
import 'package:cloudy/features/messaging/domain/repository/messaging_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/api.dart';

@LazySingleton(as: MessagingRepository)
class MessagingRepositoryImpl implements MessagingRepository {
  final MessagingRemoteRepository messagingRemoteRepository;
  final MessagingLocalRepository messagingLocalRepository;
  final CipherService cipherService;
  MessagingRepositoryImpl({
    required this.messagingRemoteRepository,
    required this.messagingLocalRepository,
    required this.cipherService,
  });
  @override
  Stream<Map<String, dynamic>> getMessagesStream(
      String initiatorAID, String secondAID) {
    return messagingRemoteRepository.getMessagesStream(initiatorAID, secondAID);
  }

  @override
  Future<void> sendMessage(String message, Uint8List dialogKey,
      String initiatorAID, String secondAID) async {
    messagingRemoteRepository.sendMessage(
        message, dialogKey, initiatorAID, secondAID);
  }

  @override
  Future<Uint8List> startDialog(
    String initiatorAID,
    String secondAID,
    PublicKey secondPublicKey,
  ) async {
    final keys = await messagingLocalRepository.getSecureKeys();

    final selfPublicKey = cipherService.regeneratePublicKey({
      'n': keys['nPub'],
      'e': keys['ePub'],
    });
    final selfPrivateKey = cipherService.regeneratePrivateKey({
      'n': keys['nPriv'],
      'd': keys['dPriv'],
      'p': keys['pPriv'],
      'q': keys['qPriv'],
    });

    return messagingRemoteRepository.startDialog(
      initiatorAID,
      secondAID,
      selfPublicKey,
      selfPrivateKey,
      secondPublicKey,
    );
  }
}
