import 'package:cloudy/app/cryptome_app.dart';
import 'package:cloudy/core/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/DI/dependency_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureInjection();
  runApp(const CryptomeApp());
}


/*
Copyright (C) 2024 Kamidashi
This software is licensed under the GNU General Public License v2.
*/