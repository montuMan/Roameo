import 'dart:convert';
import 'package:http/http.dart' as http;

/// Mapbox Geocoding API service for place search and autocomplete
class GeocodingService {
  final String accessToken;
  static const String _baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  GeocodingService({required this.accessToken});

  /// Search for places with autocomplete suggestions
  /// 
  /// [query] - Search query (e.g., "Bellagio", "Starbucks")
  /// [proximity] - Optional [lng, lat] to bias results near a location
  /// [limit] - Maximum number of results (default: 5)
  Future<List<PlaceResult>> searchPlaces({
    required String query,
    List<double>? proximity,
    int limit = 5,
  }) async {
    try {
      // URL encode the query
      final encodedQuery = Uri.encodeComponent(query);
      
      // Build URL with parameters
      var url = '$_baseUrl/$encodedQuery.json?access_token=$accessToken&limit=$limit';
      
      // Add proximity bias if provided (format: lng,lat)
      if (proximity != null && proximity.length == 2) {
        url += '&proximity=${proximity[0]},${proximity[1]}';
      }
      
      // Add types filter (prefer POIs, addresses, and places)
      url += '&types=poi,address,place';
      
      print('🔍 Geocoding API: $url');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        
        print('✅ Found ${features.length} results');
        
        return features.map((feature) => PlaceResult.fromJson(feature)).toList();
      } else {
        print('❌ Geocoding error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Geocoding exception: $e');
      return [];
    }
  }

  /// Get coordinates for a specific place name
  Future<PlaceResult?> getCoordinates(String placeName) async {
    final results = await searchPlaces(query: placeName, limit: 1);
    return results.isNotEmpty ? results.first : null;
  }
}

/// Model class for place search results
class PlaceResult {
  final String id;
  final String placeName;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final String? placeType; // poi, address, place, etc.
  final String? category; // restaurant, hotel, etc.

  PlaceResult({
    required this.id,
    required this.placeName,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.placeType,
    this.category,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    final center = json['center'] as List;
    final properties = json['properties'] as Map<String, dynamic>?;
    
    return PlaceResult(
      id: json['id'] ?? '',
      placeName: json['text'] ?? 'Unknown',
      fullAddress: json['place_name'] ?? '',
      longitude: center[0].toDouble(),
      latitude: center[1].toDouble(),
      placeType: json['place_type']?.first,
      category: properties?['category'],
    );
  }

  @override
  String toString() {
    return 'PlaceResult(name: $placeName, coords: ($latitude, $longitude))';
  }
}
