// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:cryptome/features/messaging/domain/entities/user_entity.dart';

class SelfEnпtity {
  final Map<String, String> keys;
  final String AID;
  final bool urlStatus;
  final List<UserEntity> usersEntity;
  SelfEntity({
    required this.keys,
    required this.AID,
    required this.urlStatus,
    required this.usersEntity,
  });

 

  SelfEntity copyWith({
    Map<String, String>? keys,
    String? AID,
    bool? urlStatus,
    List<UserEntity>? usersEntity,
  }) {
    return SelfEntity(
      keys: keys ?? this.keys,
      AID: AID ?? this.AID,
      urlStatus: urlStatus ?? this.urlStatus,
      usersEntity: usersEntity ?? this.usersEntity,
    );
  }
}
