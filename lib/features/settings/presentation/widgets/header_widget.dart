import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String avatarUrl;
  final String nickname;
  final String AID;
  const HeaderWidget({
    super.key,
    required this.avatarUrl,
    required this.nickname,
    required this.AID,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(height: 10),
            nickname != ''
                ? Text(nickname, style: Theme.of(context).textTheme.titleMedium)
                : Text('No nickname selected ',
                    style: Theme.of(context).textTheme.titleMedium),
            Text(
              '${AID.substring(0, 5)}...${AID.substring(AID.length - 3, AID.length)}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ],
    );
  }
}
