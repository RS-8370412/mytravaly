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

    // This call REQUIRES visitor token; default headers include it
    try {
      final res = await _apiClient.post('', body: body, includeVisitorToken: true);
      print('getSearchResultListOfHotels response: $res');
      // return res;
    } catch (e) {
      final String err = e.toString();
      final bool invalidVisitorToken = err.contains('Invalid visitor token');
      final bool badRequest = err.contains(' 400 ');
      if (invalidVisitorToken || badRequest) {
        // Attempt to self-heal: clear token, re-register, retry once
        await AppConfig.clearVisitorToken();
        await DeviceService().registerDevice();
        return await _apiClient.post('', body: body, includeVisitorToken: true);
      }
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


