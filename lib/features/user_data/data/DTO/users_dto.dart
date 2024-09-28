// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserDto {
  final String AID;
  final String name;
  final String imageUrl;
   final String  publicKeyModulus;
  final String  publicKeyExponent;
  UserDto({
    required this.AID,
    required this.name,
    required this.imageUrl,
    required this.publicKeyModulus,
    required this.publicKeyExponent,
  });
}
