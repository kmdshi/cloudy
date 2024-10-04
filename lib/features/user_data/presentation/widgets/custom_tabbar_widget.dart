import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/features/user_data/presentation/widgets/tab_item_widget.dart';
import 'package:flutter/material.dart';

class CustomTabbarWidget extends StatelessWidget {
  const CustomTabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: TColorTheme.tabbarBg,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const TabBar(
          tabs: [
            TabItemWidget(title: 'Messages'),
            TabItemWidget(title: 'Groups'),
          ],
        ),
      ),
    );
  }
}
