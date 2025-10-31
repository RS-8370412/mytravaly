import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_client.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  Future<dynamic>? _future;
  String _query = '';
  static const Color _brandColor = Color(0xFFFF6F61);
  final ApiClient _api = ApiClient();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    _query = (args is String) ? args : '';
    _future ??= _fetch();
  }

  Future<dynamic> _fetch() async {
    // API expects POST to base with action and payload in body
    final Map<String, dynamic> body = {
      'action': 'getSearchResultListOfHotels',
      'getSearchResultListOfHotels': {
        'searchCriteria': {
          'checkIn': '2026-07-11',
          'checkOut': '2026-07-12',
          'rooms': 1,
          'adults': 2,
          'children': 0,
          'searchType': 'hotelIdSearch',
          'searchQuery': [_query],
          'accommodation': ['all'],
          'arrayOfExcludedSearchType': ['street'],
          'highPrice': '3000000',
          'lowPrice': '0',
          'limit': 5,
          'preloaderList': [],
          'currency': 'INR',
          'rid': 0,
        }
      }
    };
    return await _api.post('', body: body);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: _brandColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Search Results',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<dynamic>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final data = snapshot.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(const JsonEncoder.withIndent('  ').convert(data)),
          );
        },
      ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
