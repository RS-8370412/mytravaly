import 'dart:io';
import '../config/constants.dart';
import 'api_client.dart';

class DeviceService {
  final ApiClient _apiClient;
  DeviceService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<void> registerDevice() async {
    final String model = Platform.isAndroid ? 'Android' : Platform.isIOS ? 'iOS' : Platform.operatingSystem;
    final Map<String, dynamic> body = {
      'action': 'deviceRegister',
      'deviceRegister': {
        'deviceModel': model,
        'deviceFingerprint': Platform.operatingSystemVersion,
        'deviceBrand': Platform.operatingSystem,
        'deviceId': Platform.localHostname,
        'deviceName': Platform.localHostname,
        'deviceManufacturer': Platform.operatingSystem,
        'deviceProduct': model,
        'deviceSerialNumber': 'unknown',
      }
    };

    final dynamic res = await _apiClient.post('', body: body, includeVisitorToken: false);
    print('res: $res');
    try {
      if (res.status == true) {
        final data = res['data'] as Map?;
        final token = data != null ? (data['visitorToken'] as String? ?? '') : '';
        if (token.isNotEmpty) {
          await AppConfig.setVisitorToken(token);
        }
      }
    } catch (_) {
      // Swallow parsing/storage errors silently; registration isn't fatal for app start
    }
  }
}


