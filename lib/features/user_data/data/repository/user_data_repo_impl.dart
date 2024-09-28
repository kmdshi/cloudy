// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cryptome/features/user_data/data/DTO/users_dto.dart';
import 'package:cryptome/features/user_data/data/datasource/local_repository/user_data_local_repo.dart';
import 'package:cryptome/features/user_data/data/datasource/remote_repository/user_data_remote_repo.dart';
import 'package:cryptome/features/user_data/domain/entities/self_entity.dart';
import 'package:cryptome/features/user_data/domain/entities/user_entity.dart';
import 'package:cryptome/features/user_data/domain/repository/user_data_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserDataRepository)
class UserDataRepoImpl implements UserDataRepository {
  final UserDataLocalRepo messagingLocalRepo;
  final UserDataRemoteRepo messagingRemoteRepo;
  UserDataRepoImpl({
    required this.messagingLocalRepo,
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
        username: userDto.name,
        urlAvatar: userDto.imageUrl,
        publicKeyExponent: userDto.publicKeyExponent,
        publicKeyModulus: userDto.publicKeyModulus,
      );
    }).toList();

    final selfEntity = SelfEntity(
      keys: localData['keys'],
      AID: userAID,
      urlStatus: remoteData['urlStatus'],
      contacts: users,
    );

    return selfEntity;
  }
}
