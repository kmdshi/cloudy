import 'package:flutter/material.dart';

class CustomIconButtonWidget extends StatelessWidget {
  final String iconPath;
  final Function() onTap;
  const CustomIconButtonWidget({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withOpacity(0.2),
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: ImageIcon(
            AssetImage(iconPath),
            size: 24.0,
          ),
        ),
      ),
    );
  }
}
