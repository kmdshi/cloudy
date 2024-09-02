import 'package:cryptome/app/cryptome_app.dart';
import 'package:cryptome/core/DI/dependency_config.dart';
import 'package:cryptome/core/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureInjection();
  runApp(const CryptomeApp());
}
