// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloudy/core/services/cipher_service.dart';
import 'package:cloudy/features/settings/data/datasource/local/settings_local_repository.dart';
import 'package:cloudy/features/settings/data/datasource/remote/settings_remote_repository.dart';
import 'package:cloudy/features/settings/domain/entity/user_self_entitiy.dart';
import 'package:cloudy/features/settings/domain/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteRepository settingsRemoteRepository;
  final SettingsLocalRepository settingsLocalRepository;
  final CipherService cipherService;
  SettingsRepositoryImpl({
    required this.settingsRemoteRepository,
    required this.settingsLocalRepository,
    required this.cipherService,
  });
  @override
  Future<UserSelfEntitiy> initialUserData() async {
    final localUserData = await settingsLocalRepository.handleLocalYourself();
    final remoteUserData = await settingsRemoteRepository
        .handleRemoteYourself(localUserData['sessionData']['userAID']);

    final userPubkey = cipherService.regeneratePublicKey({
      'n': localUserData['secureKeys']['nPub'],
      'e': localUserData['secureKeys']['ePub'],
    });

    final userPrivkey = cipherService.regeneratePrivateKey({
      'n': localUserData['secureKeys']['nPriv'],
      'd': localUserData['secureKeys']['dPriv'],
      'p': localUserData['secureKeys']['pPriv'],
      'q': localUserData['secureKeys']['qPriv'],
    });

    final userEntity = UserSelfEntitiy(
      nickname: remoteUserData['nickname'] as String,
      avatarUrl: remoteUserData['avatarUrl'] as String,
      userAID: localUserData['sessionData']['userAID'],
      isLoggined: localUserData['sessionData']['isLoggined'],
      urlStatus: remoteUserData['urlStatus'] as bool,
      publicKey: userPubkey,
      privateKey: userPrivkey,
    );

    return userEntity;
  }

  @override
  Future<String?> addContact(
      String AID, String contactAID, String? localName) async {
    return await settingsRemoteRepository.addNewCompanion(
        AID, contactAID, localName);
  }

  @override
  Future<void> changeUrlStatus(String AID, bool newStatus) async {
    await settingsRemoteRepository.changeUrlStatus(AID, newStatus);
  }
}
