/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow_icon.png
  AssetGenImage get arrowIcon =>
      const AssetGenImage('assets/icons/arrow_icon.png');

  /// File path: assets/icons/done_icon.png
  AssetGenImage get doneIcon =>
      const AssetGenImage('assets/icons/done_icon.png');

  /// File path: assets/icons/paper_icon.png
  AssetGenImage get paperIcon =>
      const AssetGenImage('assets/icons/paper_icon.png');

  /// File path: assets/icons/scan_icon.png
  AssetGenImage get scanIcon =>
      const AssetGenImage('assets/icons/scan_icon.png');

  /// File path: assets/icons/search_icon.png
  AssetGenImage get searchIcon =>
      const AssetGenImage('assets/icons/search_icon.png');

  /// File path: assets/icons/setting_icon.png
  AssetGenImage get settingIcon =>
      const AssetGenImage('assets/icons/setting_icon.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [arrowIcon, doneIcon, paperIcon, scanIcon, searchIcon, settingIcon];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bg_no_chats.png
  AssetGenImage get bgNoChats =>
      const AssetGenImage('assets/images/bg_no_chats.png');

  /// File path: assets/images/bg_start.png
  AssetGenImage get bgStart =>
      const AssetGenImage('assets/images/bg_start.png');

  /// List of all assets
  List<AssetGenImage> get values => [bgNoChats, bgStart];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
