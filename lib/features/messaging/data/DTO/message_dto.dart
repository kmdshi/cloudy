import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDto {
  final String messageID;
  final String senderID;
  final String message;
  final DateTime timestamp;

  MessageDto({
    required this.messageID,
    required this.senderID,
    required this.message,
    required this.timestamp,
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
}
