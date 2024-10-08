import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/theme/color_theme.dart';
import 'package:cloudy/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:cloudy/features/user_data/presentation/bloc/user_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<Object?> showUrlDialog(
  BuildContext context,
  String AID,
  bool urlStatus,
  bool fromSettings,
) async {
  return showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (_, __, ___) {
      return StatefulBuilder(
        builder: (context, setState) => Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              width: 334,
              height: 430,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Public URL is ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontSize: 16)),
                            TextSpan(
                              text: urlStatus == false ? 'Disabled' : 'Enabled',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListBody(
                      children: [
                        Text(
                          urlStatus != false
                              ? 'You are now enabling public url. \nIt means, you can invite people to message \nyou directly using url below.'
                              : 'You are now disabling public URL. \nIt means, people will no longer be able to \nmessage you directly using the URL below.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 14,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: QrImageView(
                            data: 'public.cx/0x$AID',
                            version: QrVersions.auto,
                            size: 115.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Your public url:',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => onTextTap(context, AID),
                          child: Text(
                            'public.cx/0x$AID',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 14,
                                  color: TColorTheme.buttonBgBlue,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.paperIcon.image(),
                            const SizedBox(width: 5),
                            Text(
                              'click to copy',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontSize: 12,
                                  ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (fromSettings) {
                              context.read<SettingsBloc>().add(
                                  ChangeUrlSettingsStatusEvent(
                                      AID: AID, newStatus: !urlStatus));
                            } else {
                              context.read<UserDataBloc>().add(
                                  ChangeUrlStatusEvent(
                                      AID: AID, newStatus: !urlStatus));
                            }
                            setState(() {
                              urlStatus = !urlStatus;
                            });
                          },
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                fixedSize:
                                    const WidgetStatePropertyAll(Size(143, 40)),
                                foregroundColor: const WidgetStatePropertyAll(
                                    TColorTheme.textGrey),
                                backgroundColor: const WidgetStatePropertyAll(
                                    TColorTheme.white),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: TColorTheme.textGrey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                          child: Text(
                            urlStatus
                                ? 'Disable Public url'
                                : 'Enable Public url',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: TColorTheme.textGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                fixedSize:
                                    const WidgetStatePropertyAll(Size(114, 40)),
                              ),
                          child: Text(
                            'Save & close',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: TColorTheme.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> onTextTap(context, String dataAID) async {
  await Clipboard.setData(ClipboardData(text: 'public.cx/0x$dataAID'))
      .then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to your clipboard !')));
  });
}
