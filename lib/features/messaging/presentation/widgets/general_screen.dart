import 'package:cryptome/core/gen/assets.gen.dart';
import 'package:cryptome/features/messaging/presentation/widgets/custom_icon_button_widget.dart';
import 'package:cryptome/features/messaging/presentation/widgets/custom_tabbar_widget.dart';
import 'package:cryptome/features/messaging/presentation/widgets/messages_screen.dart';
import 'package:flutter/material.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 20.0,
          title: const Text(
            'Cipherme',
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(75),
            child: CustomTabbarWidget(),
          ),
          actions: [
            CustomIconButtonWidget(
              iconPath: Assets.icons.searchIcon.path,
              onTap: () {},
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CustomIconButtonWidget(
                iconPath: Assets.icons.settingIcon.path,
                onTap: () {},
              ),
            ),
          ],
        ),
        body: const SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: TabBarView(
              children: [
                // Center(
                //   child: Text('1'),
                // ),
                MessagesScreen(),
                Center(
                  child: Text('2'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
