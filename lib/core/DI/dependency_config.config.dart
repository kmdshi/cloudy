// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_links/app_links.dart' as _i327;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:cryptome/core/DI/dependency_config.dart' as _i982;
import 'package:cryptome/core/services/cipher_service.dart' as _i900;
import 'package:cryptome/core/services/deeplink_handler.dart' as _i998;
import 'package:cryptome/features/registration/data/data_source/local_source.dart'
    as _i604;
import 'package:cryptome/features/registration/data/data_source/remote_source.dart'
    as _i225;
import 'package:cryptome/features/registration/data/repository/registration_repository_impl.dart'
    as _i31;
import 'package:cryptome/features/registration/domain/repository/registration_repository.dart'
    as _i547;
import 'package:cryptome/features/registration/presentation/bloc/registration_bloc.dart'
    as _i25;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectionModule = _$InjectionModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => injectionModule.getPrefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => injectionModule.secureStorage);
    gh.lazySingleton<_i327.AppLinks>(() => injectionModule.appLinks);
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => injectionModule.firebaseFirestore());
    gh.lazySingleton<_i457.FirebaseStorage>(
        () => injectionModule.firebaseStorage());
    gh.lazySingleton<_i900.CipherService>(
        () => injectionModule.encryptionService());
    gh.lazySingleton<_i998.DeepLinkHandlerService>(
        () => injectionModule.deepLinkHandlerService());
    gh.lazySingleton<_i225.RegistrationRemoteSource>(
        () => _i225.RegistrationRemoteSource(
              fireStoreDB: gh<_i974.FirebaseFirestore>(),
              cipherService: gh<_i900.CipherService>(),
              firestorage: gh<_i457.FirebaseStorage>(),
            ));
    gh.lazySingleton<_i604.RegistrationLocalSource>(() =>
        _i604.RegistrationLocalSource(
            cipherService: gh<_i900.CipherService>()));
    gh.lazySingleton<_i547.RegistrationRepository>(
        () => _i31.RegistrationRepositoryImpl(
              registrationLocalSource: gh<_i604.RegistrationLocalSource>(),
              registrationRemoteSource: gh<_i225.RegistrationRemoteSource>(),
            ));
    gh.factory<_i25.RegistrationBloc>(() => _i25.RegistrationBloc(
        registrationRepository: gh<_i547.RegistrationRepository>()));
    return this;
  }
}

class _$InjectionModule extends _i982.InjectionModule {}
