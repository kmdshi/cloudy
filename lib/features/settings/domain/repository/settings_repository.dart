import 'package:cloudy/features/settings/domain/entity/user_self_entitiy.dart';

abstract class SettingsRepository {
  Future<UserSelfEntitiy> initialUserData();
  Future<String?> addContact(String AID, String contactAID, String? localName);
  Future<void> changeUrlStatus(String AID, bool newStatus);
}
