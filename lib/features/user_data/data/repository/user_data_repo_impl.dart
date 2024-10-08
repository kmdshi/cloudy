// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/features/user_data/data/DTO/users_dto.dart';
import 'package:cloudy/features/user_data/data/datasource/local_source/user_data_local_repo.dart';
import 'package:cloudy/features/user_data/data/datasource/remote_source/user_data_remote_repo.dart';
import 'package:cloudy/features/user_data/domain/entities/last_message_entity.dart';
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
  Future<String?> addNewCompanion(
      String AID, String newContact, String? localName) async {
    return await messagingRemoteRepo.addNewCompanion(
        AID, newContact, localName);
  }

  @override
  Future<SelfEntity> handleSelfEntity() async {
    final localData = await messagingLocalRepo.getLocalUserData();
    final userAID = localData['AID'];
    final remoteData = await messagingRemoteRepo.getRemoteUserInfo(userAID);

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
      // contacts: users,
    );

    return selfEntity;
  }

  @override
  Future<Stream<LastMessageEntity?>> getLastMessageStream(
      String initiatorAID, String secondAID) async {
    final localData = await messagingLocalRepo.getLocalUserData();

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
    return messagingRemoteRepo.getLastMessageStream(
      initiatorAID,
      secondAID,
      keys,
    );
  }

  @override
  Future<Stream<List<UserEntity>?>> getContactsStream(String AID) async {
    return messagingRemoteRepo.getContactsStream(AID).map((userDtos) {
      return userDtos.map((userDto) => mapDtoToEntity(userDto)).toList();
    });
  }

  UserEntity mapDtoToEntity(UserDto dto) {
    return UserEntity(
      username: dto.name,
      localName: dto.localName,
      urlAvatar: dto.imageUrl,
      ePub: dto.ePub,
      nPub: dto.nPub,
      AID: dto.AID,
    );
  }
  
  @override
  Future<void> changeDataUrlStatus(String AID, bool newStatus) async {
  await messagingRemoteRepo.changeDataUrlStatus(AID, newStatus);
  }
}
