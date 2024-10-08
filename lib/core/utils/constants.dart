import 'package:cloudy/core/gen/assets.gen.dart';
import 'package:cloudy/core/theme/color_theme.dart';

class Constants {
  static Map<String, dynamic> settingsOptions = {
    'URL Status':
        Assets.icons.statusIcon.image(width: 30, color: TColorTheme.greyLabel),
    'Import an Address':
        Assets.icons.addIcon.image(width: 30, color: TColorTheme.greyLabel),
    'Appearance':
        Assets.icons.themeIcon.image(width: 35, color: TColorTheme.greyLabel),
    'Cipher': Assets.icons.encryptionIcon
        .image(width: 25, color: TColorTheme.greyLabel),
    'About':
        Assets.icons.infoIcon.image(width: 30, color: TColorTheme.greyLabel),
    'Log Out':
        Assets.icons.logOut.image(width: 25, color: TColorTheme.greyLabel),
  };
}
