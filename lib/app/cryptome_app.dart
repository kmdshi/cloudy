import 'package:cryptome/features/registration/widgets/registation_screen.dart';
import 'package:flutter/material.dart';

class CryptomeApp extends StatelessWidget {
  const CryptomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const  MaterialApp(
      home: RegistationScreen(),
    );
  }
}