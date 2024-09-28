// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:cryptome/features/messaging/data/datasources/remote/messaging_remote_repository.dart';
import 'package:cryptome/features/messaging/domain/repository/messaging_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: MessagingRepository)
class MessagingRepositoryImpl implements MessagingRepository {
  final MessagingRemoteRepository messagingRemoteRepository;
  MessagingRepositoryImpl({
    required this.messagingRemoteRepository,
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
      String fPublicKeyModulus,
      String fPublicKeyExponent,
      String sPublicKeyModulus,
      String sPublicKeyExponent) {
    return messagingRemoteRepository.startDialog(
        initiatorAID,
        secondAID,
        fPublicKeyModulus,
        fPublicKeyExponent,
        sPublicKeyModulus,
        sPublicKeyExponent);
  }
}
