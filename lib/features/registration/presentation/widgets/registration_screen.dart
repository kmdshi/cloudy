import 'dart:typed_data';

import 'package:cryptome/core/services/image_picker.dart';
import 'package:cryptome/features/registration/domain/entities/person_entity.dart';
import 'package:cryptome/features/registration/presentation/widgets/agreement_widget.dart';
import 'package:cryptome/features/registration/presentation/widgets/avatar_widget.dart';
import 'package:cryptome/features/registration/presentation/widgets/option_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistationScreen extends StatefulWidget {
  const RegistationScreen({super.key});

  @override
  State<RegistationScreen> createState() => _RegistationScreenState();
}

class _RegistationScreenState extends State<RegistationScreen> {
  Uint8List? image;
  late final TextEditingController nicknameController;
  late final TextEditingController interestsController;
  late final TextEditingController keyPhraseController;

  @override
  void initState() {
    nicknameController = TextEditingController();
    interestsController = TextEditingController();
    keyPhraseController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'Create new account',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              AvatarWidget(
                image: image,
                pickImage: () async {
                  final pickedImage = await imagePicker();
                  setState(() {
                    image = pickedImage;
                  });
                },
              ),
              OptionWidget(
                title: 'HOW ARE YOU CALLED?',
                content: 'Nickname',
                isTitle: true,
                fieldController: nicknameController,
              ),
              OptionWidget(
                title: 'WHAT ARE YOU INTRESTED ON??',
                content: '(optional)',
                isInterests: true,
                fieldController: interestsController,
              ),
              OptionWidget(
                title: 'YOUR KEY PHRASE',
                content:
                    'storage executrix die contract sufferingfool strain reign army frown raid nursery history node shelter decoration',
                isKeyphrase: true,
                fieldController: keyPhraseController,
              ),
              AgreementWidget(),
              SizedBox(height: 30),
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: () {
                  final person = PersonEntity(
                    avatar: image,
                    nickname: nicknameController.text,
                    interests: interestsController.text,
                    keyPhrase: keyPhraseParse(keyPhraseController.text),
                  );
                  context.push('/start/create/verif', extra: person);
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> keyPhraseParse(String keyPhraseString) {
    final normalizedString = keyPhraseString
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-zA-Z\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final words = normalizedString.split(' ');

    return words.where((word) => word.isNotEmpty).toList();
  }
}
