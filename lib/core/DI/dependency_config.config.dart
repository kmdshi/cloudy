// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_links/app_links.dart' as _i327;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:cloudy/core/DI/dependency_config.dart' as _i1030;
import 'package:cloudy/core/services/cipher_service.dart' as _i128;
import 'package:cloudy/core/services/deeplink_handler.dart' as _i848;
import 'package:cloudy/features/messaging/data/datasources/local/messaging_local_repository.dart'
    as _i769;
import 'package:cloudy/features/messaging/data/datasources/remote/messaging_remote_repository.dart'
    as _i184;
import 'package:cloudy/features/messaging/data/repository/messaging_repository_impl.dart'
    as _i4;
import 'package:cloudy/features/messaging/domain/repository/messaging_repository.dart'
    as _i148;
import 'package:cloudy/features/messaging/presentation/bloc/messaging_bloc.dart'
    as _i993;
import 'package:cloudy/features/registration/data/data_source/local/registration_local_source.dart'
    as _i250;
import 'package:cloudy/features/registration/data/data_source/remote/registration_remote_source.dart'
    as _i592;
import 'package:cloudy/features/registration/data/repository/registration_repository_impl.dart'
    as _i268;
import 'package:cloudy/features/registration/domain/repository/registration_repository.dart'
    as _i667;
import 'package:cloudy/features/registration/presentation/bloc/registration_bloc.dart'
    as _i812;
import 'package:cloudy/features/user_data/data/datasource/local_source/user_data_local_repo.dart'
    as _i756;
import 'package:cloudy/features/user_data/data/datasource/remote_source/user_data_remote_repo.dart'
    as _i462;
import 'package:cloudy/features/user_data/data/repository/user_data_repo_impl.dart'
    as _i20;
import 'package:cloudy/features/user_data/domain/repository/user_data_repository.dart'
    as _i158;
import 'package:cloudy/features/user_data/presentation/bloc/messaging_bloc.dart'
    as _i740;
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
    gh.lazySingleton<_i128.CipherService>(
        () => injectionModule.encryptionService());
    gh.lazySingleton<_i848.DeepLinkHandlerService>(
        () => injectionModule.deepLinkHandlerService());
    gh.lazySingleton<_i769.MessagingLocalRepository>(
        () => _i769.MessagingLocalRepository());
    gh.lazySingleton<_i756.UserDataLocalRepo>(() => _i756.UserDataLocalRepo());
    gh.lazySingleton<_i462.UserDataRemoteRepo>(() => _i462.UserDataRemoteRepo(
          fireStoreDB: gh<_i974.FirebaseFirestore>(),
          firestorage: gh<_i457.FirebaseStorage>(),
        ));
    gh.lazySingleton<_i250.RegistrationLocalSource>(() =>
        _i250.RegistrationLocalSource(
            cipherService: gh<_i128.CipherService>()));
    gh.lazySingleton<_i592.RegistrationRemoteSource>(
        () => _i592.RegistrationRemoteSource(
              fireStoreDB: gh<_i974.FirebaseFirestore>(),
              cipherService: gh<_i128.CipherService>(),
              firestorage: gh<_i457.FirebaseStorage>(),
            ));
    gh.lazySingleton<_i184.MessagingRemoteRepository>(
        () => _i184.MessagingRemoteRepository(
              fireStoreDB: gh<_i974.FirebaseFirestore>(),
              cipherService: gh<_i128.CipherService>(),
            ));
    gh.lazySingleton<_i158.UserDataRepository>(() => _i20.UserDataRepoImpl(
          messagingLocalRepo: gh<_i756.UserDataLocalRepo>(),
          cipherService: gh<_i128.CipherService>(),
          messagingRemoteRepo: gh<_i462.UserDataRemoteRepo>(),
        ));
    gh.factory<_i740.UserDataBloc>(() => _i740.UserDataBloc(
        messagingRepository: gh<_i158.UserDataRepository>()));
    gh.lazySingleton<_i148.MessagingRepository>(
        () => _i4.MessagingRepositoryImpl(
              messagingRemoteRepository: gh<_i184.MessagingRemoteRepository>(),
              messagingLocalRepository: gh<_i769.MessagingLocalRepository>(),
              cipherService: gh<_i128.CipherService>(),
            ));
    gh.lazySingleton<_i667.RegistrationRepository>(
        () => _i268.RegistrationRepositoryImpl(
              registrationLocalSource: gh<_i250.RegistrationLocalSource>(),
              registrationRemoteSource: gh<_i592.RegistrationRemoteSource>(),
            ));
    gh.factory<_i812.RegistrationBloc>(() => _i812.RegistrationBloc(
        registrationRepository: gh<_i667.RegistrationRepository>()));
    gh.factory<_i993.MessagingBloc>(() => _i993.MessagingBloc(
        messagingRepository: gh<_i148.MessagingRepository>()));
    return this;
  }
}

class _$InjectionModule extends _i1030.InjectionModule {}
