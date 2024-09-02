// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cryptome/features/registration/data/data_source/local_source.dart';
import 'package:cryptome/features/registration/data/data_source/remote_source.dart';
import 'package:cryptome/features/registration/domain/entities/person_entity.dart';
import 'package:cryptome/features/registration/domain/repository/registration_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RegistrationRepository)
class RegistrationRepositoryImpl implements RegistrationRepository {
  RegistrationLocalSource registrationLocalSource;
  RegistrationRemoteSource registrationRemoteSource;
  RegistrationRepositoryImpl({
    required this.registrationLocalSource,
    required this.registrationRemoteSource,
  });
  @override
  Future<void> createPesron(PersonEntity personEntity) async {
    await registrationLocalSource.createSession(
        personEntity.nickname, personEntity.keyPhrase);
    await registrationRemoteSource.addPerson(personEntity);
  }
}