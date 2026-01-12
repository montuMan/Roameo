import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../services/geocoding_service.dart';

/// Cyberpunk-styled search bar with autocomplete for place search
class CyberpunkSearchBar extends StatefulWidget {
  final GeocodingService geocodingService;
  final Function(PlaceResult) onPlaceSelected;
  final List<double>? proximityBias; // [lng, lat] for biasing results

  const CyberpunkSearchBar({
    super.key,
    required this.geocodingService,
    required this.onPlaceSelected,
    this.proximityBias,
  });

  @override
  State<CyberpunkSearchBar> createState() => _CyberpunkSearchBarState();
}

class _CyberpunkSearchBarState extends State<CyberpunkSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _searchSubject = BehaviorSubject<String>();
  
  List<PlaceResult> _searchResults = [];
  bool _isSearching = false;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    
    // Debounced search with RxDart
    _searchSubject
        .debounceTime(const Duration(milliseconds: 400)) // 400ms delay
        .distinct() // Only if query changed
        .listen((query) {
      if (query.trim().isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _searchResults = [];
          _showResults = false;
        });
      }
    });

    _focusNode.addListener(() {
      setState(() {
        _showResults = _focusNode.hasFocus && _searchResults.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _searchSubject.close();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isSearching = true);

    final results = await widget.geocodingService.searchPlaces(
      query: query,
      proximity: widget.proximityBias,
      limit: 7,
    );

    setState(() {
      _searchResults = results;
      _isSearching = false;
      _showResults = results.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _selectPlace(PlaceResult place) {
    _controller.text = place.placeName;
    _focusNode.unfocus();
    setState(() => _showResults = false);
    
    widget.onPlaceSelected(place);
    print('📍 Selected: ${place.placeName} at (${place.latitude}, ${place.longitude})');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search Bar
        _buildSearchBar(),
        
        // Results Dropdown
        if (_showResults) _buildResultsList(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        // Cyberpunk glassmorphic style
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF00FFFF).withOpacity(0.3), // Neon cyan border
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FFFF).withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Icon
          Icon(
            Icons.search,
            color: const Color(0xFF00FFFF),
            size: 24,
          ),
          const SizedBox(width: 12),
          
          // Text Input
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: const Color(0xFF00FFFF), // Neon cursor
              decoration: InputDecoration(
                hintText: 'Search places...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                _searchSubject.add(value); // Trigger debounced search
              },
            ),
          ),
          
          // Loading indicator or Clear button
          if (_isSearching)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF00FFFF),
                ),
              ),
            )
          else if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                _searchSubject.add('');
                setState(() {
                  _searchResults = [];
                  _showResults = false;
                });
              },
              child: Icon(
                Icons.clear,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00FFFF).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FFFF).withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: _searchResults.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.white.withOpacity(0.1),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final place = _searchResults[index];
              return _buildResultItem(place);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(PlaceResult place) {
    // Get icon based on place type
    IconData icon = Icons.place;
    Color iconColor = const Color(0xFF00FFFF);
    
    if (place.category != null) {
      if (place.category!.contains('restaurant') || place.category!.contains('food')) {
        icon = Icons.restaurant;
        iconColor = const Color(0xFFFF6B6B);
      } else if (place.category!.contains('hotel')) {
        icon = Icons.hotel;
        iconColor = const Color(0xFFBB86FC);
      } else if (place.category!.contains('bar') || place.category!.contains('nightlife')) {
        icon = Icons.local_bar;
        iconColor = const Color(0xFFFFD93D);
      } else if (place.category!.contains('cafe') || place.category!.contains('coffee')) {
        icon = Icons.local_cafe;
        iconColor = const Color(0xFF6BCF7F);
      }
    }

    return InkWell(
      onTap: () => _selectPlace(place),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            
            // Place info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Place name
                  Text(
                    place.placeName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  
                  // Full address
                  Text(
                    place.fullAddress,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Arrow icon
            Icon(
              Icons.north_west,
              color: Colors.white.withOpacity(0.4),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
