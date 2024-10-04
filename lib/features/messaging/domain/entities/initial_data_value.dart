// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pointycastle/api.dart';

class InitialDataValueEntity {
  final String initiatorAID;
  final String secondAID;
  final PublicKey firstPublicKey;
  final PrivateKey firstPrivateKey;
  final PublicKey secondPublicKey;
  InitialDataValueEntity({
    required this.initiatorAID,
    required this.secondAID,
    required this.firstPublicKey,
    required this.firstPrivateKey,
    required this.secondPublicKey,
  });
}
