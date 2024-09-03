import 'package:cryptome/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Assets.images.bgNoChats.image(),
    );
  }
}
