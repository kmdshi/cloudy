import 'package:cloudy/features/user_data/domain/entities/self_entity.dart';

abstract class UserDataRepository {
  Future<SelfEntity> handleSelfEntity();
  // ignore: non_constant_identifier_names
  Future<void> addNewCompanion(String AID);
}
