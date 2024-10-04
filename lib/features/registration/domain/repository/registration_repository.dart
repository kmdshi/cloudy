import 'package:cloudy/features/registration/domain/entities/person_entity.dart';

abstract class RegistrationRepository {
  Future<void> createPesron(PersonEntity personEntity);
}
