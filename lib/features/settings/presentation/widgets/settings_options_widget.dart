import 'package:cloudy/core/router/cryptome_router.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/core/utils/constants.dart';
import 'package:cloudy/core/presentation/show_url_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsOptionsWidget extends StatelessWidget {
  final String AID;
  final bool urlStatus;
  const SettingsOptionsWidget({
    super.key,
    required this.AID,
    required this.urlStatus,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> settings = Constants.settingsOptions.entries
        .map((e) => {'title': e.key, 'icon': e.value})
        .toList();

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: settings.length,
      itemBuilder: (context, index) {
        final currentSetting = settings[index];

        return ListTile(
          leading: currentSetting['icon'],
          title: Text(
            currentSetting['title'],
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: currentSetting['title'] == 'Log Out'
                      ? TColorTheme.red
                      : TColorTheme.textGrey,
                ),
          ),
          onTap: () => onTap(index, context),
        );
      },
    );
  }

  void onTap(int index, BuildContext context) async {
    switch (index) {
      case 0:
        await showUrlDialog(context, AID, urlStatus, true);
      case 1:
        context.push('/messages/settings/import/$AID');
      case 2:
        print('Appearance');
      case 3:
        context.push('/messages/settings/cipher');
      case 4:
        context.push('/messages/settings/about');
      case 5:
        print('Log Out');
    }
  }
}
