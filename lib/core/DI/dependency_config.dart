import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptome/core/DI/dependency_config.config.dart';
import 'package:cryptome/core/services/cipher_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@module
abstract class InjectionModule {
  @preResolve
  Future<SharedPreferences> getPrefs() => SharedPreferences.getInstance();

  @lazySingleton
  FirebaseFirestore firebaseFirestore() => FirebaseFirestore.instance;

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  FirebaseStorage firebaseStorage() => FirebaseStorage.instance;

  @lazySingleton
  CipherService encryptionService() => CipherService();
}

@injectableInit
Future<void> configureInjection() async {
  await getIt.init();
  // Bloc.observer = AppBlocObserver();
}
