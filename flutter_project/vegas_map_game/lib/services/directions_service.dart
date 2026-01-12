import 'dart:convert';
import 'package:http/http.dart' as http;

/// Mapbox Directions API service for route calculation
class DirectionsService {
  final String accessToken;
  static const String _baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  DirectionsService({required this.accessToken});

  /// Get driving route between two points
  /// 
  /// [startLng], [startLat] - Starting location coordinates
  /// [endLng], [endLat] - Destination coordinates
  /// [profile] - Navigation profile: 'driving', 'walking', 'cycling'
  Future<RouteResult?> getRoute({
    required double startLng,
    required double startLat,
    required double endLng,
    required double endLat,
    String profile = 'driving',
  }) async {
    try {
      // Format: lng,lat;lng,lat
      final coordinates = '$startLng,$startLat;$endLng,$endLat';
      
      // Build URL
      final url = '$_baseUrl/$profile/$coordinates?'
          'access_token=$accessToken'
          '&geometries=geojson'  // Return GeoJSON LineString
          '&overview=full'        // Full route geometry
          '&steps=true';          // Turn-by-turn instructions
      
      print('🚗 Directions API: $url');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
          print('✅ Route found');
          return RouteResult.fromJson(data['routes'][0]);
        } else {
          print('⚠️ No routes found');
          return null;
        }
      } else {
        print('❌ Directions error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Directions exception: $e');
      return null;
    }
  }
}

/// Model class for route results
class RouteResult {
  final List<List<double>> coordinates; // List of [lng, lat] points
  final double distance; // meters
  final double duration; // seconds
  final List<RouteStep> steps;

  RouteResult({
    required this.coordinates,
    required this.distance,
    required this.duration,
    required this.steps,
  });

  factory RouteResult.fromJson(Map<String, dynamic> json) {
    // Extract geometry coordinates
    final geometry = json['geometry'] as Map<String, dynamic>;
    final coords = (geometry['coordinates'] as List)
        .map<List<double>>((coord) => [
              (coord[0] as num).toDouble(),
              (coord[1] as num).toDouble()
            ])
        .toList();

    // Extract steps
    final legs = json['legs'] as List;
    final steps = <RouteStep>[];
    for (var leg in legs) {
      final legSteps = (leg['steps'] as List)
          .map((step) => RouteStep.fromJson(step))
          .toList();
      steps.addAll(legSteps);
    }

    return RouteResult(
      coordinates: coords,
      distance: json['distance'].toDouble(),
      duration: json['duration'].toDouble(),
      steps: steps,
    );
  }

  String get distanceText {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }
  }

  String get durationText {
    final minutes = (duration / 60).round();
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = (minutes / 60).floor();
      final mins = minutes % 60;
      return '$hours h $mins min';
    }
  }

  @override
  String toString() {
    return 'RouteResult(distance: $distanceText, duration: $durationText, points: ${coordinates.length})';
  }
}

/// Turn-by-turn navigation step
class RouteStep {
  final String instruction;
  final double distance;
  final double duration;
  final String? maneuver; // turn-left, turn-right, straight, etc.

  RouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    this.maneuver,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
      instruction: json['maneuver']?['instruction'] ?? '',
      distance: json['distance']?.toDouble() ?? 0.0,
      duration: json['duration']?.toDouble() ?? 0.0,
      maneuver: json['maneuver']?['type'],
    );
  }
}
