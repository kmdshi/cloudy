// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pointycastle/pointycastle.dart';

class UserSelfEntitiy {
  final String nickname;
  final bool urlStatus;
  final String avatarUrl;
  final String userAID;
  final bool isLoggined;
  final RSAPublicKey publicKey;
  final RSAPrivateKey privateKey;
  UserSelfEntitiy({
    required this.nickname,
    required this.urlStatus,
    required this.avatarUrl,
    required this.userAID,
    required this.isLoggined,
    required this.publicKey,
    required this.privateKey,
  });

  UserSelfEntitiy copyWith({
    String? nickname,
    bool? urlStatus,
    String? avatarUrl,
    String? userAID,
    bool? isLoggined,
    RSAPublicKey? publicKey,
    RSAPrivateKey? privateKey,
  }) {
    return UserSelfEntitiy(
      nickname: nickname ?? this.nickname,
      urlStatus: urlStatus ?? this.urlStatus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userAID: userAID ?? this.userAID,
      isLoggined: isLoggined ?? this.isLoggined,
      publicKey: publicKey ?? this.publicKey,
      privateKey: privateKey ?? this.privateKey,
    );
  }
}
