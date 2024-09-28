import 'package:cryptome/core/gen/assets.gen.dart';
import 'package:cryptome/core/theme/color_theme.dart';
import 'package:cryptome/features/user_data/presentation/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImportAddressScreen extends StatelessWidget {
  const ImportAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        child: Text(
          'Save address',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 16,
                color: TColorTheme.white,
              ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Import an address'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Assets.icons.arrowIcon.image(),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            InputWidget(
              title: 'NAME',
              subtitle: 'Contact name',
            ),
            InputWidget(
              title: 'ADDRESS',
              subtitle: 'Public address (0x)',
              isAddress: true,
            ),
            InputWidget(
              title: 'DESCRIPTIONS',
              subtitle: '(optional)',
            ),
          ],
        ),
      ),
    );
  }
}
