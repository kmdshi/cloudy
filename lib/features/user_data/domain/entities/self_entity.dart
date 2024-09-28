// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:cryptome/features/user_data/domain/entities/user_entity.dart';

class SelfEntity {
  final Map<String, String> keys;
  final String AID;
  final bool urlStatus;
  final List<UserEntity> contacts;

  SelfEntity({
    required this.keys,
    required this.AID,
    required this.urlStatus,
    required this.contacts,
  });

  SelfEntity copyWith({
    Map<String, String>? keys,
    String? AID,
    bool? urlStatus,
    List<UserEntity>? contacts,
  }) {
    return SelfEntity(
      keys: keys ?? this.keys,
      AID: AID ?? this.AID,
      urlStatus: urlStatus ?? this.urlStatus,
      contacts: contacts ?? this.contacts,
    );
  }
}
