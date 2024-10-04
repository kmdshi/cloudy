import 'package:cloudy/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/gen/assets.gen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Start a Fun Communication with Anonymity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(height: 20),
            Assets.images.bgStart.image(),
            Spacer(),
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () => context.push('/start/create'),
              child: Text('Create an account'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextButton(
                style: Theme.of(context).textButtonTheme.style,
                onPressed: () => context.push('/start/restore'),
                child: Text(
                  'Restore',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: TColorTheme.darkLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
