// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:cryptome/core/DI/dependency_config.dart';
import 'package:flutter/material.dart';

class DeepLinkHandlerService {
  final appLinks = getIt<AppLinks>();
  StreamSubscription<Uri>? _subscription;

  void startListening() {
    _subscription = appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (error) {
      print('Ошибка при обработке диплинка: $error');
    });
  }

  void _handleDeepLink(Uri uri) {
    debugPrint(uri.toString());
  }

  void dispose() {
    _subscription?.cancel();
  }
}
