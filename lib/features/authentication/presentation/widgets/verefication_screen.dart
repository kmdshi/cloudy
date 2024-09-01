import 'package:cryptome/features/authentication/domain/entities/person_entity.dart';
import 'package:cryptome/features/authentication/presentation/widgets/keyphrase_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

class VereficationScreen extends StatefulWidget {
  final PersonEntity person;
  const VereficationScreen({super.key, required this.person});

  @override
  State<VereficationScreen> createState() => _VereficationScreenState();
}

class _VereficationScreenState extends State<VereficationScreen> {
  List<int> selectedPhrasesIndices = [];
  List<int> finalSelectedIndices = [];
  late final List<String> keyPhrases;
  @override
  void initState() {
    keyPhrases = List<String>.from(widget.person.keyPhrase);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text('Verify key phrase',
                  style: Theme.of(context).textTheme.titleMedium),
              Text('Tap the words and put them in the correct order',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontSize: 14)),
              const SizedBox(height: 10),
              KeyPhraseWidget(
                allPhrases: keyPhrases,
                selectedPhrasesIndices: selectedPhrasesIndices,
                onSelected: (index, selected, phrase) {
                  setState(() {
                    if (selected) {
                      selectedPhrasesIndices.add(index);
                      finalSelectedIndices
                          .add(widget.person.keyPhrase.indexOf(phrase));
                    } else {
                      selectedPhrasesIndices.remove(index);
                      finalSelectedIndices
                          .remove(widget.person.keyPhrase.indexOf(phrase));
                    }
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // context.push('/start/create/verif/success');
                  bool checkKeyPhrase = keyPhraseVerify(
                      widget.person.keyPhrase, finalSelectedIndices);
                  if (checkKeyPhrase) {
                    print("УРА ПОБЕДА");
                  } else {
                    print("ПЛОХО");
                  }
                },
                child: const Text('Verify'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  bool keyPhraseVerify(
      List<String> keyPhrase, List<int> selectedPhrasesIndices) {
    final List<String> keyPhraseVertify = [];
    Function eq = const ListEquality().equals;

    if (selectedPhrasesIndices.isNotEmpty) {
      for (var i = 0; i < keyPhrase.length; i++) {
        final phraseIndex = selectedPhrasesIndices[i];
        final phraseAtIndex = keyPhrase[phraseIndex];
        keyPhraseVertify.add(phraseAtIndex);
      }
      if (eq(keyPhrase, keyPhraseVertify)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
}
