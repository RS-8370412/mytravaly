import 'api_client.dart';
import '../config/constants.dart';
import 'device_service.dart';

class SearchService {
  final ApiClient _apiClient;
  SearchService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<dynamic> getSearchResultListOfHotels({
    required Map<String, dynamic> searchCriteria,
  }) async {
    final Map<String, dynamic> normalizedCriteria = _normalizeSearchCriteria(searchCriteria);
    final Map<String, dynamic> body = {
      'action': 'getSearchResultListOfHotels',
      'getSearchResultListOfHotels': {
        'searchCriteria': normalizedCriteria,
      }
    };

    try {
      final res = await _apiClient.post('', body: body, includeVisitorToken: true);
      print('✅ Search successful');
      return res;
    } catch (e) {
      final String err = e.toString();
      
      // Check if it's specifically a visitor token issue (401 or token-related message)
      final bool invalidVisitorToken = err.contains('Invalid visitor token') || 
                                       err.contains('visitor token') ||
                                       err.contains('401');
      
      // Don't retry on validation errors (400 with specific validation messages)
      final bool isValidationError = err.contains('limit is Invalid') ||
                                     err.contains('checkIn') ||
                                     err.contains('checkOut') ||
                                     err.contains('accommodation');
      
      if (invalidVisitorToken && !isValidationError) {
        // Attempt to self-heal: clear token, re-register, retry once
        print('🔄 Invalid token detected, re-registering device...');
        await AppConfig.clearVisitorToken();
        await DeviceService().registerDevice();
        return await _apiClient.post('', body: body, includeVisitorToken: true);
      }
      
      // For validation errors or other errors, just throw them
      print('❌ Search error: $err');
      rethrow;
    }
  }

  Map<String, dynamic> _normalizeSearchCriteria(Map<String, dynamic> raw) {
    final Map<String, dynamic> out = {};
    raw.forEach((key, value) {
      if (value == null) return;
      switch (key) {
        case 'accommodation':
          // Ensure array of strings; avoid conflicting ["all", <specific>]
          final List<dynamic> list = (value as List).toList();
          final List<String> asStrings = list.map((e) => '$e').toList();
          if (asStrings.contains('all') && asStrings.length > 1) {
            out[key] = ['all'];
          } else {
            out[key] = asStrings;
          }
          break;
        case 'searchQuery':
        case 'arrayOfExcludedSearchType':
        case 'preloaderList':
          out[key] = (value as List).map((e) => '$e').toList();
          break;
        default:
          out[key] = value;
      }
    });
    return out;
  }
}