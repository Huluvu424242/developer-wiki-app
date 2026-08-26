import 'package:flutter/services.dart';

import '../models/app_info.dart';

abstract interface class AppInfoGateway {
  Future<AppInfo> load();
}

class AppInfoService implements AppInfoGateway {
  static const _channel = MethodChannel('developer_wiki/app_info');

  @override
  Future<AppInfo> load() async {
    final data = await _channel.invokeMapMethod<String, dynamic>('getAppInfo');
    final version = data?['version']?.toString().trim() ?? '';
    final buildNumber = data?['buildNumber']?.toString().trim() ?? '';
    if (version.isEmpty) {
      throw const FormatException('Die installierte App-Version fehlt.');
    }
    return AppInfo(version: version, buildNumber: buildNumber);
  }
}
