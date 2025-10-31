import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static const String _visitorTokenKey = 'visitor_token';

  // Get API base URL from .env
  static String get apiBaseUrl => dotenv.env['MYTRAVALY_API_BASE_URL'] ?? 'https://api.mytravaly.com/public/v1/';
  
  // Get auth token from .env
  static String get apiToken => dotenv.env['MYTRAVALY_AUTH_TOKEN'] ?? '';
  
  // Get visitor token from .env (fallback to SharedPreferences)
  static Future<String> getVisitorToken() async {
    final envToken = dotenv.env['MYTRAVALY_VISITOR_TOKEN'];
    if (envToken != null && envToken.isNotEmpty) {
      return envToken;
    }
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_visitorTokenKey) ?? '';
  }

  // Set visitor token to SharedPreferences
  static Future<void> setVisitorToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_visitorTokenKey, token);
  }

  // Clear visitor token
  static Future<void> clearVisitorToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_visitorTokenKey);
  }
}
