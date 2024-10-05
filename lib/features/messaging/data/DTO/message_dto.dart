// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDto {
  final String messageID;
  final String senderID;
  final String message;
  final DateTime timestamp;
  final bool? isFromInitiator;

  MessageDto({
    required this.messageID,
    required this.senderID,
    required this.message,
    required this.timestamp,
    this.isFromInitiator,
    
  });

  factory MessageDto.fromMap(Map<String, dynamic> map) {
    return MessageDto(
      messageID: map['id'] as String,
      senderID: map['sender'] as String,
      message: map['message'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': messageID,
      'sender': senderID,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  MessageDto copyWith({
    String? messageID,
    String? senderID,
    String? message,
    DateTime? timestamp,
    bool? isFromInitiator,
  }) {
    return MessageDto(
      messageID: messageID ?? this.messageID,
      senderID: senderID ?? this.senderID,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isFromInitiator: isFromInitiator ?? this.isFromInitiator,
    );
  }
}
