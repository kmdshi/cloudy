// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloudy/features/messaging/data/DTO/message_dto.dart';

class MessageEntity {
  final String messageID;
  final String senderID;
  final String message;
  final DateTime timestamp;
  final bool isFromInitiator;

  MessageEntity({
    required this.messageID,
    required this.senderID,
    required this.message,
    required this.timestamp,
    required this.isFromInitiator,
  });

  factory MessageEntity.fromDto(MessageDto dto) {
    return MessageEntity(
      messageID: dto.messageID,
      senderID: dto.senderID,
      message: dto.message,
      timestamp: dto.timestamp,
      isFromInitiator: dto.isFromInitiator!,
    );
  }

  MessageEntity copyWith({
    String? messageID,
    String? senderID,
    String? message,
    DateTime? timestamp,
    bool? isFromInitiator,
    bool? isLastMessage,
  }) {
    return MessageEntity(
      messageID: messageID ?? this.messageID,
      senderID: senderID ?? this.senderID,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isFromInitiator: isFromInitiator ?? this.isFromInitiator,
    );
  }
}
