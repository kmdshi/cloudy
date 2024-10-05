// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloudy/features/user_data/domain/entities/last_message_entity.dart';

class UserEntity {
  final String AID;
  final String username;
  final String urlAvatar;
  final LastMessageEntity? lastMessage;
  final BigInt nPub;
  final BigInt ePub;
  UserEntity({
    required this.AID,
    required this.username,
    required this.urlAvatar,
    required this.nPub,
    required this.ePub,
    this.lastMessage,
  });
}
