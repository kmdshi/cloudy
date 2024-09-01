// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

class PersonEntity {
  final Uint8List? avatar;
  final String nickname;
  final String interests;
  final List<String> keyPhrase;
  PersonEntity({
    required this.avatar,
    required this.nickname,
    required this.interests,
    required this.keyPhrase,
  });

  PersonEntity copyWith({
    Uint8List? avatar,
    String? nickname,
    String? interests,
    List<String>? keyPhrase,
  }) {
    return PersonEntity(
      avatar: avatar ?? this.avatar,
      nickname: nickname ?? this.nickname,
      interests: interests ?? this.interests,
      keyPhrase: keyPhrase ?? this.keyPhrase, 
    );
  }
}
