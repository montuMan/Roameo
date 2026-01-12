# Mapbox Flutter SDK - Complete Developer Guide

## Overview

Mapbox Maps SDK for Flutter v2.0+ enables building highly customizable, interactive maps for Android and iOS platforms. This guide covers essential features, APIs, and best practices for the Roameo project.

## Table of Contents

1. [Core Features](#core-features)
2. [Setup & Configuration](#setup--configuration)
3. [Map Widget & Camera Control](#map-widget--camera-control)
4. [Annotations & Markers](#annotations--markers)
5. [Style Layers & Data Sources](#style-layers--data-sources)
6. [Gesture Handling](#gesture-handling)
7. [Location Tracking](#location-tracking)
8. [Offline Maps](#offline-maps)
9. [API Services](#api-services)
10. [Best Practices](#best-practices)

---

## Core Features

### Supported Capabilities (v2.0+)
- ✅ **Custom Map Styles** - Design maps in Mapbox Studio, apply custom themes
- ✅ **Layers & Annotations** - Circle, Fill, Symbol, Line, Raster layers
- ✅ **User Location** - Built-in location tracking with permissions
- ✅ **Camera Control** - Position, animate, and manipulate camera
- ✅ **Gestures & Events** - Pan, zoom, rotate, tap, long press
- ✅ **Offline Maps** - Download and use maps without internet
- ✅ **Custom Data Sources** - GeoJSON, vector, image sources
- ✅ **3D Terrain & Buildings** - Realistic depth and elevation
- ✅ **Performance** - Optimized for large datasets
- ✅ **Snapshot Feature** - Capture static map images

### Platform Support
- **Android**: SDK 21+ (Android 5.0)
- **iOS**: iOS 14+
- **Flutter**: SDK 3.22.3+ / Dart SDK 3.4.4+
- **Note**: Web and desktop not officially supported in v2.0

---

## Setup & Configuration

### 1. Installation

Add to `pubspec.yaml`:
```yaml
dependencies:
  mapbox_maps_flutter: ^2.0.0
  geolocator: ^10.1.0           # For location services
  permission_handler: ^11.0.1    # For permissions
```

### 2. Access Token Setup

Get your token from [mapbox.com](https://account.mapbox.com/):

```dart
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  const String accessToken = 'pk.YOUR_PUBLIC_ACCESS_TOKEN';
  MapboxOptions.setAccessToken(accessToken);
  
  runApp(MyApp());
}
```

### 3. Platform Permissions

#### Android (`AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS (`Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby places</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to track your journey</string>
```

---

## Map Widget & Camera Control

### Basic Map Setup

```dart
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

MapWidget(
  styleUri: MapboxStyles.STANDARD,  // or MAPBOX_STREETS, SATELLITE_STREETS
  cameraOptions: CameraOptions(
    center: Point(coordinates: Position(longitude, latitude)),
    zoom: 15.0,
    bearing: 0.0,    // Rotation in degrees
    pitch: 60.0,     // Tilt angle (0-85 degrees)
  ),
  onMapCreated: _onMapCreated,
  onTapListener: _onMapTap,
)
```

### Camera Animation Methods

#### flyTo - Dynamic Flight Animation
```dart
await mapboxMap.flyTo(
  CameraOptions(
    center: Point(coordinates: Position(lng, lat)),
    zoom: 17.0,
    bearing: 180,
    pitch: 45,
  ),
  MapAnimationOptions(
    duration: 2000,  // milliseconds
    startDelay: 0,
  ),
);
```

#### easeTo - Smooth Transition
```dart
await mapboxMap.easeTo(
  CameraOptions(
    center: Point(coordinates: Position(lng, lat)),
    zoom: 15.0,
  ),
  MapAnimationOptions(
    duration: 1500,
    startDelay: 0,
  ),
);
```

#### setCamera - Instant Jump (No Animation)
```dart
mapboxMap.setCamera(
  CameraOptions(
    center: Point(coordinates: Position(lng, lat)),
    zoom: 14.0,
  ),
);
```

### Camera Position Query
```dart
CameraState cameraState = await mapboxMap.getCameraState();
print('Current zoom: ${cameraState.zoom}');
print('Current center: ${cameraState.center}');
```

---

## Annotations & Markers

Annotations are interactive elements on the map. Use annotation managers for moderate numbers of markers.

### Point Annotations (Markers)

```dart
MapboxMap? mapboxMap;

void _onMapCreated(MapboxMap map) async {
  mapboxMap = map;
  
  // Create point annotation manager
  final pointManager = await map.annotations.createPointAnnotationManager();
  
  // Load image for marker
  final ByteData bytes = await rootBundle.load('assets/marker.png');
  final Uint8List imageData = bytes.buffer.asUint8List();
  
  // Add marker
  final pointAnnotation = PointAnnotationOptions(
    geometry: Point(coordinates: Position(longitude, latitude)),
    image: imageData,
    iconSize: 1.5,
    iconOffset: [0.0, -20.0],  // Offset from anchor point
    textField: 'Marker Label',
    textOffset: [0.0, 2.0],
  );
  
  await pointManager.create(pointAnnotation);
  
  // Listen to tap events
  pointManager.addOnPointAnnotationClickListener((annotation) {
    print('Annotation tapped: ${annotation.id}');
  });
}
```

### Circle Annotations

```dart
final circleManager = await mapboxMap.annotations.createCircleAnnotationManager();

final circleAnnotation = CircleAnnotationOptions(
  geometry: Point(coordinates: Position(lng, lat)),
  circleRadius: 50.0,        // In pixels
  circleColor: Colors.blue.value,
  circleOpacity: 0.5,
  circleStrokeWidth: 2.0,
  circleStrokeColor: Colors.white.value,
);

await circleManager.create(circleAnnotation);
```

### Polyline Annotations (Routes)

```dart
final polylineManager = await mapboxMap.annotations.createPolylineAnnotationManager();

final route = [
  Position(lng1, lat1),
  Position(lng2, lat2),
  Position(lng3, lat3),
];

final polylineAnnotation = PolylineAnnotationOptions(
  geometry: LineString(coordinates: route),
  lineColor: Colors.red.value,
  lineWidth: 5.0,
  lineOpacity: 0.8,
);

await polylineManager.create(polylineAnnotation);
```

### Polygon Annotations (Areas)

```dart
final polygonManager = await mapboxMap.annotations.createPolygonAnnotationManager();

final area = [
  [Position(lng1, lat1), Position(lng2, lat2), Position(lng3, lat3), Position(lng1, lat1)]
];

final polygonAnnotation = PolygonAnnotationOptions(
  geometry: Polygon(coordinates: area),
  fillColor: Colors.green.value,
  fillOpacity: 0.3,
  fillOutlineColor: Colors.darkGreen.value,
);

await polygonManager.create(polygonAnnotation);
```

---

## Style Layers & Data Sources

For high-performance rendering of many features, use style layers instead of annotations.

### Adding GeoJSON Source

```dart
// Load GeoJSON from asset
String geojsonString = await rootBundle.loadString('assets/data.geojson');

// Add source to map
await mapboxMap.style.addSource(
  'my-source',
  GeoJsonSource(
    id: 'my-source',
    data: geojsonString,
  ),
);
```

### Symbol Layer (Icons/Text)

```dart
await mapboxMap.style.addLayer(
  SymbolLayer(
    id: 'symbol-layer',
    sourceId: 'my-source',
    iconImage: 'marker-icon',
    iconSize: 1.5,
    textField: '{name}',  // Use GeoJSON property
    textSize: 12.0,
    textOffset: [0.0, 1.5],
  ),
);
```

### Line Layer (Routes/Paths)

```dart
await mapboxMap.style.addLayer(
  LineLayer(
    id: 'line-layer',
    sourceId: 'my-source',
    lineColor: '#FF0000',
    lineWidth: 4.0,
    lineOpacity: 0.8,
    lineCap: LineCap.ROUND,
    lineJoin: LineJoin.ROUND,
  ),
);
```

### Fill Layer (Polygons)

```dart
await mapboxMap.style.addLayer(
  FillLayer(
    id: 'fill-layer',
    sourceId: 'my-source',
    fillColor: '#00FF00',
    fillOpacity: 0.5,
    fillOutlineColor: '#008800',
  ),
);
```

### Data-Driven Styling (Expressions)

```dart
// Color based on property value
FillLayer(
  id: 'dynamic-fill',
  sourceId: 'my-source',
  fillColor: [
    'match',
    ['get', 'type'],
    'restaurant', '#FF6B6B',
    'cafe', '#4ECDC4',
    'bar', '#FFE66D',
    '#CCCCCC'  // default
  ],
  fillOpacity: [
    'interpolate',
    ['linear'],
    ['zoom'],
    10, 0.3,
    15, 0.7,
    20, 1.0
  ],
)
```

---

## Gesture Handling

### Configure Gestures

```dart
void _onMapCreated(MapboxMap map) async {
  await map.gestures.updateSettings(GesturesSettings(
    rotateEnabled: true,
    pinchToZoomEnabled: true,
    scrollEnabled: true,
    pitchEnabled: true,
    doubleTapToZoomInEnabled: true,
    doubleTouchToZoomOutEnabled: true,
    quickZoomEnabled: true,
  ));
}
```

### Tap Events

```dart
MapWidget(
  onTapListener: (MapContentGestureContext context) {
    final point = context.point;
    final lng = point.coordinates.lng;
    final lat = point.coordinates.lat;
    
    print('Map tapped at: $lng, $lat');
    
    // Add marker at tap location
    _addMarkerAtPosition(lng, lat);
    
    return true;  // Event handled
  },
)
```

### Long Press Events

```dart
MapWidget(
  onLongTapListener: (MapContentGestureContext context) {
    print('Long press at: ${context.point.coordinates}');
    _showContextMenu(context.point);
    return true;
  },
)
```

### Query Features at Point

```dart
void _onMapTap(MapContentGestureContext context) async {
  final screenCoordinate = context.touchPosition;
  
  // Query rendered features at tap point
  final features = await mapboxMap.queryRenderedFeatures(
    RenderedQueryGeometry(screenCoordinate: screenCoordinate),
    RenderedQueryOptions(
      layerIds: ['poi-layer', 'restaurant-layer'],
    ),
  );
  
  if (features.isNotEmpty) {
    final feature = features.first;
    print('Feature properties: ${feature.feature['properties']}');
  }
}
```

---

## Location Tracking

### Enable Location Component (Puck)

```dart
void _onMapCreated(MapboxMap map) async {
  // Request permissions first
  await _requestLocationPermission();
  
  // Enable location puck
  await map.location.updateSettings(
    LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      pulsingMaxRadius: 50.0,
      showAccuracyRing: true,
    ),
  );
}

Future<void> _requestLocationPermission() async {
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
}
```

### Get User Location

```dart
// Using geolocator package
Position position = await Geolocator.getCurrentPosition();
print('User at: ${position.latitude}, ${position.longitude}');

// Move camera to user location
await mapboxMap.flyTo(
  CameraOptions(
    center: Point(coordinates: Position(position.longitude, position.latitude)),
    zoom: 16.0,
  ),
  MapAnimationOptions(duration: 2000),
);
```

### Custom Location Puck (3D Model)

```dart
await map.location.updateSettings(
  LocationComponentSettings(
    enabled: true,
    locationPuck: LocationPuck(
      locationPuck3D: LocationPuck3D(
        modelUri: 'https://example.com/3d-model.gltf',
        modelScale: [1.0, 1.0, 1.0],
      ),
    ),
  ),
);
```

---

## Offline Maps

### Download Offline Tiles

```dart
final offlineManager = OfflineManager();
final tileStore = TileStore.instance;

// Define region to download
final geometry = {
  "type": "Polygon",
  "coordinates": [[
    [lng1, lat1],
    [lng2, lat1],
    [lng2, lat2],
    [lng1, lat2],
    [lng1, lat1],
  ]]
};

// Download style pack
final stylePackLoadOptions = StylePackLoadOptions(
  glyphsRasterizationMode: GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
  metadata: {"region": "bengaluru"},
);

offlineManager.loadStylePack(
  MapboxStyles.STANDARD,
  stylePackLoadOptions,
  (progress) {
    print('Style pack progress: ${progress.completedResourceCount}/${progress.requiredResourceCount}');
  },
);

// Download tile region
final tileRegionLoadOptions = TileRegionLoadOptions(
  geometry: geometry,
  descriptorsOptions: [
    TilesetDescriptorOptions(
      styleURI: MapboxStyles.STANDARD,
      minZoom: 0,
      maxZoom: 16,
    ),
  ],
);

tileStore.loadTileRegion(
  'bengaluru-region',
  tileRegionLoadOptions,
  (progress) {
    print('Tile region progress: ${progress.completedResourceCount}/${progress.requiredResourceCount}');
  },
);
```

### Remove Offline Data

```dart
await tileStore.removeTileRegion('bengaluru-region');
await offlineManager.removeStylePack(MapboxStyles.STANDARD);
```

---

## API Services

### Geocoding Service (Search Places)

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeocodingService {
  final String accessToken;
  static const String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';

  GeocodingService({required this.accessToken});

  Future<List<PlaceResult>> searchPlaces({
    required String query,
    List<double>? proximity,  // [lng, lat]
    int limit = 5,
  }) async {
    final encodedQuery = Uri.encodeComponent(query);
    var url = '$baseUrl/$encodedQuery.json?access_token=$accessToken&limit=$limit';
    
    if (proximity != null && proximity.length == 2) {
      url += '&proximity=${proximity[0]},${proximity[1]}';
    }
    
    url += '&types=poi,address,place';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'] as List;
      return features.map((f) => PlaceResult.fromJson(f)).toList();
    }
    
    return [];
  }
}

class PlaceResult {
  final String placeName;
  final double latitude;
  final double longitude;
  final String fullAddress;

  PlaceResult({
    required this.placeName,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    final center = json['center'] as List;
    return PlaceResult(
      placeName: json['text'] ?? '',
      fullAddress: json['place_name'] ?? '',
      longitude: center[0].toDouble(),
      latitude: center[1].toDouble(),
    );
  }
}
```

### Directions Service (Get Routes)

```dart
class DirectionsService {
  final String accessToken;
  static const String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';

  DirectionsService({required this.accessToken});

  Future<RouteResult?> getRoute({
    required double startLng,
    required double startLat,
    required double endLng,
    required double endLat,
    String profile = 'driving',  // driving, walking, cycling
  }) async {
    final coordinates = '$startLng,$startLat;$endLng,$endLat';
    final url = '$baseUrl/$profile/$coordinates?'
        'access_token=$accessToken'
        '&geometries=geojson'
        '&overview=full'
        '&steps=true';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && (data['routes'] as List).isNotEmpty) {
        return RouteResult.fromJson(data['routes'][0]);
      }
    }
    
    return null;
  }
}

class RouteResult {
  final List<List<double>> coordinates;
  final double distance;  // meters
  final double duration;  // seconds

  RouteResult({
    required this.coordinates,
    required this.distance,
    required this.duration,
  });

  factory RouteResult.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>;
    final coords = (geometry['coordinates'] as List)
        .map<List<double>>((c) => [c[0].toDouble(), c[1].toDouble()])
        .toList();
    
    return RouteResult(
      coordinates: coords,
      distance: json['distance'].toDouble(),
      duration: json['duration'].toDouble(),
    );
  }
  
  String get distanceText {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} m';
    }
    return '${(distance / 1000).toStringAsFixed(1)} km';
  }
  
  String get durationText {
    final minutes = (duration / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = (minutes / 60).floor();
    final mins = minutes % 60;
    return '$hours h $mins min';
  }
}
```

---

## Best Practices

### Performance Optimization

1. **Use Style Layers for Large Datasets**
   - Annotations: Good for < 100 interactive markers
   - Style Layers: Better for 100+ features

2. **Minimize Layer Count**
   - Combine similar features into one layer with expressions
   - Remove unused layers

3. **Optimize GeoJSON**
   - Simplify geometries (reduce coordinate precision)
   - Use vector tiles for very large datasets

4. **Camera Animation**
   - Use `easeTo` for short distances
   - Use `flyTo` for dramatic transitions
   - Avoid rapid successive animations

### Memory Management

```dart
@override
void dispose() {
  // Clean up annotation managers
  pointManager?.deleteAll();
  circleManager?.deleteAll();
  
  // Remove listeners
  pointManager?.removeOnPointAnnotationClickListener(listener);
  
  super.dispose();
}
```

### Error Handling

```dart
void _onMapCreated(MapboxMap map) async {
  try {
    await map.location.updateSettings(LocationComponentSettings(enabled: true));
  } catch (e) {
    print('Location error: $e');
    // Show fallback UI
  }
  
  try {
    await map.style.addSource('my-source', geojsonSource);
  } on MapboxMapsException catch (e) {
    print('Style error: ${e.message}');
  }
}
```

### Security Best Practices

1. **Token Management**
   - Use public tokens only (starts with `pk.`)
   - Never commit tokens to version control
   - Use environment variables or secure storage

2. **API Rate Limits**
   - Cache geocoding results
   - Debounce search queries
   - Implement retry logic with exponential backoff

3. **Data Privacy**
   - Request minimum necessary location permissions
   - Clear user data when appropriate
   - Respect user's location settings

---

## Common Patterns in Roameo

### Map Configuration for Indiranagar

```dart
final CameraOptions cameraOptions = CameraOptions(
  center: Point(coordinates: Position(77.6412, 12.9719)),  // Indiranagar
  zoom: 16.0,
  bearing: 0,
  pitch: 65.0,  // 3D depth
);

MapWidget(
  styleUri: MapboxStyles.STANDARD,
  cameraOptions: cameraOptions,
  onMapCreated: _onMapCreated,
)
```

### Cyberpunk Night Mode Styling

```dart
void _onMapCreated(MapboxMap map) async {
  // Night aesthetic
  await map.style.setStyleImportConfigProperty(
    "basemap",
    "lightPreset",
    "dusk",
  );
  
  // Enable 3D buildings
  await map.style.setStyleImportConfigProperty(
    "basemap",
    "show3dObjects",
    true,
  );
  
  // Show POI labels
  await map.style.setStyleImportConfigProperty(
    "basemap",
    "showPointOfInterestLabels",
    true,
  );
}
```

### Search with Proximity Bias

```dart
final geocodingService = GeocodingService(accessToken: accessToken);

// Search near current location
final results = await geocodingService.searchPlaces(
  query: userQuery,
  proximity: [currentLng, currentLat],
  limit: 5,
);
```

---

## Resources

### Official Documentation
- [Mapbox Flutter API Reference](https://docs.mapbox.com/flutter/maps/api-reference/)
- [Getting Started Guide](https://docs.mapbox.com/flutter/maps/guides/install/)
- [GitHub Repository](https://github.com/mapbox/mapbox-maps-flutter)
- [Pub.dev Package](https://pub.dev/packages/mapbox_maps_flutter)

### Tutorials & Examples
- [Official Examples](https://github.com/mapbox/mapbox-maps-flutter/tree/main/example)
- [Mapbox Studio](https://studio.mapbox.com/) - Design custom map styles
- [Style Specification](https://docs.mapbox.com/mapbox-gl-js/style-spec/)

### Community
- [Stack Overflow Tag](https://stackoverflow.com/questions/tagged/mapbox-flutter)
- [Mapbox Community Forum](https://community.mapbox.com/)

---

## Version History

- **v2.0.0** (Current in Roameo)
  - Stable release for Android/iOS
  - Full annotation support
  - 3D buildings and terrain
  - Offline map support
  - Comprehensive gesture handling

---

**Last Updated**: January 2026  
**Roameo Integration**: Active development using Mapbox Flutter SDK v2.0.0
