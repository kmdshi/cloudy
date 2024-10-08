// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloudy/features/user_data/data/DTO/users_dto.dart';

class UserEntity {
  final String? localName;
  final String AID;
  final String username;
  final String urlAvatar;
  final BigInt nPub;
  final BigInt ePub;
  UserEntity(
      {required this.AID,
      required this.username,
      required this.urlAvatar,
      required this.nPub,
      required this.ePub,
      this.localName});

  factory UserEntity.mapDtoToEntity(UserDto dto) {
    return UserEntity(
      username: dto.name,
      localName: dto.localName,
      urlAvatar: dto.imageUrl,
      ePub: dto.ePub,
      nPub: dto.nPub,
      AID: dto.AID,
    );
  }
}
