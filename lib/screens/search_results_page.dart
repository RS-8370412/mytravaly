import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../services/search_service.dart';
import '../models/hotel_model.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final List<Hotel> _hotels = [];
  final List<String> _excludedHotels = []; // Track which hotels to exclude
  bool _isLoading = false;
  bool _hasMore = true;
  final int _limit = 5; // API maximum limit is 5
  String _query = '';
  String? _error;
  
  static const Color _brandColor = Color(0xFFFF6F61);
  final SearchService _searchService = SearchService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    _query = (args is String) ? args : '';
    if (_hotels.isEmpty && !_isLoading) {
      _loadMore();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMore();
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final Map<String, dynamic> searchCriteria = {
        'checkIn': '2026-07-11',
        'checkOut': '2026-07-12',
        'rooms': 2,
        'adults': 2,
        'children': 0,
        'searchType': 'hotelIdSearch',
        'searchQuery': ['qyhZqzVt'],
        'accommodation': ['all'],
        'arrayOfExcludedSearchType': ['street'],
        'highPrice': '3000000',
        'lowPrice': '0',
        'limit': _limit, // Maximum is 5
        'preloaderList': _excludedHotels, // Exclude already shown hotels
        'currency': 'INR',
        'rid': 0,
      };

      print('🔍 Loading batch ${(_excludedHotels.length / _limit).ceil() + 1} (excluding ${_excludedHotels.length} hotels)');

      final response = await _searchService.getSearchResultListOfHotels(
        searchCriteria: searchCriteria,
      );
      
      final data = response as Map<String, dynamic>;
      final bool ok = data['status'] == true;
      final hotelsData = ok ? (data['data']?['arrayOfHotelList'] as List<dynamic>?) : null;
      final excludedList = ok ? (data['data']?['arrayOfExcludedHotels'] as List<dynamic>?) : null;
      
      if (ok && hotelsData != null) {
        final newHotels = hotelsData
            .whereType<Map<String, dynamic>>()
            .map((e) => Hotel.fromJson(e))
            .toList();
        
        // Add newly excluded hotels to our list
        if (excludedList != null) {
          final newExcluded = excludedList.whereType<String>().toList();
          _excludedHotels.addAll(newExcluded.where((id) => !_excludedHotels.contains(id)));
          print('📦 Loaded ${newHotels.length} hotels, total excluded: ${_excludedHotels.length}');
        }
        
        setState(() {
          _hotels.addAll(newHotels);
          // If we got fewer than limit, or no new hotels, no more results
          _hasMore = newHotels.length >= _limit;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasMore = false;
          _isLoading = false;
          if (_hotels.isEmpty) {
            _error = data['message'] ?? 'No results found';
          }
        });
      }
    } catch (e) {
      print('❌ Error loading more: $e');
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
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
        backgroundColor: Colors.grey.shade50,
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
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Search Results',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                            if (_hotels.isNotEmpty)
                              Text(
                                '${_hotels.length} hotel${_hotels.length != 1 ? 's' : ''} found',
                                style: const TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Show error on first load
    if (_hotels.isEmpty && _error != null && !_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Error loading results',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                    _excludedHotels.clear();
                    _hasMore = true;
                  });
                  _loadMore();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Show initial loading
    if (_hotels.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show empty state
    if (_hotels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No hotels found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
            ),
          ],
        ),
      );
    }

    // Show list with pagination
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _hotels.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _hotels.length) {
          // Loading indicator at bottom
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          );
        }
        final hotel = _hotels[index];
        return _HotelCard(hotel: hotel, brandColor: _brandColor);
      },
    );
  }
}

class _HotelCard extends StatelessWidget {
  final Hotel hotel;
  final Color brandColor;

  const _HotelCard({required this.hotel, required this.brandColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Image.network(
                  hotel.propertyImage.fullUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.hotel, size: 64, color: Colors.grey.shade400),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: brandColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(5, (i) => Icon(
                          i < hotel.propertyStar ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.white,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.propertyName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                    Expanded(
                      child: Text(
                        '${hotel.propertyAddress.city}, ${hotel.propertyAddress.state}',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.hotel, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      hotel.propertytype,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${hotel.numberOfAdults} adults',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                if (hotel.googleReview != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${hotel.googleReview!.overallRating} (${hotel.googleReview!.totalUserRating} reviews)',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hotel.markedPrice.amount > hotel.availableDeals.first.price.amount)
                          Text(
                            hotel.markedPrice.displayAmount,
                            style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        Text(
                          hotel.availableDeals.first.price.displayAmount,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: brandColor,
                          ),
                        ),
                        Text(
                          'per night',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Booking ${hotel.propertyName}')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}