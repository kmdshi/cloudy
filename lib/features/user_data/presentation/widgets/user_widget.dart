// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final String userName;
  final String avatarUrl;
  final Function()? onTap;
  const UserWidget({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.length > 10 ? userName.substring(0, 5) : userName,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text('Last message'),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('14:48'),
                SizedBox(height: 5),
                Text('кружок'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
