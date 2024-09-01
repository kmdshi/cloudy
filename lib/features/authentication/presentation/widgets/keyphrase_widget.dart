import 'dart:math';

import 'package:cryptome/core/theme/color_theme.dart';
import 'package:flutter/material.dart';

class KeyPhraseWidget extends StatefulWidget {
  final List<String> allPhrases;
  final Function(int, bool, String) onSelected;
  List<int> selectedPhrasesIndices;

  KeyPhraseWidget({
    super.key,
    required this.allPhrases,
    required this.selectedPhrasesIndices,
    required this.onSelected,
  });

  @override
  _KeyPhraseWidgetState createState() => _KeyPhraseWidgetState();
}

class _KeyPhraseWidgetState extends State<KeyPhraseWidget> {
  List<int> selectedPhrasesIndices = [];
  late String keyPhraseString;
  @override
  void initState() {
    keyPhraseString = keyPhraseToText(widget.allPhrases);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Key Phrase:',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: TColorTheme.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  keyPhraseString,
                  style: TextStyle(color: Colors.transparent),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: selectedPhrasesIndices.map((index) {
                    final phrase = widget.allPhrases[index];
                    final position =
                        widget.selectedPhrasesIndices.indexOf(index) + 1;
                    return Theme(
                      data: Theme.of(context)
                          .copyWith(canvasColor: Colors.transparent),
                      child: ChipTheme(
                        data: Theme.of(context).chipTheme,
                        child: Chip(
                          label: Text('$position. $phrase'),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.allPhrases.asMap().entries.map((entry) {
                final index = entry.key;
                final phrase = entry.value;
                return Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Colors.transparent),
                  child: ChipTheme(
                    data: Theme.of(context).chipTheme,
                    child: ChoiceChip(
                      label: Text(phrase),
                      selected: selectedPhrasesIndices.contains(index),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            if (!selectedPhrasesIndices.contains(index)) {
                              selectedPhrasesIndices.add(index);
                            }
                          } else {
                            selectedPhrasesIndices.remove(index);
                          }
                          widget.onSelected(index, selected, phrase);
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String keyPhraseToText(List<String> keyPhrase) {
    final shuffledKeyPhrase = keyPhrase..shuffle(Random());

    return shuffledKeyPhrase
        .asMap()
        .entries
        .map((entry) => '${entry.key + 1}${entry.value}')
        .join('\n')
        .replaceAll(' ', '');
  }
}
