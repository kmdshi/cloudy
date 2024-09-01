import 'dart:typed_data';

import 'package:cryptome/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class AvatarWidget extends StatefulWidget {
   Uint8List? image;
   Function() pickImage;
   AvatarWidget({
    super.key,
    required this.image,
    required this.pickImage,
  });

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: widget.pickImage,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  image: widget.image != null
                      ? DecorationImage(image: MemoryImage(widget.image!))
                      : null,
                  borderRadius: BorderRadius.circular(4.0),
                  border: const DashedBorder.fromBorderSide(
                      dashLength: 8,
                      side: BorderSide(
                          color: TColorTheme.secondryGrey, width: 2))),
              child: widget.image == null
                  ? const Center(
                      child: Icon(
                        Icons.add,
                        color: TColorTheme.secondryGrey,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Upload a picture',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Text(
            '(Automatically created as an NFT asset)',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: 12),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
