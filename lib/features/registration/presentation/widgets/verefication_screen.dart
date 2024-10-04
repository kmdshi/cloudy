import 'dart:developer';

import 'package:cloudy/features/registration/domain/entities/person_entity.dart';
import 'package:cloudy/features/registration/presentation/bloc/registration_bloc.dart';
import 'package:cloudy/features/registration/presentation/widgets/keyphrase_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.push('/start/create/verif/success');
          });
        } else if (state is RegistrationFailure) {
          log(state.message);
        }
      },
      child: Scaffold(
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
                    bool checkKeyPhrase = keyPhraseVerify(
                        widget.person.keyPhrase, finalSelectedIndices);
                    if (checkKeyPhrase) {
                      context
                          .read<RegistrationBloc>()
                          .add(CreatePersonEvent(personEntity: widget.person));
                    } else {
                      log("ПЛОХО");
                    }
                  },
                  child: const Text('Verify'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool keyPhraseVerify(
      List<String> keyPhrase, List<int> selectedPhrasesIndices) {
    final List<String> keyPhraseVertify = [];
    Function eq = const ListEquality().equals;

    if (selectedPhrasesIndices.isNotEmpty &&
        (selectedPhrasesIndices.length == keyPhrase.length)) {
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
