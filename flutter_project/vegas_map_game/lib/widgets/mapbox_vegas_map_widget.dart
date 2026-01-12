import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../models/game_models.dart';
import '../engine/game_engine.dart';
import 'neon_hotspot_pin.dart';

class MapboxVegasMapWidget extends StatefulWidget {
  final Function(VegasLocation) onLocationSelected;
  final Function(MapboxMap)? onMapCreated; // Callback to expose map instance
  
  const MapboxVegasMapWidget({
    super.key,
    required this.onLocationSelected,
    this.onMapCreated,
  });

  @override
  State<MapboxVegasMapWidget> createState() => _MapboxVegasMapWidgetState();
}

class _MapboxVegasMapWidgetState extends State<MapboxVegasMapWidget> {
  final GameEngine _gameEngine = GameEngine();
  MapboxMap? mapboxMap;
  final List<Map<String, dynamic>> _hotspots = [
    {
      'name': 'Toit Brewpub',
      'lat': 12.9718,
      'lng': 77.6408,
      'type': 'bar',
      'isLive': true
    },
    {
      'name': 'Chianti',
      'lat': 12.9714,
      'lng': 77.6398,
      'type': 'food',
      'isLive': false
    },
    {
      'name': 'Thai Refresh',
      'lat': 12.9722,
      'lng': 77.6418,
      'type': 'food',
      'isLive': false
    },
    {
      'name': 'Bloomrooms',
      'lat': 12.9708,
      'lng': 77.6422,
      'type': 'hotel',
      'isLive': false
    },
    {
      'name': 'Social',
      'lat': 12.9715,
      'lng': 77.6405,
      'type': 'bar',
      'isLive': true
    },
    {
      'name': 'Truffles',
      'lat': 12.9720,
      'lng': 77.6425,
      'type': 'food',
      'isLive': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMapboxMap(),
        // Overlay neon hotspot markers
        ..._buildNeonHotspotOverlays(),
      ],
    );
  }

  List<Widget> _buildNeonHotspotOverlays() {
    // Return empty list for now - will add positioned markers after map loads
    return [];
  }

  Widget _buildMapboxMap() {
    // Indiranagar core coordinates - cyberpunk night mode
    final center = Point(coordinates: Position(77.6412, 12.9719));
    
    final CameraOptions cameraOptions = CameraOptions(
      center: center,
      zoom: 16.0, // Perfect zoom for 3D depth
      bearing: 0, // No rotation for clean view
      pitch: 65.0, // Critical for 3D depth and ground text visibility
    );

    return MapWidget(
      cameraOptions: cameraOptions,
      styleUri: MapboxStyles.STANDARD,
      onMapCreated: _onMapCreated,
      onTapListener: _onMapTap,
    );
  }

  void _onMapCreated(MapboxMap map) async {
    mapboxMap = map;
    
    // Notify parent widget
    widget.onMapCreated?.call(map);
    
    // Enable all gestures for smooth navigation
    try {
      await map.gestures.updateSettings(GesturesSettings(
        rotateEnabled: true,
        pinchToZoomEnabled: true,
        scrollEnabled: true,
        pitchEnabled: true,
        doubleTapToZoomInEnabled: true,
        doubleTouchToZoomOutEnabled: true,
        quickZoomEnabled: true,
      ));
      print('✅ All map gestures enabled - zoom, pan, rotate, pitch');
    } catch (e) {
      print('⚠️ Gesture settings error: $e');
    }
    
    // Configure Cyberpunk Night Mode 🌃
    try {
      // Set dusk lighting for neon building lights
      await map.style.setStyleImportConfigProperty(
        "basemap",
        "lightPreset",
        "dusk", // Cyberpunk night aesthetic
      );
      
      // Show POI labels (restaurants, landmarks, etc)
      await map.style.setStyleImportConfigProperty(
        "basemap",
        "showPointOfInterestLabels",
        true, // Show location pins
      );
      
      // Show place labels (neighborhoods, districts)
      await map.style.setStyleImportConfigProperty(
        "basemap",
        "showPlaceLabels",
        true, // Show place names
      );
      
      // Show road labels (street names)
      await map.style.setStyleImportConfigProperty(
        "basemap",
        "showRoadLabels",
        true, // Show street names
      );
      
      // Enable 3D objects (critical for depth)
      await map.style.setStyleImportConfigProperty(
        "basemap",
        "show3dObjects",
        true, // 3D buildings for cyberpunk city
      );
      
      print('✅ Cyberpunk night mode enabled - 3D buildings, street names, POI pins restored');
      
    } catch (e) {
      print('⚠️ Style config error: $e');
    }
  }

  bool _onMapTap(MapContentGestureContext context) {
    final coordinate = context.point;
    print('Map tapped at: ${coordinate.coordinates.lng}, ${coordinate.coordinates.lat}');
    // Story pins handle their own tap events via GestureDetector
    return true;
  }
}
