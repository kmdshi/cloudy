// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserDto {
  final String? localName;
  final String AID;
  final String name;
  final String imageUrl;
  final BigInt nPub;
  final BigInt ePub;
  UserDto({
    required this.AID,
    required this.name,
    required this.imageUrl,
    required this.nPub,
    required this.ePub,
    this.localName,
  });
}
