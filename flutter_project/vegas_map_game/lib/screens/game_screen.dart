import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../models/game_models.dart';
import '../engine/game_engine.dart';
import '../widgets/vegas_map_widget.dart';
import '../widgets/mapbox_vegas_map_widget.dart';
import '../widgets/spotify_nav_bar.dart';
import '../widgets/cyberpunk_search_bar.dart';
import '../services/geocoding_service.dart';
import '../services/directions_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameEngine _gameEngine = GameEngine();
  int _currentIndex = 0; // 0: Explore, 1: Scenes, 2: Karma
  final GlobalKey<_MapboxVegasMapWidgetWrapperState> _mapKey = GlobalKey();
  
  // Mapbox services for search and navigation
  late final GeocodingService _geocodingService;
  late final DirectionsService _directionsService;
  geo.Position? _currentUserLocation;
  
  // Mapbox access token (public token)
  static const String _accessToken = 'pk.eyJ1IjoidmFuYWJoaWxhc2giLCJhIjoiY2xueXp3b2MwMDQyazJsczEzaW5wZ3Q5diJ9.yS0-B-y2HQN1iXGqK0pV0A';

  @override
  void initState() {
    super.initState();
    _gameEngine.initializeGame();
    
    // Initialize Mapbox services
    _geocodingService = GeocodingService(accessToken: _accessToken);
    _directionsService = DirectionsService(accessToken: _accessToken);
    
    // Get user's current location
    _getCurrentLocation();
  }
  
  /// Get user's current location for proximity-based search and routing
  Future<void> _getCurrentLocation() async {
    try {
      // Check permissions
      geo.LocationPermission permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }
      
      if (permission == geo.LocationPermission.whileInUse || 
          permission == geo.LocationPermission.always) {
        final position = await geo.Geolocator.getCurrentPosition();
        setState(() {
          _currentUserLocation = position;
        });
        print('📍 Current location: ${position.latitude}, ${position.longitude}');
      }
    } catch (e) {
      print('❌ Location error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCurrentPage(),
          // Spotify-style glassmorphism bottom nav bar
          SpotifyNavBar(
            selectedIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return _buildExplorePage(); // Explore: Full map view
      case 1:
        return _buildScenesPage(); // Scenes: Trending/vibing places
      case 2:
        return _buildKarmaPage(); // Karma: Profile & posts
      default:
        return _buildExplorePage();
    }
  }

  Widget _buildExplorePage() {
    return Stack(
      children: [
        // Full screen map with key for external control
        _MapboxVegasMapWidgetWrapper(
          key: _mapKey,
          onLocationSelected: _showLocationDialog,
        ),
        
        // Top overlay - Cyberpunk search bar with autocomplete
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: CyberpunkSearchBar(
              geocodingService: _geocodingService,
              proximityBias: _currentUserLocation != null 
                  ? [_currentUserLocation!.longitude, _currentUserLocation!.latitude]
                  : [77.6412, 12.9716], // Default: Indiranagar
              onPlaceSelected: _onPlaceSelected,
            ),
          ),
        ),
      ],
    );
  }
  
  /// Handle place selection from search - fly to location and draw route
  Future<void> _onPlaceSelected(PlaceResult place) async {
    print('🎯 Place selected: ${place.placeName}');
    
    // 1. Fly camera to the selected location
    await _mapKey.currentState?.flyToCoordinates(
      latitude: place.latitude,
      longitude: place.longitude,
      zoom: 16.0,
      pitch: 60.0,
    );
    
    // 2. Add marker at the location
    await _mapKey.currentState?.addMarkerAtLocation(
      latitude: place.latitude,
      longitude: place.longitude,
      title: place.placeName,
    );
    
    // 3. If we have user's location, draw navigation route
    if (_currentUserLocation != null) {
      await _drawNavigationRoute(
        startLat: _currentUserLocation!.latitude,
        startLng: _currentUserLocation!.longitude,
        endLat: place.latitude,
        endLng: place.longitude,
      );
    }
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.place, color: Color(0xFF00FFFF)),
              SizedBox(width: 12),
              Expanded(
                child: Text('📍 Navigating to ${place.placeName}'),
              ),
            ],
          ),
          backgroundColor: Colors.black87,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  
  /// Draw navigation route on the map
  Future<void> _drawNavigationRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      print('🚗 Fetching route...');
      
      final route = await _directionsService.getRoute(
        startLng: startLng,
        startLat: startLat,
        endLng: endLng,
        endLat: endLat,
        profile: 'driving',
      );
      
      if (route != null) {
        print('✅ Route found: ${route.distanceText}, ${route.durationText}');
        
        // Draw the route polyline on the map
        await _mapKey.currentState?.drawRoute(route.coordinates);
        
        // Show route info
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🚗 ${route.distanceText} • ${route.durationText}'),
              backgroundColor: Colors.green[800],
              duration: Duration(seconds: 4),
            ),
          );
        }
      } else {
        print('⚠️ No route found');
      }
    } catch (e) {
      print('❌ Route error: $e');
    }
  }

  Widget _buildScenesPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple[900]!, Colors.purple[700]!, Colors.pink[400]!],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ Scenes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFBB86FC), // Neon purple
                      shadows: [
                        Shadow(
                          color: Color(0xFFBB86FC).withOpacity(0.8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Trending & vibing places nearby',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            // Hotspot cards
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildHotspotCard(
                    'Bob\'s Bar',
                    '🍺',
                    '4.8',
                    'Most happening bar in Indiranagar',
                    '2.3 km away',
                    156,
                  ),
                  _buildHotspotCard(
                    'Toit Brewpub',
                    '🍻',
                    '4.9',
                    'Craft beers and great vibes',
                    '2.5 km away',
                    203,
                  ),
                  _buildHotspotCard(
                    'Social',
                    '🍴',
                    '4.7',
                    'Co-working cafe with amazing food',
                    '2.1 km away',
                    142,
                  ),
                  _buildHotspotCard(
                    'Truffles',
                    '🍔',
                    '4.6',
                    'American diner with the best burgers',
                    '2.7 km away',
                    98,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotspotCard(String name, String icon, String rating, String description, String distance, int stories) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(icon, style: TextStyle(fontSize: 32)),
              ),
            ),
            SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.video_library, size: 14, color: Colors.purple),
                      SizedBox(width: 4),
                      Text(
                        '$stories stories',
                        style: TextStyle(fontSize: 12, color: Colors.purple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKarmaPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange[900]!, Colors.orange[700]!, Colors.yellow[600]!],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              
              // Profile section
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.orange[700]),
              ),
              SizedBox(height: 16),
              Text(
                'Explorer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildKarmaStat('Places Visited', '${_gameEngine.gameData.locationsVisited}'),
                  _buildKarmaStat('Total Score', '${_gameEngine.gameData.totalScore}'),
                  _buildKarmaStat('Stories', '0'),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Places been to
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📍 Places You\'ve Been',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ..._gameEngine.locations.where((loc) => loc.isVisited).map((loc) {
                      return ListTile(
                        leading: Text(loc.iconPath, style: TextStyle(fontSize: 24)),
                        title: Text(loc.name),
                        subtitle: Text('${loc.points} points'),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                      );
                    }).toList(),
                    if (_gameEngine.gameData.locationsVisited == 0)
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'Start exploring to see places here!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKarmaStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildMapWidget() {
    return MapboxVegasMapWidget(
      onLocationSelected: (location) {
        _showLocationDialog(location);
      },
    );
  }




  void _showLocationDialog(VegasLocation location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(location.iconPath, style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  location.name,
                  style: TextStyle(color: Colors.brown[800]),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(location.description),
              SizedBox(height: 12),
              Text('Points: ${location.points}', 
                   style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              if (location.isVisited)
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Already visited!'),
                  ],
                )
              else if (location.isDiscovered)
                Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Location discovered!'),
                  ],
                )
              else
                Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Location unknown'),
                  ],
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
            if (location.isDiscovered && !location.isVisited)
              ElevatedButton(
                onPressed: () {
                  if (_gameEngine.visitLocation(location.id)) {
                    setState(() {}); // Refresh UI
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Visited ${location.name}! +${location.points} points'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Move closer to visit this location'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                ),
                child: Text('Visit'),
              ),
          ],
        );
      },
    );
  }
}

/// Wrapper widget to expose map control methods
class _MapboxVegasMapWidgetWrapper extends StatefulWidget {
  final Function(VegasLocation) onLocationSelected;

  const _MapboxVegasMapWidgetWrapper({
    super.key,
    required this.onLocationSelected,
  });

  @override
  State<_MapboxVegasMapWidgetWrapper> createState() =>
      _MapboxVegasMapWidgetWrapperState();
}

class _MapboxVegasMapWidgetWrapperState
    extends State<_MapboxVegasMapWidgetWrapper> {
  MapboxMap? _mapboxMap;

  void setMapboxMap(MapboxMap map) {
    _mapboxMap = map;
  }

  /// Search for a location and fly the camera to it
  Future<bool> searchAndFlyTo(String query) async {
    if (_mapboxMap == null) {
      print('⚠️ Map not initialized yet');
      return false;
    }

    try {
      print('🔍 Searching for: "$query"');
      
      // Extended hotspot database
      final hotspots = [
        {'name': 'Toit', 'fullName': 'Toit Brewpub', 'lat': 12.9718, 'lng': 77.6408},
        {'name': 'Chianti', 'fullName': 'Chianti Restaurant', 'lat': 12.9714, 'lng': 77.6398},
        {'name': 'Thai', 'fullName': 'Thai Refresh', 'lat': 12.9722, 'lng': 77.6418},
        {'name': 'Bloomrooms', 'fullName': 'Bloomrooms Hotel', 'lat': 12.9708, 'lng': 77.6422},
        {'name': 'Social', 'fullName': 'Social Bar', 'lat': 12.9715, 'lng': 77.6405},
        {'name': 'Truffles', 'fullName': 'Truffles Restaurant', 'lat': 12.9720, 'lng': 77.6425},
        {'name': 'Indiranagar', 'fullName': 'Indiranagar', 'lat': 12.9716, 'lng': 77.6412},
        {'name': 'Bengaluru', 'fullName': 'Bengaluru', 'lat': 12.9716, 'lng': 77.5946},
        {'name': '100 Feet Road', 'fullName': '100 Feet Road Indiranagar', 'lat': 12.9716, 'lng': 77.6412},
        {'name': 'Bob', 'fullName': 'Bob\'s Bar', 'lat': 12.9716, 'lng': 77.6412},
      ];

      // Case-insensitive search with flexible matching
      final queryLower = query.toLowerCase().trim();
      print('🔍 Query normalized: "$queryLower"');
      
      // Try exact match first, then partial match
      var match = hotspots.firstWhere(
        (spot) => (spot['name'] as String).toLowerCase() == queryLower ||
                  (spot['fullName'] as String).toLowerCase() == queryLower,
        orElse: () => {},
      );

      // If no exact match, try partial match
      if (match.isEmpty) {
        match = hotspots.firstWhere(
          (spot) => (spot['name'] as String).toLowerCase().contains(queryLower) ||
                    (spot['fullName'] as String).toLowerCase().contains(queryLower),
          orElse: () => {},
        );
      }

      if (match.isEmpty) {
        print('❌ No match found for: "$query"');
        print('Available locations: ${hotspots.map((s) => s['name']).join(", ")}');
        return false;
      }

      print('✅ Found: ${match['fullName']} at (${match['lat']}, ${match['lng']})');

      // Fly camera to the location with smooth animation
      final targetPosition = Point(
        coordinates: Position(match['lng']! as double, match['lat']! as double),
      );

      await _mapboxMap!.flyTo(
        CameraOptions(
          center: targetPosition,
          zoom: 17.5, // Close zoom to see details
          pitch: 65.0, // 3D perspective
          bearing: 0,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );

      print('🎯 Camera flying to location');
      return true;
    } catch (e) {
      print('❌ Search error: $e');
      return false;
    }
  }
  
  /// Fly camera to specific coordinates
  Future<void> flyToCoordinates({
    required double latitude,
    required double longitude,
    double zoom = 16.0,
    double pitch = 60.0,
  }) async {
    if (_mapboxMap == null) {
      print('⚠️ Map not initialized yet');
      return;
    }
    
    try {
      final targetPosition = Point(
        coordinates: Position(longitude, latitude),
      );
      
      await _mapboxMap!.flyTo(
        CameraOptions(
          center: targetPosition,
          zoom: zoom,
          pitch: pitch,
          bearing: 0,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
      
      print('✅ Camera flew to ($latitude, $longitude)');
    } catch (e) {
      print('❌ Fly to error: $e');
    }
  }
  
  /// Add a marker/pin at a specific location
  Future<void> addMarkerAtLocation({
    required double latitude,
    required double longitude,
    required String title,
  }) async {
    if (_mapboxMap == null) {
      print('⚠️ Map not initialized yet');
      return;
    }
    
    try {
      // Create a point annotation (marker)
      final pointAnnotationManager = await _mapboxMap!.annotations.createPointAnnotationManager();
      
      final pointAnnotationOptions = PointAnnotationOptions(
        geometry: Point(coordinates: Position(longitude, latitude)),
        iconImage: "default_marker", // Use default marker icon
        iconSize: 1.5,
        iconColor: Colors.red.value,
      );
      
      await pointAnnotationManager.create(pointAnnotationOptions);
      print('📍 Marker added at ($latitude, $longitude)');
    } catch (e) {
      print('❌ Marker error: $e');
    }
  }
  
  /// Draw a route polyline on the map (neon cyan laser beam style)
  Future<void> drawRoute(List<List<double>> coordinates) async {
    if (_mapboxMap == null) {
      print('⚠️ Map not initialized yet');
      return;
    }
    
    try {
      // Convert coordinates to proper Position objects for Mapbox
      final lineCoordinates = coordinates
          .map((coord) => Position(coord[0], coord[1]))
          .toList();
      
      // Create LineString geometry
      final lineString = LineString(coordinates: lineCoordinates);
      
      // Remove existing route layer if it exists
      try {
        await _mapboxMap!.style.removeStyleLayer('route-layer');
        await _mapboxMap!.style.removeStyleSource('route-source');
      } catch (e) {
        // Layer doesn't exist yet, that's fine
      }
      
      // Create GeoJSON string from LineString
      final geoJson = '''
      {
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": ${lineString.coordinates.map((p) => [p.lng, p.lat]).toList()}
        }
      }
      ''';
      
      // Add GeoJSON source for the route
      await _mapboxMap!.style.addSource(
        GeoJsonSource(
          id: 'route-source',
          data: geoJson,
        ),
      );
      
      // Add line layer with neon cyan style (laser beam effect)
      await _mapboxMap!.style.addLayer(
        LineLayer(
          id: 'route-layer',
          sourceId: 'route-source',
          lineColor: 0xFF00FFFF, // Neon cyan
          lineWidth: 5.0,
          lineBlur: 2.0, // Glow effect
        ),
      );
      
      print('✅ Route drawn with ${coordinates.length} points');
    } catch (e) {
      print('❌ Draw route error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapboxVegasMapWidget(
      onLocationSelected: widget.onLocationSelected,
      onMapCreated: (map) {
        setMapboxMap(map);
      },
    );
  }
}