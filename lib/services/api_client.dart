import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

class ApiClient {
  final http.Client _httpClient;
  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<Map<String, String>> _headers({bool includeVisitorToken = true}) async {
    final visitorToken = includeVisitorToken ? await AppConfig.getVisitorToken() : '';
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'authtoken': AppConfig.apiToken,
    };
    if (includeVisitorToken && visitorToken.isNotEmpty) {
      headers['visitortoken'] = visitorToken;
    }
    return headers;
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final String base = AppConfig.apiBaseUrl.endsWith('/')
        ? AppConfig.apiBaseUrl
        : '${AppConfig.apiBaseUrl}/';
    return Uri.parse('$base$path').replace(
      queryParameters: queryParameters?.map((k, v) => MapEntry(k, '$v')),
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query, bool includeVisitorToken = true}) async {
    final uri = _buildUri(path, query);
    final headers = await _headers(includeVisitorToken: includeVisitorToken);
    final res = await _httpClient.get(uri, headers: headers);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }
    throw HttpException('GET $uri failed: ${res.statusCode} ${res.body}');
  }

  Future<dynamic> post(String path, {required Map<String, dynamic> body, bool includeVisitorToken = true}) async {
    final uri = _buildUri(path);
    final headers = await _headers(includeVisitorToken: includeVisitorToken);
    final res = await _httpClient.post(uri, headers: headers, body: jsonEncode(body));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }
    throw HttpException('POST $uri failed: ${res.statusCode} ${res.body}');
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => message;
}
