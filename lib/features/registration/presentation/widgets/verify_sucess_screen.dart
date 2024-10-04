import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifySuccessScreen extends StatelessWidget {
  const VerifySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () => context.pushReplacement('/messages'),
        child: const Text('Finish'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5E4FB),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Assets.icons.doneIcon.image(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Verify Success!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 5),
              Text(
                'Successfully verified your account, tap the finish button below to open your main Chatx.',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
