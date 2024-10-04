// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/features/user_data/data/DTO/users_dto.dart';
import 'package:cloudy/features/user_data/data/datasource/local_source/user_data_local_repo.dart';
import 'package:cloudy/features/user_data/data/datasource/remote_source/user_data_remote_repo.dart';
import 'package:cloudy/features/user_data/domain/entities/self_entity.dart';
import 'package:cloudy/features/user_data/domain/entities/user_entity.dart';
import 'package:cloudy/features/user_data/domain/repository/user_data_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:pointycastle/api.dart';

@LazySingleton(as: UserDataRepository)
class UserDataRepoImpl implements UserDataRepository {
  final UserDataLocalRepo messagingLocalRepo;
  final UserDataRemoteRepo messagingRemoteRepo;
  final CipherService cipherService;
  UserDataRepoImpl({
    required this.messagingLocalRepo,
    required this.cipherService,
    required this.messagingRemoteRepo,
  });

  @override
  Future<void> addNewCompanion(String AID) {
    throw UnimplementedError();
  }

  @override
  Future<SelfEntity> handleSelfEntity() async {
    final localData = await messagingLocalRepo.getLocalUserData();
    final userAID = localData['AID'];
    final remoteData = await messagingRemoteRepo.getRemoteUserInfo(userAID);

    final usersDTO = remoteData['contacts'];
    final List<UserEntity> users = (usersDTO as List<dynamic>).map((dto) {
      final userDto = dto as UserDto;
      return UserEntity(
        AID: dto.AID,
        urlAvatar: dto.imageUrl,
        username: userDto.name,
        nPub: dto.nPub,
        ePub: dto.ePub,
      );
    }).toList();

    final selfPublicKey = cipherService.regeneratePublicKey({
      'n': localData['keys']['nPub'],
      'e': localData['keys']['nPub'],
    });
    final selfPrivateKey = cipherService.regeneratePrivateKey({
      'n': localData['keys']['nPriv'],
      'd': localData['keys']['dPriv'],
      'p': localData['keys']['pPriv'],
      'q': localData['keys']['qPriv'],
    });

    final AsymmetricKeyPair<PublicKey, PrivateKey> keys =
        AsymmetricKeyPair(selfPublicKey, selfPrivateKey);

    final selfEntity = SelfEntity(
      keys: keys,
      AID: userAID,
      urlStatus: remoteData['urlStatus'],
      contacts: users,
    );

    return selfEntity;
  }
}
