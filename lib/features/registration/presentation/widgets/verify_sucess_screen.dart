import 'package:cryptome/core/gen/assets.gen.dart';
import 'package:cryptome/core/theme/color_theme.dart';
import 'package:flutter/material.dart';

class VerifySuccessScreen extends StatelessWidget {
  const VerifySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        child: Text('Finish'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFD5E4FB),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Assets.icons.doneIcon.image(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Verify Success!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 5),
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
