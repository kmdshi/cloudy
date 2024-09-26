// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cryptome/features/messaging/data/datasource/local_repository/messaging_local_repo.dart';
import 'package:cryptome/features/messaging/data/datasource/remote_repository/messaging_remote_repo.dart';
import 'package:cryptome/features/messaging/domain/entities/self_entity.dart';
import 'package:cryptome/features/messaging/domain/repository/messaging_repository.dart';

class MessagingRepoImpl implements MessagingRepository {
  final MessagingLocalRepo messagingLocalRepo;
  final MessagingRemoteRepo messagingRemoteRepo;
  MessagingRepoImpl({
    required this.messagingLocalRepo,
    required this.messagingRemoteRepo,
  });

  @override
  Future<void> addNewCompanion(String AID) {
    throw UnimplementedError();
  }

  @override
  Future<SelfEntity> handleSelfEntity(String AID) async {
    final localData = await messagingLocalRepo.getLocalUserData();
    final remoteData = await messagingRemoteRepo.getRemoteUserInfo(AID);

    final selfEntity = SelfEntity(
      keys: localData['keys'],
      AID: localData['AID'],
      urlStatus: remoteData['urlStatus'],
      usersEntity: remoteData['contactsAIDs'],
    );
    
    return selfEntity;
  }
}
