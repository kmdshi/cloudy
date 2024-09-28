// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserEntity {
  final String AID;
  final String username;
  final String urlAvatar;
  final String  publicKeyModulus;
  final String  publicKeyExponent;
  UserEntity({
    required this.AID,
    required this.username,
    required this.urlAvatar,
    required this.publicKeyModulus,
    required this.publicKeyExponent,
  });
}
