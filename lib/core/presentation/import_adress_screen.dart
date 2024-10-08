import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:cloudy/features/user_data/presentation/bloc/user_data_bloc.dart';
import 'package:cloudy/features/user_data/presentation/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ImportAddressScreen extends StatefulWidget {
  final String AID;
  final bool isFromSettings;
  const ImportAddressScreen({
    super.key,
    required this.AID,
    required this.isFromSettings,
  });

  @override
  State<ImportAddressScreen> createState() => _ImportAddressScreenState();
}

class _ImportAddressScreenState extends State<ImportAddressScreen> {
  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    nameController = TextEditingController();
    addressController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () => onPressed(context),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            InputWidget(
              title: 'NAME',
              subtitle: 'Contact name',
              controller: nameController,
            ),
            InputWidget(
              title: 'ADDRESS',
              subtitle: 'Public address (0x)',
              isAddress: true,
              controller: addressController,
            ),
            InputWidget(
              title: 'DESCRIPTIONS',
              subtitle: '(optional)',
              controller: descriptionController,
            ),
          ],
        ),
      ),
    );
  }

  void onPressed(BuildContext context) async {
    if (widget.isFromSettings) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
              child: CircularProgressIndicator(color: TColorTheme.mainBlue));
        },
      );

      context.read<SettingsBloc>().add(AddSettingsContactEvent(
          AID: widget.AID,
          contactAID: addressController.text
              .substring(2, addressController.text.length),
          localName:
              nameController.text.isEmpty ? 'null' : nameController.text));

      await context
          .read<SettingsBloc>()
          .stream
          .firstWhere((state) => state is SettingsLoaded);

      if (!mounted) return;

      Navigator.of(context).pop();

      final state = context.read<SettingsBloc>().state as SettingsLoaded;
      final result = state.expectedErrorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'User added successfully')),
      );

      context.read<UserDataBloc>().add(GetStartUserData());
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
              child: CircularProgressIndicator(color: TColorTheme.mainBlue));
        },
      );

      context.read<UserDataBloc>().add(AddContactEvent(
          AID: widget.AID,
          contactAID: addressController.text
              .substring(2, addressController.text.length),
          localName:
              nameController.text.isEmpty ? 'null' : nameController.text));

      await context
          .read<UserDataBloc>()
          .stream
          .firstWhere((state) => state is UserDataLoaded);

      if (!mounted) return;

      Navigator.of(context).pop();

      final state = context.read<UserDataBloc>().state as UserDataLoaded;
      final result = state.expectedErrorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'User added successfully')),
      );

      context.read<UserDataBloc>().add(GetStartUserData());
    }
  }
}
